//----------------------------------------------------------------------------------------------------------
// *** USING the new and improved OKI3 SQUAD MANAGER! ***
//----------------------------------------------------------------------------------------------------------
//		1 - place some spawners and give them a script_squadname kvp
//		2 - place some goal nodes, give them a targetname that is the same as the script_squadname above
//		3 -	call the function below
//		
//		-->	manage_spawners(strSquadName,mincount,maxcount,ender,spawntime, spawnfunction,wave_min,wave_max,waiter)
//
//  	strSquadName  -- is the script_squadname on the spawners
//		MinCount -- Once the number of AI alive is reduced to this number, more will be spawned
//		MaxCount -- The maximum number of AI this spawner will allow at any one time
//		Ender -- the notify that stops this spawner
//		spawntime -- the time between each spawn
//		SpawnFunction -- Any function you desire the AI in this squad to run once they spawn
//		wave_min -- minimum time to wait before spawning a new wave of reinforcements 
//		wave_max -- maximum time to wait before spawning a new wave of reinforcements
//		waiter --	wait until this level notification before spawning in the next wave of guys
//		
//
//----------------------------------------------------------------------------------------------------------


//	find all the guys in this squad and add them to an array 
//	damn usefull
//	now with more value added fat . basically it now will work for both axis and allied 

alive_array(strSquadName)
{
	aSquad = [];
	aRoster = getaiarray();
	for (i=0;i<aRoster.size;i++)
	{
		if (isdefined(aRoster[i].script_squadname))
		{
			if (aRoster[i].script_squadname == strSquadName)
			{
				aSquad[aSquad.size] = aRoster[i];
			}
		}
	}	
	return(aSquad);
}

//	get all the spawn points , usefull maybe ?

spawn_array(strSquadName)
{
	squad_spawn = [];	//	the spawn array , never updates
	aSpawner = getspawnerarray();	

	for(i=0; i<aSpawner.size; i++)
	{
		//	find a spawner for my squad 
		if (isdefined (aSpawner[i].script_squadname))
		{
			if (aSpawner[i].script_squadname == strSquadName)
			{
				squad_spawn[squad_spawn.size] = aSpawner[i];
			}
		}
	}
	return(squad_spawn);
}

set_goals(squad_array,targets)
{
	for (i=0;i<squad_array.size;i++)
	{
		rr = randomint(targets.size);
		squad_array[i] setgoalpos(targets[rr].origin);
	}
}

//CP - 5/23/08
// added support for a delay between waves of spawns
manage_spawners(strSquadName,mincount,maxcount,ender,spawntime, spawnfunction,wave_min,wave_max,waiter)
{
	println("********************************");
	println("SQUAD ",strSquadName);
	println("must have ",mincount," alive until we hit we get this \"",ender,"\" message");
	println("spawning every ",spawntime," seconds");
	println("********************************");

	self endon (ender);

	//---------------------------------------------------------------------------
	//	set up 
	//---------------------------------------------------------------------------

	//	squad_spawn will be just the spawn points for this squad
	spawn_index = 0;	//	an index into the spawn array
	goal_index = 0;

	//	grab the target nodes for this squad 
	squad_targets = getnodearray (strSquadName,"targetname");
	squad_spawn = spawn_array(strSquadName);
	
	if ( squad_spawn.size == 0 )
	{
		maps\_utility::error("SQUAD MANAGER:  Could not find spawners for squad " + strSquadName);
		return;
	}
	if ( squad_targets.size == 0 )
	{
		maps\_utility::error("SQUAD MANAGER:  Could not find target nodes for squad " + strSquadName);
		return;
	}
	
	//---------------------------------------------------------------------------
	//	main loop
	//---------------------------------------------------------------------------


	if (!isdefined(spawntime))
		spawntime = 0.05;
		
	while(1)
	{
		aSquad = alive_array(strSquadName);	//	alive squad ai's
		//	we don't have enough guys in the squad 
		//	spawn a new one
		
		if (aSquad.size < mincount)
		{
			level notify (strSquadName + "_threshold");
			
			if(isDefined(waiter))
			{
				level waittill(waiter);
			}
			//CP - reget the spawner array each time, so that the spawners can be modified in script while this is running
			squad_spawn = spawn_array(strSquadName);
	
			//println (strSquadName + " min threshold reached");
			while ( aSquad.size < maxcount )
			{

				// if the variable is set use the stalingradspawn function which 
				// forces the spawn even if the player can see the spawn point
				if(	isdefined(squad_spawn[spawn_index].script_forcespawn) 
					&& squad_spawn[spawn_index].script_forcespawn )
				{	
					spawned = squad_spawn[spawn_index] stalingradSpawn();
				}
				else
				{
					spawned = squad_spawn[spawn_index] doSpawn();
				}
				
				//	if we spawned ok then we can set the goal 
				if (isdefined(spawned))
				{
//					rr = randomint(squad_targets.size);

					spawned setgoalnode(squad_targets[goal_index]);
					spawned.sm_goalnode = squad_targets[goal_index];

					goal_index = goal_index + 1;
					if (goal_index >= squad_targets.size)
						goal_index = 0;
					
					// store the goal node that this guy is being sent to
					
					wait(0.01);
					
					//spawned.goalradius = 256;
					
					aSquad[aSquad.size] = spawned;
					
					// call the given spawn function on the spawned guy
					if ( isDefined(spawnfunction) )
					{
						spawned thread [[spawnfunction]]();
					}
					else
					{
						spawned thread advance();
					}
				}
				//	move to next spawn point , bounds checking it 
				spawn_index = spawn_index + 1;
				if (spawn_index>=squad_spawn.size)
					spawn_index = 0;
					
				wait(spawntime);				
			}
						
			//wait to spawn the next wave of guys 
			wave_delay = .05;
			if(isDefined(wave_min))
			{
				min = wave_min;
				max = wave_min + .05;
				if(isDefined(wave_max))
				{
					max = wave_max;
				}
				wave_delay = randomfloatrange(min,max);
			}
			wait(wave_delay);			
		}
		wait(.05);
	}
}

advance()
{
	self endon("death");
	
	if ( !isDefined(self.sm_goalnode) )
	{
		println("AI does not have sm_goalnode set.  Can not advance.");
		return;
	}
	
	// if there is no target in the goal node dump out
	if ( !isDefined(self.sm_goalnode.target) )
	{
		return;
	}
	
	if ( !isDefined(self.sm_advance_wait_min) )
		self.sm_advance_wait_min = 5;
		
	if ( !isDefined(self.sm_advance_wait_max) )
		self.sm_advance_wait_max = 15;
	
	// wait until guy gets to goal
	self waittill("goal");
	
	wait( randomint(self.sm_advance_wait_min, self.sm_advance_wait_max) );
	
	self pick_random_goal_node();
		
	self thread advance();
}

advance_on_notify( advancenotifystring )
{
	self endon("death");
	
	if ( !isDefined(self.sm_goalnode) )
	{
		println("AI does not have sm_goalnode set.  Can not advance.");
		return;
	}
	
	// if there is no target in the goal node dump out
	if ( !isDefined(self.sm_goalnode.target) )
	{
		return;
	}
	
	// wait until guy gets go string
	self waittill(advancenotifystring);
	
	self pick_random_goal_node();
		
	if ( isDefined( self.sm_goalnode ) )
	{
		self thread advance_on_notify(advancenotifystring);
	}
}

pick_random_goal_node()
{
	targets = getnodearray (self.sm_goalnode.target,"targetname");
	
	// if there are no chained nodes then just dump out
	if ( targets.size == 0 )
	{
		self.sm_goalnode = undefined;
		return;
	}
	
	index = randomint(targets.size);
	self setgoalnode(targets[index]);

	self.sm_goalnode = targets[index];
}