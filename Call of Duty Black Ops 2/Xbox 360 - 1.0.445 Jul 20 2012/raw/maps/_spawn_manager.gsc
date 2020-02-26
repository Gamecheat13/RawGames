/*
 * Spawn Manager
 *
 * Initial implementation: Stephen McCaul and June Park 3/09
 *
 * Additional work: Sumeet Jakatdar and Brian Barnes
 *
**/

#include maps\_utility;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;


// --------------------------------------------------------------------------------
// ---- Init function for spawn manager, called from _load.gsc ----
// --------------------------------------------------------------------------------

spawn_manager_main()
{
	level.spawn_manager_max_frame_spawn = 3;

	level.spawn_manager_total_count = 0;
	level.spawn_manager_max_ai = 24;
	level.spawn_manager_active_ai = 0;

	level.spawn_manager_auto_targetname_num = 0;

	level thread spawn_manager_throttle_think();

	// store all the spawn managers on level
	level.spawn_managers = [];

	// Trigger based spawn manager, spawn manager entity based on trigger entity.
	trigger_spawn_manager_setup();

	// spawn manager entity based spawn manager entity, this function deletes the entity
	array_func( GetEntArray("spawn_manager", "classname"), ::spawn_manager_create_spawn_manager_struct );
	
	// Initiate the thinking for all the spawn managers in the level.
	array_thread(level.spawn_managers, ::spawn_manager_think);

	start_triggers();


/#
	//  Debug functions
	level thread spawn_manager_debug();
	level thread spawn_manager_debug_spawn_manager();
	level thread spawn_manager_debug_spawner_values();
#/
}

// --------------------------------------------------------------------------------
// ---- Trigger based spawn manager ----
// --------------------------------------------------------------------------------

// Set up triggers to act as spawn managers.
trigger_spawn_manager_setup()
{
	triggers = get_triggers ("trigger_multiple", "trigger_once", "trigger_radius", "trigger_lookat", "trigger_box" );
	
	for( j=0; j<triggers.size; j++ )
	{
		trigger = triggers[j];
			// Trigger can be used as spawn manager if they have "SPAWN_MANAGER" flag set.
		if( trigger has_spawnflag( SPAWNFLAG_TRIGGER_SPAWN_MANAGER ) )
		{
			// Creates a spawn manager based on the trigger and sets up other things.
			trigger_spawn_manager_create( trigger );
		}
	}
}

// Trigger spawn manager management.
trigger_spawn_manager_create( trigger )
{
	ents = undefined;

	// This spawn manager type trigger is not targeting any spawners
	assert( IsDefined(trigger.target), "Trigger at " + trigger.origin + " is a spawn manager type ( TRIGGER_SPAWN_MANAGER ) but does not target any spawners" );

	ents = GetEntArray( trigger.target, "targetname" );

	for( i=0; i<ents.size; i++ )
	{
		ent = ents[i];

		// Trigger cant be a spawn manager and target a spawn manager at the same time.
		// This means that the trigger has TRIGGER_SPAWN_MANAGER spawnflag and its also pointing to a spawn manager.
		assert( ent.classname != "spawn_manager", "Trigger at " + trigger.origin + " is a spawn manager type ( TRIGGER_SPAWN_MANAGER ) and also targetting a spawn manager " + ent.targetname );

		// Also the trigger should only target AI spawners and nothing else.
		assert( IsSubStr( ent.classname, "actor") , "Trigger at " + trigger.origin + " is a spawn manager type ( TRIGGER_SPAWN_MANAGER ) but targets a non-actor entity" );
	}

	spawn_manager_create_spawn_manager_struct( trigger );
}


// ----------------------------------------------------------------------------------------------------
// ---- Spawn manager struct - Creates a spawn manager struct from an spawn manager entity/trigger ----
// ----------------------------------------------------------------------------------------------------
spawn_manager_create_spawn_manager_struct( from_ent )
{
	if( !IsDefined(from_ent) )
	{
		from_ent = self;
	}

	// Spawn a spawn_manager entity corrosponding to from_ent, return ent should have the classname on it set properly.
	spawn_manager_ent = SpawnStruct();
	spawn_manager_ent.script_noteworthy = "spawn_manager";
	
	is_trigger = IsSubStr( tolower( from_ent.classname ), "trigger" );

	if ( !IsDefined( from_ent.targetname ) )
	{
		from_ent.targetname = generate_targetname();
	}
	
	if ( is_trigger || !IsDefined( from_ent.name ) )
	{
		spawn_manager_ent.sm_id = from_ent.targetname;
	}
	else
	{
		spawn_manager_ent.sm_id = from_ent.name;
	}
	
	/#
		foreach ( sm in level.spawn_managers )
		{
			if ( sm.sm_id == spawn_manager_ent.sm_id )
			{
				AssertMsg( "Multiple spawn managers wi id '" + spawn_manager_ent.sm_id + "'! If they need to have the same targetname, use the 'name' KVP to make them unique." );
			}
		}
	#/

	// if from entity is trigger then we used to create a different targetname, but as the new
	// spawn manager is not an entity and a struct we dont need to do that anymore.
	spawn_manager_ent.targetname = from_ent.targetname;
	
	// Target the spawn manager ent to the from_ent targets.
	spawn_manager_ent.target = from_ent.target;
	
	// Now that the target information is transfered to the spawn manager,
	// trigger should point to the spawn manager instead of the spawners.
	if( is_trigger )
	{
		from_ent.target = spawn_manager_ent.targetname;
	}
	
	// Copy over the related information to the spawn manager from the from_ent

	// maximum delay between spawns ( ai spawns between .01 and script_wait, inclusive )
	if( IsDefined(from_ent.script_wait) )
	{
		spawn_manager_ent.script_wait = from_ent.script_wait;
	}

	if( IsDefined(from_ent.script_wait_min) )
	{
		spawn_manager_ent.script_wait_min = from_ent.script_wait_min;
	}

	if( IsDefined(from_ent.script_wait_max) )
	{
		spawn_manager_ent.script_wait_max = from_ent.script_wait_max;
	}

	// Delay before the first AI spawns from after the spawn manager is triggerd/enabled.
	if( IsDefined(from_ent.script_delay) )
	{
		spawn_manager_ent.script_delay = from_ent.script_delay;
	}

	if( IsDefined(from_ent.script_delay_min) )
	{
		spawn_manager_ent.script_delay_min = from_ent.script_delay_min;
	}

	if( IsDefined(from_ent.script_delay_max) )
	{
		spawn_manager_ent.script_delay_max = from_ent.script_delay_max;
	}

	// total number of ai to spawn
	if( IsDefined(from_ent.sm_count) )
	{
		spawn_manager_ent.sm_count = from_ent.sm_count;
	}

	// total number of ai to spawn, if not mentioned sm_count then this will be used.
	if( IsDefined(from_ent.count) )
	{
		spawn_manager_ent.count = from_ent.count;
	}

	// maximum active ai - for spawn_manager and spawner
	if( IsDefined(from_ent.sm_active_count) )
	{
		spawn_manager_ent.sm_active_count = from_ent.sm_active_count;
	}

	// number of ai ranging from one to this value that the spawn manager will attempt to spawn from a spawner
	if( IsDefined(from_ent.sm_group_size) )
	{
		spawn_manager_ent.sm_group_size = from_ent.sm_group_size;
	}

	// number of spawners that the spawn manager will select to spawn ai from
	if( IsDefined(from_ent.sm_spawner_count) )
	{
		spawn_manager_ent.sm_spawner_count = from_ent.sm_spawner_count;
	}

	// Special kill spawner K/v pair is needed from now, this way its less confusing with triggers
	if( IsDefined(from_ent.sm_die) )
	{
		spawn_manager_ent.sm_die = from_ent.sm_die;
	}

	// next spawn manager after this spawn manager is killed
	if( IsDefined( from_ent.script_next_spawn_manager ) )
	{
		spawn_manager_ent.script_next_spawn_manager = from_ent.script_next_spawn_manager;
	}

	// Delete the from entity if it is a spawn manager, we dont delete triggers
	if( !is_trigger )
	{
		from_ent Delete();
	}

	ARRAY_ADD( level.spawn_managers, spawn_manager_ent );
}

generate_targetname()
{
	targetname = "sm_auto_" + level.spawn_manager_auto_targetname_num;
	level.spawn_manager_auto_targetname_num++;
	return targetname;
}

// --------------------------------------------------------------------------------
// ---- spawn manager setup - sets up the spawn manager first time it is enabled. ----
// --------------------------------------------------------------------------------

spawn_manager_setup()
{
	Assert(IsDefined(self));
	Assert(IsDefined(self.target));

	//-----------------------------------------------------------------------------------------------
	// sm_group_size - The number of AI that can spawn from a spawner at once. Default = 1.
	// Supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	if( !IsDefined( self.sm_group_size ) )
	{
		self.sm_group_size = 1;
	}

	// sm_group_size is defined, parse for min and max values
	self.sm_group_size_min = get_min_value( self.sm_group_size );
	self.sm_group_size_max = get_max_value( self.sm_group_size );

	assert( self.sm_group_size_max >= self.sm_group_size_min, "Max range should be greater or equal to the min value for sm_count on spawn manager " + self.sm_id );

	//-----------------------------------------------------------------------------------------------
	// sm_spawner_count - The number of spawners that spawn manager will randomly select from the full
	// set of the available spawners, defaults to number of spawners in the spawn manager.
	// Supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	if( !IsDefined( self.sm_spawner_count ) )
	{
		self.sm_spawner_count = self.allSpawners.size;
	}

	self.sm_spawner_count_min = get_min_value( self.sm_spawner_count );
	self.sm_spawner_count_max = get_max_value( self.sm_spawner_count );

	assert( self.sm_spawner_count_max >= self.sm_spawner_count_min, "Max range should be greater or equal to the min value for sm_count on spawn manager " + self.sm_id );
	self.sm_spawner_count = spawn_manager_random_count( self.sm_spawner_count_min, self.sm_spawner_count_max + 1 );
	
	//-----------------------------------------------------------------------------------------------
	// sm_count - Total number of AI that can be spawned from this spawn manager. Default = infinity.
	// Supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	self calculate_count();
	
	// Grab all the spawners and store it on spawn manager entity.
	self.spawners = self spawn_manager_get_spawners();

	//-----------------------------------------------------------------------------------------------
	// sm_active_count - Total number of AI that can be active from this spawn manager,
	// supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------
	
	if( IsDefined( self.sm_active_count ) )
	{
		self.sm_active_count_min = get_min_value( self.sm_active_count );
		self.sm_active_count_max = get_max_value( self.sm_active_count );
	}
	else
	{
		/* There's no active count on the spawn manager, use the values from the spawners */
		
		self.sm_active_count_min = 0;
		self.sm_active_count_max = 0;
		
		foreach ( spawner in self.spawners )
		{
			self.sm_active_count_min += spawner.sm_active_count_min;
			self.sm_active_count_max += spawner.sm_active_count_max;
		}
	}
		
	// Make sure the min active count is big enough to hold the max group size that will spawn
	// As long as it's still smaller than the specified max active count
	if (self.sm_active_count_min < self.sm_group_size_max)
	{
		assert( self.sm_active_count_max >= self.sm_group_size_max, "Max active count should be greater or equal to the max value for sm_group_size on spawn manager trigger with targetname " + self.targetname );
		self.sm_active_count_min = self.sm_group_size_max;
	}
	
	assert( self.sm_active_count_max >= self.sm_active_count_min, "Max range should be greater or equal to the min value for sm_active_count on spawn manager trigger with targetname " + self.targetname );

	// select the random between min and max.
	self.sm_active_count = spawn_manager_random_count(self.sm_active_count_min, self.sm_active_count_max+1);
	
	//-----------------------------------------------------------------------------------------------
	// script_forcespawn - Specific to spawn manager. AI spwaned from this spawn manager will use stalingrad spawn.
	//-----------------------------------------------------------------------------------------------

	if(!IsDefined(self.script_forcespawn))
	{
		self.script_forcespawn = 0;
	}

	// Sanity Checks if needed
	Assert(self.count >= self.count_min);
	Assert(self.count <= self.count_max);

	Assert(self.sm_active_count >= self.sm_active_count_min);
	Assert(self.sm_active_count <= self.sm_active_count_max);

	// sm_group_size min and max should be less than sm_active_cpunt
	Assert(self.sm_group_size_max <= self.sm_active_count);
	Assert(self.sm_group_size_min <= self.sm_active_count);
}

// --------------------------------------------------------------------------------
// ---- Spawn manager spawn functions, spawns the individual AI or in group ----
// --------------------------------------------------------------------------------

// Returns true if AI can be spawned from this spawn manager currently.
spawn_manager_can_spawn(spawnGroupSize)
{
	// Get number of AI remaining to spawn from this spawn manager.
	totalFree = self.count - self.spawnCount;

	// Get the number of AI's active AI's remaining to spawn from this spawn manager.
	activeFree = self.sm_active_count - self.activeAI.size;
	
	// Spawn manager can spawn a group if activeFree and totalFree count is greater than the sm_group_size.
	canSpawnGroup =  (activeFree >= spawnGroupSize)
				  && (totalFree >=  spawnGroupSize)
				  && (spawnGroupSize > 0);

	// Total number of AI allowed to spawn against the max AI from any spawn manager.
	globalFree = level.spawn_manager_max_ai - level.spawn_manager_active_ai;

	// Just to make sure that the state flags are not tampered by the level script
	assert( self.enable == flag("sm_" + self.sm_id + "_enabled"), "Spawn manager flags should not be set by the level script." );
	
	// If there is a forcespawn on the spawn manager, then dont check against the groupspawn and global count.
	if(self.script_forcespawn == 0)
	{
		return (totalFree > 0)  // within total count
			&& (activeFree > 0) // within active count
			&& (globalFree > 0) // within global count
			&& canSpawnGroup    // within group size
			&& self.enable	    // spawner enabled
			;
	}
	else
	{
		return (totalFree > 0)  // within total count
			&& (activeFree > 0) // within active count
			&& self.enable      // spawner enabled
			;
	}
}


spawn_manager_spawn(maxDelay)
{
	self endon ("death");
	start = GetTime();

	for(;;)
	{
		while(level.spawn_manager_frame_spawns >= level.spawn_manager_max_frame_spawn
			|| GetAICount() >= level.spawn_manager_max_ai)
		{
			level waittill("spawn_manager_throttle_reset");
		}
		
		ai = self spawn_ai();

		if(!spawn_failed(ai)) //if we spawned give it back
		{
			ai maps\_names::get_name();
			return ai;
		}
		else if((gettime() - start) > (1000*maxDelay)) //give up if it has been too long
		{
			return ai;
		}

		wait(0.05);
	}
}


spawn_manager_spawn_group(/*manager, */spawner, spawnGroupSize)
{
	spawn_count = 0;

	for( i = 0; i < spawnGroupSize; i++)
	{
		ai = undefined;

		if (IsDefined(spawner) && IsDefined(spawner.targetname) ) // TFLAME 7/9/09 make sure this spawner wasn't deleted by script_killspawner
		{
			ai = spawner spawn_manager_spawn(2.0);
		}
		else
		{
			continue;
		}

		if (!spawn_failed(ai))
		{
			spawn_count++;

			level.spawn_manager_frame_spawns += 1;
			
			if (IsDefined(self.script_radius))
			{
				ai.script_radius = self.script_radius;
			}

			if (IsDefined(spawner.script_radius))
			{
				ai.script_radius = spawner.script_radius;
			}
			
			ai thread spawn_accounting(spawner, self);
		}

		// If we have already spawned all the guys, no need to wait anymore.
		if( spawn_count == spawnGroupSize )
			wait(.05);
	}
}

spawn_accounting(spawner, manager)
{
	targetname = manager.targetname;
	classname = spawner.classname;
	level.spawn_manager_total_count += 1;
	manager.spawnCount += 1;
	level.spawn_manager_active_ai += 1;
	origin = spawner.origin;

	manager.activeAI[manager.activeAI.size] = self;
	spawner.activeAI[spawner.activeAI.size] = self;

	self waittill("death");
	
	if(IsDefined(spawner))
	{
		ArrayRemoveValue(spawner.activeAI, self);
	}
	if(IsDefined(manager))
	{
		ArrayRemoveValue(manager.activeAI, self);
	}

	level.spawn_manager_active_ai -= 1;

	//bbprint("spawn_manager_spawns: manager %s event death classname %s posx %f posy %f posz %f", targetname, classname, origin[0], origin[1], origin[2]);
}

// --------------------------------------------------------------------------------
// ---- Spawn manager think functions ----
// --------------------------------------------------------------------------------

spawn_manager_think()
{
	self spawn_manager_flags_setup(); // Initialize the spawn manager state flags
	self thread spawn_manager_enable_think();
	self thread spawn_manager_kill_think();

	self endon("kill");

	self.enable = false;
	self.activeAI = [];		// stores number of currently active AI from the spawn manager.
	self.spawnCount = 0;
	isFirstTime = true;
	
	// Store all the spawners for reference
	self.allSpawners = GetEntArray(self.target, "targetname");
	assert(self.allSpawners.size, "Spawn manager '" + self.sm_id + "' doesn't target any spawners.");

	self waittill("enable");
	
	// Wait for random time between min and max of script_delay.
	script_delay();
	
	self spawn_manager_setup();

	while( self.spawnCount < self.count && self.spawners.size > 0 )
	{
		// Calculate self.sm_group_size
		self spawn_manager_get_spawn_group_size();

		// If the spawnGroupSize we are waiting on is going above the spawn manager count then modify it.
		if( self.sm_group_size + self.spawnCount > self.count )
		{
			self.sm_group_size = self.count - self.spawnCount;
		}

		// Did this spawn manager spawn and done with it?
		spawned = false;
		
		while( !spawned )
		{
			cleanup_spawners();

			// if there are no spawners left, break out of it
			if( self.spawners.size <= 0 )
			{
				break;
			}


			if(self spawn_manager_can_spawn(self.sm_group_size))
			{
				Assert( self.sm_group_size > 0 );
				
				// create a list of potential spawners based on the selected group size
				potential_spawners = [];
				priority_spawners = [];

				for( i = 0; i< self.spawners.size; i++ )
				{
					current_spawner = self.spawners[i];
					
					if( IsDefined(current_spawner) )
					{
						spawnerFree = current_spawner.sm_active_count - current_spawner.activeAI.size;
										
						if( spawnerFree >= self.sm_group_size )
						{
							if ( current_spawner has_spawnflag( SPAWNFLAG_ACTOR_SM_PRIORITY ) )
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

				

				if( potential_spawners.size > 0 || priority_spawners.size > 0)
				{
					if (priority_spawners.size > 0)
					{
						spawner = random( priority_spawners );
					}
					else
					{
						spawner = random( potential_spawners );
					}

					// If count for this spawner is smaller than the sm_group_size then
					// sm_group_size has to be modified to be spawner count.

					Assert( IsDefined( spawner.count ) );

					if( spawner.count < self.sm_group_size )
					{
						self.sm_group_size = spawner.count;
					}

					// Wait for random time between min and max of script_wait.
					// Do not do this on the first iteration
					if( !isFirstTime )
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
					if( !self.enable )
					{
						continue;
					}
			
					self spawn_manager_spawn_group(/*self, */spawner, self.sm_group_size);
					spawned = true;
				}
				else
				{
					// not a single spawner found for the given sm_group_size
					// find the largest one and use that as sm_group_size_max
					spawner_max_active_count = 0;

					for( i = 0; i< self.spawners.size; i++ )
					{
						current_spawner = self.spawners[i];
						
						if( IsDefined(current_spawner) )
						{
							if( current_spawner.sm_active_count > spawner_max_active_count )
							{
								spawner_max_active_count = current_spawner.sm_active_count;
							}
						}
					}

					if( spawner_max_active_count < self.sm_group_size_max )
					{
						self.sm_group_size_max = spawner_max_active_count;
						self spawn_manager_get_spawn_group_size();	// recalculate group size
					}
				}
			}
	
			wait(0.05);
		}

		// If all AI's are spawned then this spawn manager is complete, need to kill it as well.
		assert( self.spawnCount <= self.count, "Spawn manager spawned more then the allowed AI's" );

		wait(0.05);
		
		// Asserts to ensure that level script is not fiddling with spawn manager flags
		assert( !flag( "sm_" + self.sm_id + "_killed" ), "Spawn manager flags should not be set by the level script." );
		assert( !flag( "sm_" + self.sm_id + "_complete" ), "Spawn manager flags should not be set by the level script." );

		if(self.script_forcespawn == 0)
		{
			wait(maps\_laststand::player_num_in_laststand()/get_players().size * 8);
		}
	}

	// We are done with this spawner
	//bbprint("spawn_manager: manager %s event complete", self.targetname);
			
	// Update the state flags
	self spawn_manager_flag_complete(); // This spawn manager is complete as its count reached to zero
	self notify("kill");
}


// Enable and disable spawn manager.
spawn_manager_enable_think()
{
	self endon("kill");

	for(;;)
	{
		self waittill("enable");
		//bbprint("spawn_manager: targetname %s event enable", self.targetname);
		self.enable = true;
		// Update the state flags
		self spawn_manager_flag_enabled();
 

		self waittill("disable");
		//bbprint("spawn_manager: targetname %s event disable", self.targetname);
		// Update the state flags
		self spawn_manager_flag_disabled();
	}
}


// Waits until the trigger for enabling the script manager is triggered and notfies.
spawn_manager_enable_trigger_think(spawn_manager)
{
	spawn_manager endon("enable");
	self waittill("trigger");
	spawn_manager notify("enable");
}


spawn_manager_kill_think()
{
	self waittill("kill");

	// start next spawn manager if there is one
	if( IsDefined( self.script_next_spawn_manager ) )
	{
		spawn_manager_enable( self.script_next_spawn_manager );
	}

	// Update the state flags, disable it first and then delete it.
	self spawn_manager_flag_disabled();
	self spawn_manager_flag_killed();

	// Delete all the spawners in this spawn manager
	for (i = 0; i < self.allSpawners.size; i++)
	{
		if (IsDefined(self.allSpawners[i]))
		{
			self.allSpawners[i] Delete();
		}
	}

	// waittill all the active AI are dead from this spawn manager and then delete it.
	array_wait( self.activeAI, "death" );
	self spawn_manager_flag_cleared();

	// Remove from global spawn manager array
	ArrayRemoveValue(level.spawn_managers, self);

}



// self = trigger - Waits until the killspawner trigger is triggered to kill the spawn manager.
spawn_manager_kill_trigger_think()
{
	assert( IsDefined(self.sm_kill) );
	sm_kill_ids = StrTok(self.sm_kill, ";");
	
	if (sm_kill_ids.size > 0)
	{
		self waittill( "trigger" );

		for (id_i = 0; id_i < sm_kill_ids.size; id_i++)
		{
			killspawner_num = Int(sm_kill_ids[id_i]);
			for (sm_i = 0; sm_i < level.spawn_managers.size; sm_i++)
			{
				if (killspawner_num != 0)
				{
					// Kill spawn managers based on sm_die numbers on the spawn manager
					if(IsDefined(level.spawn_managers[sm_i].sm_die) && (level.spawn_managers[sm_i].sm_die == killspawner_num))
					{
						level.spawn_managers[sm_i] notify("kill");
					}
				}
				else if (level.spawn_managers[sm_i].sm_id == sm_kill_ids[id_i])
				{
					// Kill spawn managers based on targetname
					level.spawn_managers[sm_i] notify("kill");
				}
			}
		}
	}
}



// Parses all the trigger in the map and starts waiting for killing/enabling related spawn managers
start_triggers(trigger_type)
{
	triggers = get_triggers("trigger_multiple", "trigger_once", "trigger_use", "trigger_radius", "trigger_lookat", "trigger_damage", "trigger_box");
	
	foreach ( trig in triggers )
	{
		if ( IsDefined( trig.sm_kill ) )
		{
			trig thread spawn_manager_kill_trigger_think();
		}
		
		if ( IsDefined( trig.target ) )
		{
			targets = get_spawn_manager_array( trig.target );
			
			foreach ( target in targets )
			{
				trig thread spawn_manager_enable_trigger_think( target );
			}
		}
	}
}


spawn_manager_throttle_think()
{
	for(;;)
	{
		level.spawn_manager_frame_spawns = 0;
		level notify("spawn_manager_throttle_reset");
		wait_network_frame();
	}
}

// --------------------------------------------------------------------------------
// ---- Randomness related functions ----
// --------------------------------------------------------------------------------

spawn_manager_random_count(min, max)
{
	return RandomIntRange(min, max);
}

// --------------------------------------------------------------------------------
// ---- Utility functions ----
// --------------------------------------------------------------------------------

// returns contents of level.spawn_managers or the whole array based on targetname passed in
get_spawn_manager_array( targetname )
{
	if( IsDefined( targetname ) )
	{
		// function is asking for a specific spawn manager struct
		spawn_manager_array = [];

		for( i = 0; i< level.spawn_managers.size; i++ )
		{
			if( level.spawn_managers[i].targetname == targetname )
			{
				ARRAY_ADD( spawn_manager_array, level.spawn_managers[i] );
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
spawn_manager_get_spawners()
{
	// Remove dead spawners //
	
	ArrayRemoveValue(self.allSpawners, undefined);
	
	// Remove other stuff we don't want //

	exclude = [];
	for ( i = 0; i < self.allSpawners.size; i++)
	{
		//CODER_MOD : Dan L
		//Stopping dogs from spawning in game modes that break with them right now...
		if((IsDefined(level._gamemode_norandomdogs)) && (self.allSpawners[i].classname == "actor_enemy_dog_sp"))
		{
			ARRAY_ADD(exclude, self.allSpawners[i]);
		}

		// Spawn manager - parsing of sm_count and sm_active count ranges
		self.allSpawners[i] calculate_count();
	}

	self.allSpawners = array_exclude(self.allSpawners, exclude);

	spawner_count_with_min_active = 0;
	for ( i = 0; i < self.allSpawners.size; i++)
	{
		self.allSpawners[i] spawner_calculate_active_count(self);

		// sm_active_count_min on spawner has to be greater than max group size to be used
		// as a potential spawner.
		if ( self.allSpawners[i].sm_active_count_min >= self.sm_group_size_min )
		{
			spawner_count_with_min_active++;
		}
		
		if( !IsDefined(self.allSpawners[i].activeAI) )
		{
			self.allSpawners[i].activeAI = [];
		}
	}

	assert(spawner_count_with_min_active >= self.allSpawners.size, "On spawn manager '" + self.sm_id + "' with a min group size of " + self.sm_group_size_min + ", you must have all spawners with an active count of at least " + self.sm_group_size_min + ".");

	groupSpawners = self.allSpawners;
	
	spawner_count = self.sm_spawner_count;
	if (spawner_count > self.allSpawners.size)
	{
		spawner_count = self.allSpawners.size;
	}

	// select random spawners //

	spawners = [];
	while(spawners.size < spawner_count)
	{
		spawner = random(groupSpawners);
		ARRAY_ADD(spawners, spawner);
		ArrayRemoveValue(groupSpawners, spawner);
	}
	
	return spawners;
}

spawner_calculate_active_count(spawn_manager)
{
	//-----------------------------------------------------------------------------------------------
	// sm_active_count - Total number of AI that can be active from this spawner, Default = level.spawn_manager_max_ai
	// supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	if( !IsDefined( self.sm_active_count ) )
	{
		// default the spawner active count to the max group size that the spawn manager will try to spawn
		self.sm_active_count = level.spawn_manager_max_ai;
	}

	self.sm_active_count_min = get_min_value( self.sm_active_count );
	self.sm_active_count_max = get_max_value( self.sm_active_count );

	assert( self.sm_active_count_max >= self.sm_active_count_min, "Max value should be greater or equal to the min value for the spawner's sm_active_count on spawn manager " + spawn_manager.sm_id );

	// select the random between min and max.
	self.sm_active_count = RandomIntRange( self.sm_active_count_min, self.sm_active_count_max + 1 );
}

// Select the random group size
spawn_manager_get_spawn_group_size()
{
	if( self.sm_group_size_min < self.sm_group_size_max )
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
cleanup_spawners()
{
	spawners = [];

	for (i = 0; i < self.spawners.size; i++)
	{
		if (IsDefined(self.spawners[i]))
		{
			if(self.spawners[i].count != 0)
			{
				spawners[spawners.size] = self.spawners[i];
			}
			else
			{
				self.spawners[i] delete();
			}
		}
	}

	self.spawners = spawners;
}


//-----------------------------------------------------------------------------------------------
// Co-op scaling always makes sure that it will use ranges ( unless its not specified at all ) for the number of players.
// if the range for the current number of players is not available then, it will try to use the
// range for 1 less number of players.
//-----------------------------------------------------------------------------------------------

// Returns min value for a key based on the co-op scaling
get_min_value( value )
{
	values = strtok( value, " " );

	// get the number of players
	num_players = get_players();
		
	// Try to find a min range for the number of players currently in the game,
	// if not found the exact value then return the previous value and so on.
	for( i = num_players.size - 1; i>=0; i-- )
	{
		if( IsDefined( values[i] ) )
		{
			// Ideally, the max value for current number of players is nex one in values array
			// if its not defined then the current value will be used as max. In this case, we need to use previous
			// value as min value to maintain the range, unless the current index is 0.
	
			if( !IsDefined( values[i+1] ) && i > 0 )
			{
				return Int(values[i-1]);
			}
			else
			{
				return Int(values[i]); // should return undefined if there is no value here.
			}
		}
	}

	return undefined; // ideally we should not hit this
}

// Returns min value for a key based on the co-op scaling
get_max_value( value )
{
	values = strtok( value, " " );
	
	// get the number of players
	num_players = get_players();
		
	// Try to find a max range for the number of players currently in the game,
	// if not found the exact value then return the previous value and so on.
	for( i = num_players.size; i>=0; i--  )
	{
		if( IsDefined( values[i] ) )
		{
			return Int(values[i]); // should return undefined if there is no value here.
		}
	}
	

	return undefined; // ideally we should not hit this
}


spawn_manager_sanity()
{
	assert(self.activeAI.size <= self.sm_active_count);
	assert(self.spawnCount <= self.count);
}

spawn_manager_wait()
{
	// if script_wait is specified, use it just how it is
	if (IsDefined(self.script_wait))
	{
		wait(self.script_wait);

		if( IsDefined( self.script_wait_add ) )
		{
			self.script_wait += self.script_wait_add;
		}
	}
	else if( IsDefined( self.script_wait_min ) && IsDefined( self.script_wait_max ) )
	{
		coop_scalar = 1;
		players = get_players();

		if (players.size == 2)
		{
			coop_scalar = 0.7;
		}
		else if (players.size == 3)
		{
			coop_scalar = 0.5;
		}
		else if (players.size == 4)
		{
			coop_scalar = 0.3;
		}

		// do coop scaling only if a min and max is specified, and stay in that range
		diff = self.script_wait_max - self.script_wait_min;
		wait( RandomFloatrange( self.script_wait_min, self.script_wait_min + (diff * coop_scalar) ) );

		if( IsDefined( self.script_wait_add ) )
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

spawn_manager_flags_setup()
{
	//sm_<targetname>_enabled
	//Set when the spawn manager is enabled.
	//default: false
	flag_init("sm_" + self.sm_id + "_enabled");
	
	//sm_<targetname>_complete
	//Set when the spawn manager completes (spawns up to its sm_count value).
	//Default: false
	flag_init("sm_" + self.sm_id + "_complete");
	
	//sm_<targetname>_killed
	//Set when the spawn manager is killed.
	//Default: false
	flag_init("sm_" + self.sm_id + "_killed");

	//sm_<targetname>_killed
	//Set when the spawn manage is complete/killed and all the AI from this spawn manager are dead.
	//Default: false
	flag_init("sm_" + self.sm_id + "_cleared");
}

spawn_manager_flag_enabled()
{
	assert( !flag( "sm_" + self.sm_id + "_enabled" ), "Spawn manager flags should not be set by the level script." );
	flag_set( "sm_" + self.sm_id + "_enabled" );
}

spawn_manager_flag_disabled()
{
	self.enable = false;
	flag_clear( "sm_" + self.sm_id + "_enabled" );
}

spawn_manager_flag_killed()
{
	assert( !flag( "sm_" + self.sm_id + "_killed" ), "Spawn manager flags should not be set by the level script." );
	flag_set("sm_" + self.sm_id + "_killed");
}


// A spawn manager can be killed but not complete, but when its complete, it is always killed.
spawn_manager_flag_complete()
{
	assert( self.spawnCount <= self.count, "Spawn manager spawned more then the allowed AI's" );
	assert( !flag( "sm_" + self.sm_id + "_complete" ), "Spawn manager flags should not be set by the level script." );
	flag_set("sm_" + self.sm_id + "_complete");
}

spawn_manager_flag_cleared()
{
	assert( !flag( "sm_" + self.sm_id + "_cleared" ), "Spawn manager flags should not be set by the level script." );
	flag_set("sm_" + self.sm_id + "_cleared");
}


//-----------------------------------------------------------------------------------------------
// Spawn manager - parsing of sm_count and sm_active count.
//-----------------------------------------------------------------------------------------------

calculate_count()
{
	//-----------------------------------------------------------------------------------------------
	// Spawn manager - sm_count is same as count on a spawner, but allows to specify a range seperated by space.
	// sm_count overrides count
	//-----------------------------------------------------------------------------------------------

	if( !IsDefined( self.sm_count ) )
	{
		// Check if count is defined instead.
		if (IsDefined(self.count) && (self.count != 0))
		{
			self.sm_count = self.count;
		}
		else
		{
			self.sm_count = 9999; // Any very high number would do.
		}
	}

	// sm_count is defined, parse for min and max values
	self.count_min = get_min_value( self.sm_count );
	self.count_max = get_max_value( self.sm_count );

	if (IsDefined(self.sm_id))
	{
		assert(self.count_max >= self.count_min, "Max range should be greater or equal to the min value for sm_count on spawn manager " + self.sm_id);
	}
	else
	{
		assert(self.count_max >= self.count_min, "Max range should be greater or equal to the min value for sm_count on spawner with targetname " + self.targetname);
	}

	// select the random between min and max.
	// Internally, finalized sm_count is refered as "count" for clarity purposes.
	self.count = spawn_manager_random_count( self.count_min, self.count_max + 1 );
}

// --------------------------------------------------------------------------------
// ---- Debuging functions ----
// --------------------------------------------------------------------------------

/#

spawn_manager_debug()
{
	if( GetDvar( "ai_debugSpawnManager" ) != "1" )
		return;
			
	for(;;)
	{
		managers = get_spawn_manager_array();
	
		managerActiveCount = 0;
		managerPotentialSpawnCount = 0;
		level.debugActiveManagers = [];
			
		for(i=0; i<managers.size; i++)
		{
			if( IsDefined( managers[i] ) && IsDefined( managers[i].enable ) )
			{
				// A spawn manager will be added to the debugActiveManagers if,
				// 1. Its currently enabled
				// 2. Disabled but active - It is disabled after enabling it before ( will be drawn in different color. )
				// 2nd case is true if self.enable is false but self.spawners is defined.
			
				if( ( managers[i].enable ) || ( !managers[i].enable && IsDefined( managers[i].spawners ) ) )
				{
					if(managers[i].count > managers[i].spawnCount)
					{
						// Only increament these counters for enabled spawn managers
						if( ( managers[i].enable ) && IsDefined(managers[i].sm_active_count))
						{
							managerActiveCount += 1;
							managerPotentialSpawnCount += managers[i].sm_active_count;
						}
	
						level.debugActiveManagers[level.debugActiveManagers.size] = managers[i];
					}
				}
			}
		}
		
		// Draw the information on the screen
		spawn_manager_debug_hud_update( level.spawn_manager_active_ai,
									level.spawn_manager_total_count,
									level.spawn_manager_max_ai,
									managerActiveCount,
									managerPotentialSpawnCount
								   );

		wait(0.05);
	}
}

spawn_manager_debug_hud_update( active_ai, spawn_ai, max_ai, active_managers, potential_ai )
{
	if ( GetDvar( "ai_debugSpawnManager" ) == "1" )
	{
		if(!IsDefined(level.spawn_manager_debug_hud_title))
		{
			level.spawn_manager_debug_hud_title = NewHudElem();
			level.spawn_manager_debug_hud_title.alignX = "left";
			level.spawn_manager_debug_hud_title.x = -75;
			level.spawn_manager_debug_hud_title.y = 40;
			level.spawn_manager_debug_hud_title.fontScale = 1.5;
			level.spawn_manager_debug_hud_title.color = (1,1,1);
			//level.spawn_manager_debug_hud_title.font = "bigfixed";
		}

		if( !IsDefined( level.spawn_manager_debug_hud ) )
		{
			level.spawn_manager_debug_hud = [];
		}

		level.spawn_manager_debug_hud_title SetText("SPAWN MANAGER: Total AI: "+spawn_ai+"  Active AI: "+active_ai+"/"+potential_ai+"  Max AI: "+max_ai+"  Active Managers: "+active_managers);

		for(i=0; i<level.debugActiveManagers.size; i++)
		{
			if( !IsDefined( level.spawn_manager_debug_hud[i] ) )
			{
				level.spawn_manager_debug_hud[i] = NewHudElem();
				level.spawn_manager_debug_hud[i].alignX = "left";
				level.spawn_manager_debug_hud[i].x = -70;
				level.spawn_manager_debug_hud[i].fontScale = 1;
				level.spawn_manager_debug_hud[i].y = level.spawn_manager_debug_hud_title.y +(i+1) * 15;
			}

			// If level.current_debug_spawn_manager is defined then color that one differently
			if( IsDefined( level.current_debug_spawn_manager ) && ( level.debugActiveManagers[i] ==  level.current_debug_spawn_manager ) )
			{
				if( !level.debugActiveManagers[i].enable ) // selected and disabled
				{
					level.spawn_manager_debug_hud[i].color = (0,0.4,0); // dark green
				}
				else // selected and enabled
				{
					level.spawn_manager_debug_hud[i].color = (0,1,0);	// green
				}
			}
			else if( level.debugActiveManagers[i].enable ) // enabled
			{
				level.spawn_manager_debug_hud[i].color = (1,1,1); // white
			}
			else // disabled but active
			{
				level.spawn_manager_debug_hud[i].color = (0.4,0.4,.4); // gray
			}

			level.spawn_manager_debug_hud[i] SetText("[  "+level.debugActiveManagers[i].sm_id+"  ]"
													+"       Count: "+level.debugActiveManagers[i].spawnCount+"/"+level.debugActiveManagers[i].count+"("+level.debugActiveManagers[i].count_min+","+level.debugActiveManagers[i].count_max+")"
													+"       Active Count: "+level.debugActiveManagers[i].activeAI.size+"/"+level.debugActiveManagers[i].sm_active_count+"("+level.debugActiveManagers[i].sm_active_count_min+","+level.debugActiveManagers[i].sm_active_count_max+")"
													+"       Group Size: "+level.debugActiveManagers[i].sm_group_size+"("+level.debugActiveManagers[i].sm_group_size_min+","+level.debugActiveManagers[i].sm_group_size_max+")"
													+"       Spawners: "+level.debugActiveManagers[i].spawners.size
													);
		}

		// After re-arrangement, we might have to delete extra hud elements
		if( level.debugActiveManagers.size < level.spawn_manager_debug_hud.size )
		{
			for( i = level.debugActiveManagers.size; i<level.spawn_manager_debug_hud.size; i++ )
			{
				if( IsDefined( level.spawn_manager_debug_hud[i] ) )
				{
					level.spawn_manager_debug_hud[i] Destroy();
				}
			}
		}

	}
	
	// delete the hud elements so far allocated if debugging is turned off or there are no active managers
	if( ( GetDvar( "ai_debugSpawnManager" ) != "1" ) )
	{
		// Clean-up Destroy the HUDs if created earlier
		if( IsDefined( level.spawn_manager_debug_hud_title ) )
		{
			level.spawn_manager_debug_hud_title Destroy();
		}
	
		if( IsDefined( level.spawn_manager_debug_hud ) )
		{
			for(i=0; i<level.spawn_manager_debug_hud.size; i++)
			{
				if( IsDefined( level.spawn_manager_debug_hud ) && IsDefined( level.spawn_manager_debug_hud[i] ) )
				{
					level.spawn_manager_debug_hud[i] Destroy();
				}
			}
			
			level.spawn_manager_debug_hud = undefined;
		}
	}
}




// Reads debug dvars that set key value pairs for the specified spawn manager,
// allows tweaking one spawn manager at a time.
spawn_manager_debug_spawn_manager()
{
	wait_for_first_player();

	level.current_debug_spawn_manager = undefined;
	level.current_debug_spawn_manager_targetname = undefined;
	
	level.test_player = get_players()[0];
	current_spawn_manager_index = -1;
	old_spawn_manager_index = undefined;

	while(1)
	{

		if( GetDvar( "ai_debugSpawnManager" ) != "1" )
		{

			// destroy hud elements if they are allocated before.
			destroy_tweak_hud_elements();
			
			wait(0.05);
			continue;
		}

		if( IsDefined( level.debugActiveManagers ) && ( level.debugActiveManagers.size > 0 ) )
		{
			// First time getting in here, if there is a spawn manager active it will be set at 0'th index
			// in level.activeManagers array.
			if( current_spawn_manager_index == -1 )
			{
				current_spawn_manager_index = 0;
				old_spawn_manager_index = 0;
			}
				
			// Check shoulder button to see if player is in current spawn manager selection mode.
			if( level.test_player buttonPressed("BUTTON_LSHLDR") )
			{
				// save the old index to check if it was changed.
				old_spawn_manager_index = current_spawn_manager_index;

				// Decrement if DPAD_UP was pressed.
				if( level.test_player buttonPressed("DPAD_UP") )
				{
					current_spawn_manager_index--;
	
					if( current_spawn_manager_index < 0 )
					{
						current_spawn_manager_index = 0;
					}
				}
				
				// Increament if DPAD_DOWN was pressed.
				if( level.test_player buttonPressed("DPAD_DOWN") )
				{
					current_spawn_manager_index++;
	
					if( current_spawn_manager_index > level.debugActiveManagers.size - 1 )
					{
						current_spawn_manager_index = level.debugActiveManagers.size - 1;
					}
				}
			}

			// Find the selected spawn manager in the list
			if( IsDefined( current_spawn_manager_index ) && current_spawn_manager_index != -1 )
			{
				if( IsDefined( level.current_debug_spawn_manager ) && IsDefined( level.debugActiveManagers[current_spawn_manager_index] ) )
				{
					if( IsDefined ( old_spawn_manager_index )  && ( old_spawn_manager_index == current_spawn_manager_index ) )
					{
						// Even if current_spawn_manager_index didnt change, new spawn manager may be activated,
						// in that case we will need to reorder and find new value for current_spawn_manager_index to keep the old one seleted.
						if( level.debugActiveManagers[current_spawn_manager_index].targetname != level.current_debug_spawn_manager_targetname )
						{
							// Find a new index
							for(i=0; i<level.debugActiveManagers.size; i++)
							{
								if( level.debugActiveManagers[i].targetname == level.current_debug_spawn_manager_targetname )
								{
									// update the current_spawn_manager_index and old_spawn_manager_index
									current_spawn_manager_index = i;
									old_spawn_manager_index = i;
								}
							}
						}
					}
				}

				if( IsDefined( level.debugActiveManagers[current_spawn_manager_index] ) )
				{
					level.current_debug_spawn_manager = level.debugActiveManagers[current_spawn_manager_index];
					level.current_debug_spawn_manager_targetname = level.debugActiveManagers[current_spawn_manager_index].targetname;
				}
			}
	
			// If found a spawn manager then read new k/v's and update it.
			if( IsDefined( level.current_debug_spawn_manager ) )
			{
				level.current_debug_spawn_manager spawn_manager_debug_spawn_manager_values_dpad();
			}
		}
		else
		{
			// destroy hud elements if they are allocated before.
			destroy_tweak_hud_elements();
		}
		
		wait(0.25);
	}
}



spawn_manager_debug_spawner_values()
{
	if( GetDvar( "ai_debugSpawnManager" ) != "1" )
		return;
				
	while(1)
	{
		if( IsDefined( level.current_debug_spawn_manager ) )
		{
			spawn_manager = level.current_debug_spawn_manager;

			if( IsDefined( spawn_manager.spawners ))
			{
				for( i = 0; i< spawn_manager.spawners.size; i++ )
				{
					current_spawner = spawn_manager.spawners[i];
					
					if( IsDefined( current_spawner) && ( current_spawner.count > 0 ) )
					{
						spawnerFree = current_spawner.sm_active_count - current_spawner.activeAI.size;
						
						// print it on the top
						print3d( ( current_spawner.origin +( 0, 0, 65 ) ), "count:" + current_spawner.count , (0, 1, 0), 1, 1.25 );
						print3d( ( current_spawner.origin +( 0, 0, 85 ) ), "sm_active_count:" + current_spawner.activeAI.size + "/" + spawnerFree + "/" + current_spawner.sm_active_count , (0, 1, 0), 1, 1.25 );
		
					}
				}
			}
			
			wait(0.05);
		}
		
		wait(0.05);
	}
}


ent_print(text)
{
	self endon( "death" );
	
	while( 1 )
	{
		print3d( ( self.origin +( 0, 0, 65 ) ), text, ( 0.48, 9.4, 0.76 ), 1, 1 );
		wait( 0.05 );
	}
	
}


// This function lets the scripter tweak some spawn manager values on the fly.
spawn_manager_debug_spawn_manager_values_dpad()
{

	// create huds for
	// 1. sm_active_count
	// 2. sm_group_size
	// 3. sm_spawner_count

	if( !IsDefined( level.current_debug_index ) )
		level.current_debug_index = 0;

	// debug hud
	if( !IsDefined( level.spawn_manager_debug_hud2 ) )
	{
		level.spawn_manager_debug_hud2 = NewHudElem();
		level.spawn_manager_debug_hud2.alignX = "left";
		level.spawn_manager_debug_hud2.x = -75;
		level.spawn_manager_debug_hud2.y = 150;
		level.spawn_manager_debug_hud2.fontScale = 1.25;
		level.spawn_manager_debug_hud2.color = (1,0,0);
	}
	
	// sm_active_count title index 0
	if( !IsDefined( level.sm_active_count_title ) )
	{
		level.sm_active_count_title = NewHudElem();
		level.sm_active_count_title.alignX = "left";
		level.sm_active_count_title.x = -75;
		level.sm_active_count_title.y = 165;
		level.sm_active_count_title.color = (1,1,1);
	}

	// sm_active_count_min index 1
	if( !IsDefined( level.sm_active_count_min_hud ) )
	{
		level.sm_active_count_min_hud = NewHudElem();
		level.sm_active_count_min_hud.alignX = "left";
		level.sm_active_count_min_hud.x = -75;
		level.sm_active_count_min_hud.y = 180;
		level.sm_active_count_min_hud.color = (1,1,1);
	}

	// sm_active_count_max index 2
	if( !IsDefined( level.sm_active_count_max_hud ) )
	{
		level.sm_active_count_max_hud = NewHudElem();
		level.sm_active_count_max_hud.alignX = "left";
		level.sm_active_count_max_hud.x = -75;
		level.sm_active_count_max_hud.y = 195;
		level.sm_active_count_max_hud.color = (1,1,1);
	}

	// sm_group_size_min index 3
	if( !IsDefined( level.sm_group_size_min_hud) )
	{
		level.sm_group_size_min_hud = NewHudElem();
		level.sm_group_size_min_hud.alignX = "left";
		level.sm_group_size_min_hud.x = -75;
		level.sm_group_size_min_hud.y = 210;
		level.sm_group_size_min_hud.color = (1,1,1);
	}

	// sm_group_size_max index 4
	if( !IsDefined( level.sm_group_size_max_hud ) )
	{
		level.sm_group_size_max_hud = NewHudElem();
		level.sm_group_size_max_hud.alignX = "left";
		level.sm_group_size_max_hud.x = -75;
		level.sm_group_size_max_hud.y = 225;
		level.sm_group_size_max_hud.color = (1,1,1);
	}

	// sm_spawner_count title index 5
	if( !IsDefined( level.sm_spawner_count_title) )
	{
		level.sm_spawner_count_title = NewHudElem();
		level.sm_spawner_count_title.alignX = "left";
		level.sm_spawner_count_title.x = -75;
		level.sm_spawner_count_title.y = 240;
		level.sm_spawner_count_title.color = (1,1,1);
	}
	
	// sm_spawner_count_min index 5
	if( !IsDefined( level.sm_spawner_count_min_hud) )
	{
		level.sm_spawner_count_min_hud = NewHudElem();
		level.sm_spawner_count_min_hud.alignX = "left";
		level.sm_spawner_count_min_hud.x = -75;
		level.sm_spawner_count_min_hud.y = 255;
		level.sm_spawner_count_min_hud.color = (1,1,1);
	}

	// sm_spawner_count_max index 5
	if( !IsDefined( level.sm_spawner_count_max_hud) )
	{
		level.sm_spawner_count_max_hud = NewHudElem();
		level.sm_spawner_count_max_hud.alignX = "left";
		level.sm_spawner_count_max_hud.x = -75;
		level.sm_spawner_count_max_hud.y = 270;
		level.sm_spawner_count_max_hud.color = (1,1,1);
	}
	
	if( level.test_player buttonPressed("BUTTON_LTRIG") )
	{
		if( level.test_player buttonPressed("DPAD_DOWN") )
		{
			level.current_debug_index++;

			if( level.current_debug_index > 7 )
				level.current_debug_index = 7;
		}
		
		if( level.test_player buttonPressed("DPAD_UP") )
		{
			level.current_debug_index--;
			
			if( level.current_debug_index < 0 )
				level.current_debug_index = 0;
		}
	}

	// update the selection
	set_debug_hud_colors();

	increase_value = false;
	decrease_value = false;
	
	// decide to increase or decrese / or dont change, based on the input
	if( level.test_player buttonPressed("BUTTON_LTRIG") )
	{
		if( level.test_player buttonPressed("DPAD_LEFT") )
		{
			decrease_value = true;
		}
			
		if( level.test_player buttonPressed("DPAD_RIGHT") )
		{
			increase_value = true;
		}
	}
	
	should_run_set_up = false;

	// select the proper k/v based on the level.current_debug_index and modify it.
	if( increase_value || decrease_value )
	{
		if( increase_value )
			add = 1;
		else
			add = -1;
		
		switch( level.current_debug_index )
		{
			case 0:
			{
				// sm_active_count
				if( self.sm_active_count + add > self.sm_active_count_max )
				{
					self.sm_active_count_max = self.sm_active_count + add;
				}
				
				if( self.sm_active_count + add < self.sm_active_count_min )
				{
					if( self.sm_active_count + add > 0)
					{
						self.sm_active_count_min = self.sm_active_count + add;
					}
				}

				should_run_set_up = true;
				self.sm_active_count += add;
				break;
			}
			case 1:
			{
				// sm_active_count_min
				if(self.sm_active_count_min + add < self.sm_group_size_max)
				{
					modify_debug_hud2("sm_active_count_min cant be smaller than sm_group_size_max, modify sm_group_size_max and try again.");
					break;
				}
	
				if(self.sm_active_count_min + add > self.sm_active_count_max)
				{
					modify_debug_hud2("sm_active_count_min cant be greater than sm_active_count_max, modify sm_active_count_max and try again.");
					break;
				}
				
				should_run_set_up = true;
				self.sm_active_count_min += add;
				break;
			}
			case 2:
			{
				// sm_active_count_max
				if(self.sm_active_count_max + add < self.sm_active_count_min)
				{
					modify_debug_hud2("sm_active_count_max cant be smaller than sm_active_count_min, modify sm_active_count_min and try again.");
					break;
				}

				should_run_set_up = true;
				self.sm_active_count_max += add;
				break;
			}
			case 3:
			{
				// sm_group_size_min
				if(self.sm_group_size_min + add > self.sm_group_size_max)
				{
					modify_debug_hud2("sm_group_size_min cant be greater than sm_group_size_max, modify sm_group_size_max and try again.");
					break;
				}
	
				should_run_set_up = true;
				self.sm_group_size_min += add;
				break;
			}
			case 4:
			{
				// sm_group_size_max
				if(self.sm_group_size_max + add < self.sm_group_size_min )
				{
					modify_debug_hud2("sm_group_size_max cant be smaller than sm_group_size_min, modify sm_group_size_min and try again.");
					break;
				}

				if(self.sm_group_size_max + add > self.sm_active_count )
				{
					modify_debug_hud2("sm_group_size_max cant be greater than sm_active_count, modify sm_active_count and try again.");
					break;
				}
	
				should_run_set_up = true;
				self.sm_group_size_max += add;
				break;
			}
			case 5:
			{
				// sm_spawner_count
				if(self.sm_spawner_count + add > self.allSpawners.size )
				{
					modify_debug_hud2("sm_spawner_count cant be greater than max possible available spawners, add more spawners in the map and try again.");
					break;
				}

				if(self.sm_spawner_count + add <= 0 )
				{
					modify_debug_hud2("sm_spawner_count cant be less than 0.");
					break;
				}
				
				if(self.sm_spawner_count + add < self.sm_spawner_count_min )
				{
					if( self.sm_spawner_count + add > 0)
					{
						self.sm_spawner_count_min = self.sm_spawner_count + add;
					}
					
				}

				if(self.sm_spawner_count + add > self.sm_spawner_count_max )
				{
					self.sm_spawner_count_max = self.sm_spawner_count + add;
				}
								
				should_run_set_up = true;
				self.sm_spawner_count += add;
				break;
			}
			case 6:
			{
				// sm_spawner_count_min
				if(self.sm_spawner_count_min + add > self.sm_spawner_count_max )
				{
					modify_debug_hud2("sm_spawner_count_min cant be greater than sm_spawner_count_max, modify sm_spawner_count_max and try again.");
					break;
				}
	
				should_run_set_up = true;
				self.sm_spawner_count_min += add;
				break;
			}
			case 7:
			{
				// sm_spawner_count_max
				if(self.sm_spawner_count_max + add < self.sm_spawner_count_min )
				{
					modify_debug_hud2("sm_spawner_count_max cant be smaller than sm_spawner_count_min, modify sm_spawner_count_min and try again.");
					break;
				}
	
				should_run_set_up = true;
				self.sm_spawner_count_max += add;
				break;
			}

		}
	}

	// Run the basic set up to use the new values
	if( should_run_set_up )
	{
		level.current_debug_spawn_manager spawn_manager_debug_setup();
	}

	// draw stuff on the screen
	if( IsDefined( self ) )
	{
		level.sm_active_count_title SetText( "sm_active_count: " + self.sm_active_count );
		level.sm_active_count_min_hud SetText( "sm_active_count_min: " + self.sm_active_count_min );
		level.sm_active_count_max_hud SetText( "sm_active_count_max: " + self.sm_active_count_max );
		
		level.sm_group_size_min_hud SetText( "sm_group_count_min: " + self.sm_group_size_min );
		level.sm_group_size_max_hud SetText( "sm_group_count_max: " + self.sm_group_size_max );

		level.sm_spawner_count_title SetText( "sm_spawner_count: " + self.sm_spawner_count );
		level.sm_spawner_count_min_hud SetText( "sm_spawner_count_min: " + self.sm_spawner_count_min );
		level.sm_spawner_count_max_hud SetText( "sm_spawner_count_max: " + self.sm_spawner_count_max );
	}
}



set_debug_hud_colors()
{
	switch( level.current_debug_index )
	{
		case 0:
		{
			level.sm_active_count_title.color = (0,1,0);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 1:
		{
			level.sm_active_count_title.color = ( 1,1,1 );
			level.sm_active_count_min_hud.color = (0,1,0);
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 2:
		{
			level.sm_active_count_title.color = ( 1,1,1 );
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = (0,1,0);
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 3:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = (0,1,0);
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );

			break;
		}
		case 4:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = (0,1,0);
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 5:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = (0,1,0);
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 6:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = (1,1,1);
			level.sm_spawner_count_min_hud.color = ( 0,1,0 );
			level.sm_spawner_count_max_hud.color = ( 1,1,1 );
			
			break;
		}
		case 7:
		{
			level.sm_active_count_title.color = (1,1,1);
			level.sm_active_count_min_hud.color = ( 1,1,1 );
			level.sm_active_count_max_hud.color = ( 1,1,1 );
			level.sm_group_size_min_hud.color = ( 1,1,1 );
			level.sm_group_size_max_hud.color = ( 1,1,1 );
			level.sm_spawner_count_title.color = ( 1,1,1 );
			level.sm_spawner_count_min_hud.color = ( 1,1,1 );
			level.sm_spawner_count_max_hud.color = ( 0,1,0 );
			
			break;
		}
	}
}


spawn_manager_debug_setup()
{
	//-----------------------------------------------------------------------------------------------
	// sm_spawner_count - The number of spawners that spawn manager will randomly select from the full
	// set of the available spawners, defaults to number of spawners in the spawn manager.
	// Supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	if( IsDefined( level.current_debug_index ) && ( level.current_debug_index != 5 ) )
	{
		self.sm_spawner_count = spawn_manager_random_count( self.sm_spawner_count_min, self.sm_spawner_count_max + 1 );
	}

	//-----------------------------------------------------------------------------------------------
	// sm_active_count - Total number of AI that can be active from this spawner,
	// defaults to number of spawners in the spawn manager.
	// supports min and max seperated by space.
	//-----------------------------------------------------------------------------------------------

	// select the random between min and max only if they are changed
	if( IsDefined( level.current_debug_index ) && ( level.current_debug_index != 0 ) )
	{
		self.sm_active_count = spawn_manager_random_count(self.sm_active_count_min, self.sm_active_count_max+1);
	}
		
	// Grab all the spawners and store it on spawn manager entity.
	self.spawners = self spawn_manager_get_spawners();

	// Sanity Checks if needed
	Assert(self.count >= self.count_min);
	Assert(self.count <= self.count_max);

	Assert(self.sm_active_count >= self.sm_active_count_min);
	Assert(self.sm_active_count <= self.sm_active_count_max);

	// sm_group_size min and max should be less than sm_active_cpunt
	Assert(self.sm_group_size_max <= self.sm_active_count);
	Assert(self.sm_group_size_min <= self.sm_active_count);
}


modify_debug_hud2(text)
{
	self notify("modified");

	wait(0.05);

	level.spawn_manager_debug_hud2 SetText( text );
	level.spawn_manager_debug_hud2 thread moniter_debug_hud2();
}

// waits certain amount of time and then erases the error message,
// this thread is killed if the message is updated, and new thread starts.
moniter_debug_hud2()
{
	self endon("modified");

	wait(10);
	level.spawn_manager_debug_hud2 SetText("");
}


destroy_tweak_hud_elements()
{
	if( IsDefined( level.sm_active_count_title ) )
	{
		level.sm_active_count_title Destroy();
	}

	if( IsDefined( level.sm_active_count_min_hud ) )
	{

		level.sm_active_count_min_hud Destroy();
	}
	
	if( IsDefined( level.sm_active_count_max_hud ) )
	{
		level.sm_active_count_max_hud Destroy();
	}


	if( IsDefined( level.sm_group_size_min_hud ) )
	{
		level.sm_group_size_min_hud Destroy();

	}

	if( IsDefined( level.sm_group_size_max_hud ) )
	{

		level.sm_group_size_max_hud Destroy();
	}

	if( IsDefined( level.sm_spawner_count_title ) )
	{

		level.sm_spawner_count_title Destroy();
	}

	if( IsDefined( level.sm_spawner_count_min_hud ) )
	{

		level.sm_spawner_count_min_hud Destroy();
	}

	if( IsDefined( level.sm_spawner_count_max_hud ) )
	{

		level.sm_spawner_count_max_hud Destroy();
	}
}

#/