#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\name_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\_spawn_manager_debug;

/*
 * Spawn Manager
 *
 * Initial implementation: Stephen McCaul and June Park 3/09
 *
 * Additional work: Sumeet Jakatdar and Brian Barnes
 *
**/

#namespace spawn_manager;

function autoexec __init__sytem__() {     system::register("spawn_manager",&__init__,undefined,undefined);    }

// --------------------------------------------------------------------------------
// ---- Init function for spawn manager, called from _load.gsc ----
// --------------------------------------------------------------------------------

function __init__()
{
	level.spawn_manager_total_count = 0;
	level.spawn_manager_max_ai = 50;
	level.spawn_manager_active_ai = 0;
	level.spawn_manager_auto_targetname_num = 0;
	level.spawn_managers = [];
	level.spawn_managers = GetEntArray( "spawn_manager", "classname" );
	
	// Initiate the thinking for all the spawn managers in the level.
	array::thread_all( level.spawn_managers, &spawn_manager_think );
	start_triggers();
	
/#
	callback::on_connect( &on_player_connect );
	//  Debug functions
	level thread spawn_manager_debug();
	//level thread spawn_manager_debug_spawner_values();
#/
}

// --------------------------------------------------------------------------------
// ---- spawn manager setup - sets up the spawn manager first time it is enabled. ----
// --------------------------------------------------------------------------------

function spawn_manager_setup()
{
	Assert( isdefined( self ) );
	Assert( isdefined( self.target ) );

	//-----------------------------------------------------------------------------------------------
	// sm_group_size - The number of AI that can spawn from a spawner at once. Default = 1.
	// Supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	assert( self.sm_group_size_max >= self.sm_group_size_min, "Max range should be greater or equal to the min value for sm_count on spawn manager " + self.sm_id );

	//-----------------------------------------------------------------------------------------------
	// sm_spawner_count - The number of spawners that spawn manager will randomly select from the full
	// set of the available spawners, defaults to number of spawners in the spawn manager.
	// Supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	if ( !isdefined( self.sm_spawner_count_min ) || ( self.sm_spawner_count_min > self.allSpawners.size ) )
	{
		self.sm_spawner_count_min = self.allSpawners.size;
	}

	if ( !isdefined( self.sm_spawner_count_max ) || ( self.sm_spawner_count_max > self.allSpawners.size ) )
	{
		self.sm_spawner_count_max = self.allSpawners.size;
	}

	assert( self.sm_spawner_count_max >= self.sm_spawner_count_min, "Max range should be greater or equal to the min value for sm_count on spawn manager " + self.sm_id );
	self.sm_spawner_count = RandomIntRange( self.sm_spawner_count_min, self.sm_spawner_count_max + 1 );
	
	// Grab all the spawners and store it on spawn manager entity.
	self.spawners = self spawn_manager_get_spawners();
	
	update_for_coop();

	//-----------------------------------------------------------------------------------------------
	// sm_active_count - Total number of AI that can be active from this spawn manager,
	// supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------
	
	assert( self.sm_group_size_min <= self.sm_active_count_max, "Min group size is bigger than max active count." );
	
	//-----------------------------------------------------------------------------------------------
	// script_forcespawn - Specific to spawn manager. AI spwaned from this spawn manager will use stalingrad spawn.
	//-----------------------------------------------------------------------------------------------

	if ( !isdefined( self.script_forcespawn ) )
	{
		self.script_forcespawn = 0;
	}
}

// --------------------------------------------------------------------------------
// ---- Spawn manager spawn functions, spawns the individual AI or in group ----
// --------------------------------------------------------------------------------

// Returns true if AI can be spawned from this spawn manager currently.
function spawn_manager_can_spawn( spawnGroupSize )
{
	// Get number of AI remaining to spawn from this spawn manager.
	totalFree = ( self.count >= 0 ? self.count : level.spawn_manager_max_ai );
	
	// Get the number of active AIs remaining to spawn from this spawn manager.
	activeFree = self.sm_active_count_max - self.activeAI.size;
	
	// Spawn manager can spawn a group if activeFree and totalFree count is greater than the sm_group_size.
	canSpawnGroup =  ( activeFree >= spawnGroupSize )
	                 && ( totalFree >=  spawnGroupSize )
	                 && ( spawnGroupSize > 0 );
	
	// Total number of AI allowed to spawn against the max AI from any spawn manager.
	globalFree = level.spawn_manager_max_ai - level.spawn_manager_active_ai;
	
	// Just to make sure that the state flags are not tampered by the level script
	assert( self.enable == level flag::get( "sm_" + self.sm_id + "_enabled" ), "Spawn manager flags should not be set by the level script." );

	// If there is a forcespawn on the spawn manager, then dont check against the groupspawn and global count.
	if ( self.script_forcespawn == 0 )
	{
		return ( totalFree > 0 ) // within total count
		       && ( activeFree > 0 ) // within active count
		       && ( globalFree > 0 ) // within global count
		       && canSpawnGroup    // within group size
		       && self.enable;	    // spawner enabled
	}
	else
	{
		return ( totalFree > 0 ) // within total count
		       && ( activeFree > 0 ) // within active count
		       && self.enable;      // spawner enabled
	}
}


function spawn_manager_spawn( maxDelay )
{
	self endon ( "death" );
	start = GetTime();

	while ( true )
	{
		ai = self spawner::spawn();

		if ( isdefined( ai ) || ( ( GetTime() - start ) > ( 1000 * maxDelay ) ) )
		{
			//return if we spawned successfully or we ran out of time
			return ai;
		}
		
		wait .5;//Wait a bit to help telefrag checks
	}
}


function spawn_manager_spawn_group( /*manager, */spawner, spawnGroupSize )
{
	for ( i = 0; i < spawnGroupSize; i++ )
	{
		ai = undefined;

		if ( isdefined( spawner ) && isdefined( spawner.targetname ) ) // TFLAME 7/9/09 make sure this spawner wasn't deleted by script_killspawner
		{
			ai = spawner spawn_manager_spawn( 2.0 );
			if ( isdefined( ai ) )
			{
				ai.sm_id = self.sm_id;
			}
		}
		else
		{
			continue;
		}

		if ( !spawner::spawn_failed( ai ) )
		{
			if ( isdefined( self.script_radius ) )
			{
				ai.script_radius = self.script_radius;
			}

			if ( isdefined( spawner.script_radius ) )
			{
				ai.script_radius = spawner.script_radius;
			}

			ai thread spawn_accounting( spawner, self );
		}
	}
}

function spawn_accounting( spawner, manager )
{
	targetname = manager.targetname;
	classname = spawner.classname;
	level.spawn_manager_total_count++;
	manager.spawnCount++;
	
	if ( manager.count > 0 )
	{
		manager.count--;
	}
	
	level.spawn_manager_active_ai++;
	origin = spawner.origin;
	manager.activeAI[manager.activeAI.size] = self;
	spawner.activeAI[spawner.activeAI.size] = self;
	self waittill( "death" );

	if ( isdefined( spawner ) )
	{
		ArrayRemoveValue( spawner.activeAI, self );
	}

	if ( isdefined( manager ) )
	{
		ArrayRemoveValue( manager.activeAI, self );
	}

	level.spawn_manager_active_ai--;
	//bbprint("spawn_manager_spawns: manager %s event death classname %s posx %f posy %f posz %f", targetname, classname, origin[0], origin[1], origin[2]);
}

function set_defaults()
{
	if ( isdefined( self.name ) )
	{
		/#
			check_name( self.name );
		#/
		
		self.sm_id = self.name;
	}
	else if ( isdefined( self.targetname ) && !StrStartsWith( self.targetname, "pf" ) )
	{
		/#
			check_name( self.targetname );
		#/
		
		self.sm_id = self.targetname;
	}
	else
	{
		auto_id();
	}
	
	if(!isdefined(self.sm_count_1player))self.sm_count_1player=self.count;
	if(!isdefined(self.sm_active_count_min_1player))self.sm_active_count_min_1player=(isdefined(self.sm_active_count_min)?self.sm_active_count_min:level.spawn_manager_max_ai);
	if(!isdefined(self.sm_active_count_max_1player))self.sm_active_count_max_1player=(isdefined(self.sm_active_count_max)?self.sm_active_count_max:level.spawn_manager_max_ai);
	
	if(!isdefined(self.sm_group_size_min_1player))self.sm_group_size_min_1player=(isdefined(self.sm_group_size_min)?self.sm_group_size_min:1);
	if(!isdefined(self.sm_group_size_max_1player))self.sm_group_size_max_1player=(isdefined(self.sm_group_size_max)?self.sm_group_size_max:1);
}

/#
function check_name( str_name )
{
	a_spawn_managers = GetEntArray( "spawn_manager", "classname" );
	foreach ( sm in a_spawn_managers )
	{
		if ( sm != self )
		{
			if ( ( sm.targetname === str_name ) || ( sm.name === str_name ) )
			{
				AssertMsg( "Two spawn managers found with the same id (\"" + str_name + "\") at these origins: " + self.origin + ", and: " + sm.origin );
			}
		}
	}	
}
#/

function auto_id()
{
	if(!isdefined(level.sm_auto_id))level.sm_auto_id=0;
	self.sm_id = "sm_auto" + level.sm_auto_id;
	level.sm_auto_id++;
}

function update_count_for_coop()
{
	if ( level.players.size >= 4 && isdefined( self.sm_count_4player ) )
	{
		n_count = self.sm_count_4player;
	}
	else if ( level.players.size >= 3 && isdefined( self.sm_count_3player ) )
	{
		n_count = self.sm_count_3player;
	}
	else if ( level.players.size >= 2 && isdefined( self.sm_count_2player ) )
	{
		n_count = self.sm_count_2player;
	}
	else
	{
		n_count = self.sm_count_1player;
	}
	
	if ( n_count > 0 )
	{
		self.count = n_count;
		
		// bbarnes - this is what we need if we want to update counts while the spawn manager
		// is active (for hot-join) but that causes other problem, so for now I'm just updating
		// counts when the spawn manager starts, before anything spawns
		//self.count = n_count - self.spawnCount;
		//CLAMP_MIN( self.count, 0 );
	}
	else
	{
		self.count = -1;
	}
}

//
// COOP SCALING - ACTIVE COUNT
//
function update_active_count_min_for_coop()
{
	if ( level.players.size >= 4 && isdefined( self.sm_active_count_min_4player ) )
	{
		self.sm_active_count_min = self.sm_active_count_min_4player;
	}
	else if ( level.players.size >= 3 && isdefined( self.sm_active_count_min_3player ) )
	{
		self.sm_active_count_min = self.sm_active_count_min_3player;
	}
	else if ( level.players.size >= 2 && isdefined( self.sm_active_count_min_2player ) )
	{
		self.sm_active_count_min = self.sm_active_count_min_2player;
	}
	else
	{
		self.sm_active_count_min = self.sm_active_count_min_1player;
	}
}

function update_active_count_max_for_coop()
{
	if ( level.players.size >= 4 && isdefined( self.sm_active_count_max_4player ) )
	{
		self.sm_active_count_max = self.sm_active_count_max_4player;
	}
	else if ( level.players.size >= 3 && isdefined( self.sm_active_count_max_3player ) )
	{
		self.sm_active_count_max = self.sm_active_count_max_3player;
	}
	else if ( level.players.size >= 2 && isdefined( self.sm_active_count_max_2player ) )
	{
		self.sm_active_count_max = self.sm_active_count_max_2player;
	}
	else
	{
		self.sm_active_count_max = self.sm_active_count_max_1player;
	}
}

//
// COOP SCALING - GROUP SIZE
//
function update_group_size_min_for_coop()
{
	if ( level.players.size >= 4 && isdefined( self.sm_group_size_min_4player ) )
	{
		self.sm_group_size_min = self.sm_group_size_min_4player;
	}
	else if ( level.players.size >= 3 && isdefined( self.sm_group_size_min_3player ) )
	{
		self.sm_group_size_min = self.sm_group_size_min_3player;
	}
	else if ( level.players.size >= 2 && isdefined( self.sm_group_size_min_2player ) )
	{
		self.sm_group_size_min = self.sm_group_size_min_2player;
	}
	else
	{
		self.sm_group_size_min = self.sm_group_size_min_1player;
	}
}

function update_group_size_max_for_coop()
{
	if ( level.players.size >= 4 && isdefined( self.sm_group_size_max_4player ) )
	{
		self.sm_group_size_max = self.sm_group_size_max_4player;
	}
	else if ( level.players.size >= 3 && isdefined( self.sm_group_size_max_3player ) )
	{
		self.sm_group_size_max = self.sm_group_size_max_3player;
	}
	else if ( level.players.size >= 2 && isdefined( self.sm_group_size_max_2player ) )
	{
		self.sm_group_size_max = self.sm_group_size_max_2player;
	}
	else
	{
		self.sm_group_size_max = self.sm_group_size_max_1player;
	}
}

function update_for_coop()
{
	update_count_for_coop();
	
	update_active_count_min_for_coop();
	update_active_count_max_for_coop();
	
	update_group_size_min_for_coop();
	update_group_size_max_for_coop();
	
	foreach ( sp in self.spawners )
	{
		sp update_count_for_coop();
		
		sp update_active_count_min_for_coop();
		sp update_active_count_max_for_coop();
	}
}

function spawn_manager_wave_wait()
{
	if(!isdefined(self.sm_wave_wait_min))self.sm_wave_wait_min=0;
	if(!isdefined(self.sm_wave_wait_max))self.sm_wave_wait_max=0;
	
	if ( ( self.sm_wave_wait_max > 0 ) && ( self.sm_wave_wait_max > self.sm_wave_wait_min ) )
	{
		wait RandomFloatRange( self.sm_wave_wait_min, self.sm_wave_wait_max );
	}
	else if ( self.sm_wave_wait_min > 0 )
	{
		wait self.sm_wave_wait_min;
	}
}

// --------------------------------------------------------------------------------
// ---- Spawn manager think functions ----
// --------------------------------------------------------------------------------

function spawn_manager_think()
{
	self endon( "death" );
	
	self set_defaults();
	
	self spawn_manager_flags_setup(); // Initialize the spawn manager state flags
	self thread spawn_manager_enable_think();
	self thread spawn_manager_kill_think();
	
	self.enable = false;
	self.activeAI = [];		// stores number of currently active AI from the spawn manager.
	self.spawnCount = 0;
	isFirstTime = true;
	
	// Store all the spawners for reference
	self.allSpawners = GetEntArray( self.target, "targetname" );
	assert( self.allSpawners.size, "Spawn manager '" + self.sm_id + "' doesn't target any spawners." );
	
	level flag::wait_till( "sm_" + self.sm_id + "_enabled" );
	
	// Wait for random time between min and max of script_delay.
	util::script_delay();
	
	self spawn_manager_setup();
	
	b_spawn_up = true; // spawn up to max active, or wait for min active before spawning more
	
	self spawn_manager_get_spawn_group_size();

	while ( ( self.count != 0 ) && ( self.spawners.size > 0 ) )
	{
		cleanup_spawners();
		
		n_active = self.activeAI.size;
		n_active_budget = self.sm_active_count_max - n_active;
		
		if ( !b_spawn_up && ( self.activeAI.size <= self.sm_active_count_min ) )
		{
			b_spawn_up = true;
			spawn_manager_wave_wait();
		}
		else if ( b_spawn_up && ( n_active_budget < self.sm_group_size ) )
		{
			b_spawn_up = false;
		}
		
		if ( !b_spawn_up )
		{
			wait .05;
			continue;
		}
		
		// Calculate self.sm_group_size
		self spawn_manager_get_spawn_group_size();
		
		// If the spawnGroupSize we are waiting on is going above the spawn manager count then modify it.
		if ( self.count > 0 )
		{
			if (self.sm_group_size > self.count) {     self.sm_group_size = self.count;    };
		}
		
		spawned = false;
		
		while ( !spawned )
		{
			cleanup_spawners();

			// if there are no spawners left, break out of it
			if ( self.spawners.size <= 0 )
			{
				break;
			}

			if ( self spawn_manager_can_spawn( self.sm_group_size ) )
			{
				Assert( self.sm_group_size > 0 );
				// create a list of potential spawners based on the selected group size
				potential_spawners = [];
				priority_spawners = [];

				for ( i = 0; i < self.spawners.size; i++ )
				{
					current_spawner = self.spawners[i];

					if ( isdefined( current_spawner ) )
					{
						if ( current_spawner.activeAI.size > current_spawner.sm_active_count_min )
						{
							// wait until this spawner is at its min active count before spawning more
							continue;
						}
						
						spawnerFree = current_spawner.sm_active_count_max - current_spawner.activeAI.size;

						if ( spawnerFree >= self.sm_group_size )
						{
							if ( (isdefined(current_spawner.spawnflags)&&((current_spawner.spawnflags & 32) == 32)) )
							{
								priority_spawners[priority_spawners.size] = current_spawner;
							}
							else
							{
								potential_spawners[potential_spawners.size] = current_spawner;
							}
						}
					}
				}

				if ( potential_spawners.size > 0 || priority_spawners.size > 0 )
				{
					if ( priority_spawners.size > 0 )
					{
						spawner = array::random( priority_spawners );
					}
					else
					{
						spawner = array::random( potential_spawners );
					}

					// If count for this spawner is smaller than the sm_group_size then
					// sm_group_size has to be modified to be spawner count.

					if ( !(isdefined(spawner.spawnflags)&&((spawner.spawnflags & 64) == 64)) && ( spawner.count < self.sm_group_size ) )
					{
						self.sm_group_size = spawner.count;
					}

					// Wait for random time between min and max of script_wait.
					// Do not do this on the first iteration
					if ( !isFirstTime )
					{
						//-----------------------------------------------------------------------------------------------
						// script_wait - Specific to spawn manager. Time between subsequent spawns from the spawn manager.
						//-----------------------------------------------------------------------------------------------
						spawn_manager_wait();
					}
					else
					{
						isFirstTime = false;
					}

					// if spawn manager is disabled while the script wait, then don't spawn, just continue.
					if ( !self.enable )
					{
						continue;
					}

					self spawn_manager_spawn_group( /*self, */spawner, self.sm_group_size );
					spawned = true;
				}
				else
				{
					// not a single spawner found for the given sm_group_size
					// find the largest one and use that as sm_group_size_max
					spawner_max_active_count = 0;

					for ( i = 0; i < self.spawners.size; i++ )
					{
						current_spawner = self.spawners[i];

						if ( isdefined( current_spawner ) )
						{
							if ( current_spawner.sm_active_count_max > spawner_max_active_count )
							{
								spawner_max_active_count = current_spawner.sm_active_count_max;
							}
						}
					}

					if ( spawner_max_active_count < self.sm_group_size_max )
					{
						self.sm_group_size_max = spawner_max_active_count;
						self spawn_manager_get_spawn_group_size();	// recalculate group size
					}
				}
			}

			{wait(.05);};
		}

		{wait(.05);};
		
		// Asserts to ensure that level script is not fiddling with spawn manager flags
		assert( !level flag::get( "sm_" + self.sm_id + "_killed" ), "Spawn manager flags should not be set by the level script." );
		assert( !level flag::get( "sm_" + self.sm_id + "_complete" ), "Spawn manager flags should not be set by the level script." );

		if ( !( isdefined( self.script_forcespawn ) && self.script_forcespawn ) )
		{
			wait ( laststand::player_num_in_laststand() / GetPlayers().size * 8 );
		}
	}

	// We are done with this spawner
	//bbprint("spawn_manager: manager %s event complete", self.targetname);
	
	// Update the state flags
	self spawn_manager_flag_complete(); // This spawn manager is complete as its count reached to zero
	
	if ( IsDefined( self.activeAI ) && self.activeAI.size != 0 )
	{
		array::wait_till( self.activeAI, "death" );
	}

	self Delete();
}


// Enable and disable spawn manager.
function spawn_manager_enable_think()
{
	while ( isdefined( self ) )
	{
		self waittill( "enable" );
		//bbprint("spawn_manager: targetname %s event enable", self.targetname);
		self.enable = true;
		// Update the state flags
		self spawn_manager_flag_enabled();
		self waittill( "disable" );
		//bbprint("spawn_manager: targetname %s event disable", self.targetname);
		// Update the state flags
		self spawn_manager_flag_disabled();
	}
	
	self spawn_manager_flag_disabled();
}


// Waits until the trigger for enabling the script manager is triggered and notfies.
function spawn_manager_enable_trigger_think( spawn_manager )
{
	spawn_manager endon( "death" );
	spawn_manager endon( "enable" );
	
	self endon( "death" );
	
	self waittill( "trigger" );
	spawn_manager notify( "enable" );
}


function spawn_manager_kill_think()
{
	self waittill( "death" );
	
	sm_id = self.sm_id;
	a_spawners = self.allSpawners;
	a_active_ai = self.activeAI;
	
	level flag::clear( "sm_" + sm_id + "_enabled" );
	level flag::set( "sm_" + sm_id + "_killed" );
	
	level flag::set( "sm_" + sm_id + "_complete" );

	array::delete_all( a_spawners );

	if ( a_active_ai.size )
	{
		array::wait_till( a_active_ai, "death" );
	}
	
	level flag::set( "sm_" + sm_id + "_cleared" );

	level.spawn_managers = array::remove_undefined( level.spawn_managers );
}

// Parses all the trigger in the map and starts waiting for killing/enabling related spawn managers
function start_triggers( trigger_type )
{
	triggers = trigger::get_all( "trigger_multiple", "trigger_once", "trigger_use", "trigger_radius", "trigger_lookat", "trigger_damage", "trigger_box" );
	foreach ( trig in triggers )
	{
		if ( isdefined( trig.target ) )
		{
			targets = get_spawn_manager_array( trig.target );
			foreach ( target in targets )
			{
				trig thread spawn_manager_enable_trigger_think( target );
			}
		}
	}
}

// --------------------------------------------------------------------------------
// ---- Utility functions ----
// --------------------------------------------------------------------------------

// returns contents of level.spawn_managers or the whole array based on targetname passed in
function get_spawn_manager_array( targetname )
{
	if ( isdefined( targetname ) )
	{
		// function is asking for a specific spawn manager struct
		spawn_manager_array = [];

		for ( i = 0; i < level.spawn_managers.size; i++ )
		{
			if ( isdefined( level.spawn_managers[i] ) )
			{
				if ( level.spawn_managers[i].targetname === targetname || level.spawn_managers[i].name === targetname )
				{
					if ( !isdefined( spawn_manager_array ) ) spawn_manager_array = []; else if ( !IsArray( spawn_manager_array ) ) spawn_manager_array = array( spawn_manager_array ); spawn_manager_array[spawn_manager_array.size]=level.spawn_managers[i];;
				}
			}
		}

		return spawn_manager_array;
	}
	else
	{
		// just return all the spawn managers
		return level.spawn_managers;
	}
}

// Returns the array of spawners specific to this spawn manager.
function spawn_manager_get_spawners()
{
	// Remove dead spawners //
	ArrayRemoveValue( self.allSpawners, undefined );
	// Remove other stuff we don't want //
	exclude = [];

	for ( i = 0; i < self.allSpawners.size; i++ )
	{
		//CODER_MOD : Dan L
		//Stopping dogs from spawning in game modes that break with them right now...
		if ( ( isdefined( level._gamemode_norandomdogs ) ) && ( self.allSpawners[i].classname == "actor_enemy_dog_sp" ) )
		{
			if ( !isdefined( exclude ) ) exclude = []; else if ( !IsArray( exclude ) ) exclude = array( exclude ); exclude[exclude.size]=self.allSpawners[i];;
		}
	}

	self.allSpawners = array::exclude( self.allSpawners, exclude );
	spawner_count_with_max_active = 0;
	
	foreach ( sp in self.allSpawners )
	{
		if(!isdefined(sp.sm_count_1player))sp.sm_count_1player=sp.count;
		if(!isdefined(sp.sm_active_count_max_1player))sp.sm_active_count_max_1player=(isdefined(sp.sm_active_count_max)?sp.sm_active_count_max:level.spawn_manager_max_ai);
		if(!isdefined(sp.sm_active_count_min_1player))sp.sm_active_count_min_1player=(isdefined(sp.sm_active_count_min)?sp.sm_active_count_min:sp.sm_active_count_max_1player);

		sp.activeAI = [];
	}
	
	groupSpawners = ArrayCopy( self.allSpawners );
	spawner_count = self.sm_spawner_count;

	if ( spawner_count > self.allSpawners.size )
	{
		spawner_count = self.allSpawners.size;
	}

	// select random spawners //
	spawners = [];

	while ( spawners.size < spawner_count )
	{
		spawner = array::random( groupSpawners );
		if ( !isdefined( spawners ) ) spawners = []; else if ( !IsArray( spawners ) ) spawners = array( spawners ); spawners[spawners.size]=spawner;;
		ArrayRemoveValue( groupSpawners, spawner );
	}

	return spawners;
}

// Select the random group size
function spawn_manager_get_spawn_group_size()
{
	if ( self.sm_group_size_min < self.sm_group_size_max )
	{
		self.sm_group_size = RandomIntRange( self.sm_group_size_min, self.sm_group_size_max + 1 );
	}
	else
	{
		self.sm_group_size = self.sm_group_size_min;
	}

	return self.sm_group_size;
}


// Spawner management - Deletes any spawners if its count has reached to zero.
// Also updates the self.spawner on the spawn manager.
function cleanup_spawners()
{
	spawners = [];

	for ( i = 0; i < self.spawners.size; i++ )
	{
		if ( isdefined( self.spawners[i] ) )
		{
			if ( self.spawners[i].count != 0 )
			{
				spawners[spawners.size] = self.spawners[i];
			}
			else
			{
				self.spawners[i] Delete();
			}
		}
	}

	self.spawners = spawners;
}

function spawn_manager_wait()
{
	// if script_wait is specified, use it just how it is
	if ( isdefined( self.script_wait ) )
	{
		wait( self.script_wait );

		if ( isdefined( self.script_wait_add ) )
		{
			self.script_wait += self.script_wait_add;
		}
	}
	else if ( isdefined( self.script_wait_min ) && isdefined( self.script_wait_max ) )
	{
		coop_scalar = 1;
		players = GetPlayers();

		if ( players.size == 2 )
		{
			coop_scalar = 0.7;
		}
		else if ( players.size == 3 )
		{
			coop_scalar = 0.5;
		}
		else if ( players.size == 4 )
		{
			coop_scalar = 0.3;
		}

		// do coop scaling only if a min and max is specified, and stay in that range
		diff = self.script_wait_max - self.script_wait_min;
		if ( Abs( diff ) > 0 )
		{
			wait( RandomFloatrange( self.script_wait_min, self.script_wait_min + ( diff * coop_scalar ) ) );	
		}
		else
		{
			wait( self.script_wait_min );
		}
		

		if ( isdefined( self.script_wait_add ) )
		{
			self.script_wait_min += self.script_wait_add;
			self.script_wait_max += self.script_wait_add;
		}
	}
}

// --------------------------------------------------------------------------------
// ---- Spawn manager state flag management ----
// These flags can be accessed by the scripters to know the current state of the spawn manager
// --------------------------------------------------------------------------------

function spawn_manager_flags_setup()//self = spawn manager
{
	//sm_<targetname>_enabled
	//Set when the spawn manager is enabled.
	//default: false
	level flag::init( "sm_" + self.sm_id + "_enabled" );
	//sm_<targetname>_complete
	//Set when the spawn manager completes (spawns up to its sm_count value).
	//Default: false
	level flag::init( "sm_" + self.sm_id + "_complete" );
	//sm_<targetname>_killed
	//Set when the spawn manager is killed.
	//Default: false
	level flag::init( "sm_" + self.sm_id + "_killed" );
	//sm_<targetname>_killed
	//Set when the spawn manage is complete/killed and all the AI from this spawn manager are dead.
	//Default: false
	level flag::init( "sm_" + self.sm_id + "_cleared" );
}

function spawn_manager_flag_enabled()//self = spawn_manager
{
	assert( !level flag::get( "sm_" + self.sm_id + "_enabled" ), "Spawn manager flags should not be set by the level script." );
	level flag::set( "sm_" + self.sm_id + "_enabled" );
}

function spawn_manager_flag_disabled()//self = spawn_manager
{
	self.enable = false;
	level flag::clear( "sm_" + self.sm_id + "_enabled" );
}

function spawn_manager_flag_killed()//self = spawn_manager
{
	assert( !level flag::get( "sm_" + self.sm_id + "_killed" ), "Spawn manager flags should not be set by the level script." );
	level flag::set( "sm_" + self.sm_id + "_killed" );
}


// A spawn manager can be killed but not complete, but when its complete, it is always killed.
function spawn_manager_flag_complete()//self = spawn_manager
{
	assert( !level flag::get( "sm_" + self.sm_id + "_complete" ), "Spawn manager flags should not be set by the level script." );
	level flag::set( "sm_" + self.sm_id + "_complete" );
}

function spawn_manager_flag_cleared()//self = spawn_manager
{
	assert( !level flag::get( "sm_" + self.sm_id + "_cleared" ), "Spawn manager flags should not be set by the level script." );
	level flag::set( "sm_" + self.sm_id + "_cleared" );
}

// --------------------------------------------------------------------------------
// ---- Spawn Manager - Scripter interface ----
// --------------------------------------------------------------------------------

/@
"Name: set_global_active_count( count )"
"Module: Spawn Manager"
"Summary: Max number of AI active globally from all spawn managers in the level."
"MandatoryArg: count"
"Example: spawn_manager::set_global_active_count(16);"
"SPMP: singleplayer"
@/
function set_global_active_count( cnt )
{
	assert( cnt <= 32, "Max number of Active AI at a given time cant be more than 32" );
	level.spawn_manager_max_ai = cnt;
}

/@
"Name: use_trig_when_complete( spawn_manager_targetname, trigger value, trigger key, only_once )"
"Module: Spawn Manager"
"Summary: Use passed in trigger when Spawn Manager complete or killed"
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: trigger value"
"MandatoryArg: trigger key"
"OptionalArg: boolean - set this to true if you only want the trigger used once if it is in the player space"
"Example: level spawn_manager::use_trig_when_complete( "my_spawn_manager_01", "next_trig", "targetname", 1);"
"SPMP: singleplayer"
@/
function use_trig_when_complete( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	if ( isdefined( once_only ) && once_only )
	{
		trigger = GetEnt( trig_name, trig_key );
		assert( isdefined( trigger ), "The trigger " + trig_key + " / " + trig_name + " does not exist." );
		trigger endon( "trigger" );
	}

	// Check if the spawn manager is enabled based on the flags first and then try to disable it.
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		level flag::wait_till( "sm_" + spawn_manager_targetname + "_complete" );
		trigger::use( trig_name, trig_key );
	}
	else
	{
		AssertMsg( "use_trig_when_complete: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: use_trig_when_cleared( spawn_manager_targetname, trigger value, trigger key, once_only )"
"Module: Spawn Manager"
"Summary: Use passed in trigger when Spawn Manager is done spawning and ai cleared."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: trigger value"
"MandatoryArg: trigger key"
"OptionalArg: <once_only> - set this to true if you only want the trigger used once if it is in the player space"
"Example: level spawn_manager::use_trig_when_cleared( "my_spawn_manager_01", "next_trig", "targetname", 1);"
"SPMP: singleplayer"
@/

function use_trig_when_cleared( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	if ( isdefined( once_only ) && once_only )
	{
		trigger = GetEnt( trig_name, trig_key );
		assert( isdefined( trigger ), "The trigger " + trig_key + " / " + trig_name + " does not exist." );
		trigger endon( "trigger" );
	}

	// Check if the spawn manager is enabled based on the flags first and then try to disable it.
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		level flag::wait_till( "sm_" + spawn_manager_targetname + "_cleared" );
		trigger::use( trig_name, trig_key );
	}
	else
	{
		AssertMsg( "sm_use_trig_when_cleared: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: use_trig_when_enabled( spawn_manager_targetname, trigger value, trigger key, once_only )"
"Module: Spawn Manager"
"Summary: Use passed in trigger when Spawn Manager enabled."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: trigger value"
"MandatoryArg: trigger key"
"OptionalArg: <once_only> - set this to true if you only want the trigger used once if it is in the player space"
"Example: level spawn_manager::use_trig_when_enabled( "my_spawn_manager_01", "next_trig", "targetname", 1);"
"SPMP: singleplayer"
@/
function use_trig_when_enabled( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	if ( isdefined( once_only ) && once_only )
	{
		trigger = GetEnt( trig_name, trig_key );
		assert( isdefined( trigger ), "The trigger " + trig_key + " / " + trig_name + " does not exist." );
		trigger endon( "trigger" );
	}

	// Check if the spawn manager is enabled based on the flags first and then wait for it to be enabled
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		level flag::wait_till( "sm_" + spawn_manager_targetname + "_enabled" );
		trigger::use( trig_name, trig_key );
	}
	else
	{
		AssertMsg( "sm_use_trig_when_cleared: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: run_func_when_complete( spawn_manager_targetname, process, ent, var1, var2, var3, var4 )"
"Module: Spawn Manager"
"Summary: Runs function when Spawn Manager is done spawning."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: <process> : function pointer"
"OptionalArg: <ent> : entity to thread function on"
"OptionalArg: <var1> : first parameter"
"OptionalArg: <var2> : second parameter"
"OptionalArg: <var3> : third parameter"
"OptionalArg: <var4> : fourth parameter"
"Example: level spawn_manager::run_func_when_complete(::my_function, bob, steve);"
"SPMP: singleplayer"
@/
function run_func_when_complete( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	assert( isdefined( process ), "run_func_when_complete: the function is not defined" );
	assert( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ), "run_func_when_complete: Spawn manager '" + spawn_manager_targetname + "' not found." );
	wait_till_complete( spawn_manager_targetname );
	util::single_func( ent, process, var1, var2, var3, var4, var5 );
}


/@
"Name: run_func_when_cleared( spawn_manager_targetname, process, ent, var1, var2, var3, var4 )"
"Module: Spawn Manager"
"Summary: Runs function when Spawn Manager done spawning and ai cleared."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: <process> : function pointer"
"OptionalArg: <ent> : entity to thread function on"
"OptionalArg: <var1> : first parameter"
"OptionalArg: <var2> : second parameter"
"OptionalArg: <var3> : third parameter"
"OptionalArg: <var4> : fourth parameter"
"Example: level spawn_manager::run_func_when_cleared(::my_function, bob, steve);"
"SPMP: singleplayer"
@/
function run_func_when_cleared( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	assert( isdefined( process ), "run_func_when_cleared: the function is not defined" );
	assert( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ), "run_func_when_cleared: Spawn manager '" + spawn_manager_targetname + "' not found." );
	wait_till_cleared( spawn_manager_targetname );
	util::single_func( ent, process, var1, var2, var3, var4, var5 );
}
/@
"Name: run_func_when_enabled( spawn_manager_targetname, process, ent, var1, var2, var3, var4 )"
"Module: Spawn Manager"
"Summary: Runs function when Spawn Manager is enabled."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: <process> : function pointer"
"OptionalArg: <ent> : entity to thread function on"
"OptionalArg: <var1> : first parameter"
"OptionalArg: <var2> : second parameter"
"OptionalArg: <var3> : third parameter"
"OptionalArg: <var4> : fourth parameter"
"Example: my_spawnmanager spawn_manager::run_func_when_enabled(::my_function, bob, steve);"
"SPMP: singleplayer"
@/
function run_func_when_enabled( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	assert( isdefined( process ), "run_func_when_enabled: the function is not defined" );
	assert( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ), "run_func_when_enabled: Spawn manager '" + spawn_manager_targetname + "' not found." );
	wait_till_enabled( spawn_manager_targetname );
	util::single_func( ent, process, var1, var2, var3, var4, var5 );
}

/@
"Name: enable( <spawn_manager_targetname>, [no_assert] )"
"Module: Spawn Manager"
"Summary: Enable/Activate spawn manager with given targetname."
"MandatoryArg: <spawn_manager_targetname>"
"OptionalArg: [no_assert] : disable assert if spawn manager doesn't exist."
"Example: spawn_manager::enable("spawn_manager_04");"
"SPMP: singleplayer"
@/
function enable( spawn_manager_targetname, no_assert )
{
	// Check if the spawn manager is found based on the flags first and then try to enable it.
	// A spawn manager is disabled by default before enabled/activating it for the first time.
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		foreach ( sm in level.spawn_managers )
		{
			if ( isdefined( sm ) && ( sm.sm_id == spawn_manager_targetname ) )
			{
				sm notify( "enable" );
				return;
			}
		}
	}
	else if ( !( isdefined( no_assert ) && no_assert ) )
	{
		AssertMsg( "enable: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: disable( <spawn_manager_targetname>, [no_assert] )"
"Module: Spawn Manager"
"Summary: Disable/Deactivate spawn manager with given targetname."
"MandatoryArg: <spawn_manager_targetname>"
"OptionalArg: [no_assert] : disable assert if spawn manager doesn't exist."
"Example: spawn_manager::disable("spawn_manager_04");"
"SPMP: singleplayer"
@/
function disable( spawn_manager_targetname, no_assert )
{
	// Check if the spawn manager is enabled based on the flags first and then try to disable it.
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		foreach ( sm in level.spawn_managers )
		{
			if ( isdefined( sm ) && ( sm.sm_id == spawn_manager_targetname ) )
			{
				sm notify( "disable" );
				return;
			}
		}
	}
	else if ( !( isdefined( no_assert ) && no_assert ) )
	{
		AssertMsg( "disable: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}


/@
"Name: kill( <spawn_manager_targetname>, [no_assert] )"
"Module: Spawn Manager"
"Summary: Kill spawn manager with given targetname."
"MandatoryArg: <spawn_manager_targetname>"
"OptionalArg: [no_assert] : disable assert if spawn manager doesn't exist."
"Example: spawn_manager::kill("spawn_manager_04");"
"SPMP: singleplayer"
@/
function kill( spawn_manager_targetname, no_assert )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		foreach ( sm in level.spawn_managers )
		{
			if ( isdefined( sm ) && ( sm.sm_id == spawn_manager_targetname ) )
			{
				sm Delete();
				level.spawn_managers = array::remove_undefined( level.spawn_managers );
				return;
			}
		}
	}
	else if ( !( isdefined( no_assert ) && no_assert ) )
	{
		AssertMsg( "kill: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: is_enabled( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns true if the spawn manager is enabled/active."
"MandatoryArg: <spawn_manager_targetname>"
"Example: spawn_manager::is_enabled("spawn_manager_04");"
"SPMP: singleplayer"
@/
function is_enabled( spawn_manager_targetname )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		if ( level flag::get( "sm_" + spawn_manager_targetname + "_enabled" ) )
		{
			return true;
		}

		return false;
	}
	else
	{
		AssertMsg( "is_enabled: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: is_complete( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns true if the spawn manager has finished spawning all the AI."
"MandatoryArg: <spawn_manager_targetname>"
"Example: spawn_manager::is_complete("spawn_manager_04");"
"SPMP: singleplayer"
@/
function is_complete( spawn_manager_targetname )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		if ( level flag::get( "sm_" + spawn_manager_targetname + "_complete" ) )
		{
			return true;
		}

		return false;
	}
	else
	{
		AssertMsg( "is_complete: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: is_cleared( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns true if the spawn manager has finished spawning all the AI and all AI from this spawn manager are dead."
"MandatoryArg: <spawn_manager_targetname>"
"Example: spawn_manager::is_cleared("spawn_manager_04");"
"SPMP: singleplayer"
@/
function is_cleared( spawn_manager_targetname )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		if ( level flag::get( "sm_" + spawn_manager_targetname + "_cleared" ) )
		{
			return true;
		}

		return false;
	}
	else
	{
		AssertMsg( "is_cleared: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: is_killed( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns true if the spawn manager has has been killed."
"MandatoryArg: <spawn_manager_targetname>"
"Example: spawn_manager::is_killed("spawn_manager_04");"
"SPMP: singleplayer"
@/
function is_killed( spawn_manager_targetname )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		if ( level flag::get( "sm_" + spawn_manager_targetname + "_killed" ) )
		{
			return true;
		}

		return false;
	}
	else
	{
		AssertMsg( "is_killed: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: wait_till_cleared( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager has finished spawning all the AI and all AI from this spawn manager are dead."
"MandatoryArg: <spawn_manager_targetname>"
"Example: spawn_manager::wait_till_cleared("spawn_manager_04");"
"SPMP: singleplayer"
@/
function wait_till_cleared( spawn_manager_targetname )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		level flag::wait_till( "sm_" + spawn_manager_targetname + "_cleared" );
	}
	else
	{
		AssertMsg( "wait_till_cleared: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: wait_till_ai_remaining( spawn_manager_targetname, count )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager has finished spawning all the AI and the amount of remaining AI is less than the specified count."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: <count> function returns when number of remaining ai count = count"
"Example: spawn_manager::wait_till_ai_remaining("spawn_manager_04", 5);"
"SPMP: singleplayer"
@/
function wait_till_ai_remaining( spawn_manager_targetname, count_to_reach )
{
	assert( isdefined( count_to_reach ), "# of AI remaining not specified in _utility::wait_till_ai_remaining()" );
	assert( count_to_reach, "# of AI remaining specified in _utility::wait_till_ai_remaining() is 0, use wait_till_cleared" );

	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		level flag::wait_till( "sm_" + spawn_manager_targetname + "_complete" );
	}
	else
	{
		AssertMsg( "wait_till_ai_remaining: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}

	if ( level flag::get( "sm_" + spawn_manager_targetname + "_cleared" ) )
	{
		return;
	}

	// spawn manager might be deleted so using a kvp the spawn manager setsz on the ai it spawns
	while ( get_ai( spawn_manager_targetname ).size > count_to_reach )
	{
		wait( 0.1 );
	}
}

/@
"Name: wait_till_complete( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager has finished spawning all the AI."
"MandatoryArg: <spawn_manager_targetname>"
"Example: spawn_manager::wait_till_complete("spawn_manager_04");"
"SPMP: singleplayer"
@/
function wait_till_complete( spawn_manager_targetname )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		level flag::wait_till( "sm_" + spawn_manager_targetname + "_complete" );
	}
	else
	{
		AssertMsg( "wait_till_complete: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: wait_till_enabled( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager is enabled/active."
"MandatoryArg: <spawn_manager_targetname>"
"Example: spawn_manager::wait_till_enabled("spawn_manager_04");"
"SPMP: singleplayer"
@/
function wait_till_enabled( spawn_manager_targetname )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		level flag::wait_till( "sm_" + spawn_manager_targetname + "_enabled" );
	}
	else
	{
		AssertMsg( "wait_till_enabled: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}
}

/@
"Name: wait_till_spawned_count( spawn_manager_targetname, count )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager has spawned the specified amount of AI."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: count"
"Example: spawn_manager::wait_till_spawned_count( "my_sm_targetname", 20 )"
"SPMP: singleplayer"
@/

function wait_till_spawned_count( spawn_manager_targetname, count )
{
	if ( level flag::exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		level flag::wait_till( "sm_" + spawn_manager_targetname + "_enabled" );
	}
	else
	{
		AssertMsg( "wait_till_spawned_count: Spawn manager '" + spawn_manager_targetname + "' not found." );
	}

	spawn_manager = spawn_manager::get_spawn_manager_array( spawn_manager_targetname );
	assert( spawn_manager.size, "Somehow the spawn manager doesnt exist, but related flag existed before." );
	assert( ( spawn_manager.size == 1 ), "Found two spawn managers with same targetname." );
	
// spawnCount holds the number of AI's are spawned
	while ( 1 )
	{
		if ( isdefined( spawn_manager[0].spawnCount ) && ( spawn_manager[0].spawnCount < count ) && !is_killed( spawn_manager_targetname ) )
		{
			wait( 0.5 );
		}
		else
		{
			break;
		}
	}

	return;
}

/@
"Name: get_ai( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns the alive AI currently spawned from this spawn manager."
"MandatoryArg: <spawn_manager_targetname>"
"Example: a_guys = spawn_manager::get_ai( "my_sm_targetname" )"
"SPMP: singleplayer"
@/

function get_ai( spawn_manager_targetname )
{
	a_ai = GetAIArray( spawn_manager_targetname, "sm_id" );
	return a_ai;
}

// --------------------------------------------------------------------------------
// ---- Spawn Manager - Scripter interface End ----
// --------------------------------------------------------------------------------
