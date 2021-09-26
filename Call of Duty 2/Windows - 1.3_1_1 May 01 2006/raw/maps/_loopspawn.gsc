/*
	loop_spawner will spawn AI from a given "actor_*" spawner until it's .count reached 0 or it has been 
	disabled.
	
		Each loop_spawner has a group associated with it, which can be specified on the spawner entity by
	setting .groupname to the desired string.  This allows you to have multiple sets in a single group.
	If no .groupname is specified, the loop_spawner will create a default group with the same name as the 
	spawners targetname (or script_noteworthy).
	
	Radiant Usage:
	On actor_* spawner entites:
	  .groupname "string" [default = targetname or script_noteworthy] (optional)
	    This spawner is a member of the specified group.
	  .count n [default = 1] (optional)
	    Total number of AI for this spawner to spawn over it's own lifetime
	  .script_delay or .script_delay_min and .script_delay_max (optional)
	    How long to wait between spawning each AI.
	  .script_uniquename "string"
	    If the same name is specified on more than one spawner, only one living instance of that AI
	    will be allowed in the level at any given time.  Useful for spawning the "same" guy at different
	    spawner sets. (optional) 
	    
	On trigger_* entites:
	  .script_enable "string"
	    Spawner group to enable when this is triggered.
	  .script_disable "string"
	    Spawner group to disable when this is triggered.
	  .script_kill "string"
	  	Spawner group to permanently disable when this is triggered.
	
	Script Usage:
	thread loop_spawner (strSpawners, strKey, fnThink, bStartEnabled);
	  strSpawners = name of the spawners as specified in radiant via "targetname" or "script_noteworthy"
	  strKey = key whose value matches strSpawners (only "targetname" and "script_noteworthy" are valid)
	  fnThink = think function to thread off on the spawned AI (optional)
	  bStartEnabled = enable this spawner upon startup [defaults to false]
	
	level.loop_spawner_maxai["loop spawner group"] = 1-32 [default = 32] (optional)
	  allows you to specify the max living AI at any given time for this loop_spawner group
	  
	level.loop_spawner_multi["loop spawner group"] = true/false; [default = false]
	  allows individual spawners to spawn more than one AI at a time

	level notify (strSpawners, strState);
	  strSpawners = name of the spawner group to act upon
	  strState = what to do with the specified spawner group (only "enable" and "disable" are valid)
	  
	Examples:
	// spawns AI from each spawner named "allies_squad1" until it's .count reaches 0
	// only 1 living AI per spawner is allowed at any given time
	thread loop_spawner ("allies_squad1", "targetname", undefined, true);

	// same as above example, but will not begin spawning until recieves an "enable" notify
	thread loop_spawner ("allies_squad1", "targetname");
	...
	level notify ("allies_squad1", "enable");

	// spawns a total of up to 5 living AI from any number of spawner sets that are in the "allied_squads" group
	level.loop_spawner_maxai["allied_squads"] = 5;
	level.loop_spawner_multi["allied_squads"] = true;
	thread loop_spawner ("allies_squad1", "targetname", ::allies_think, true); // this entity has a .groupname of "allied_squads"
	thread loop_spawner ("allies_squad2", "targetname", ::allies_think, true); // this entity has a .groupname of "allied_squads"
*/

#include maps\_utility;

/*
Script Notes:
ls_tracker functions of called only on trackers
ls_spawner functions are called only on spawners
*/


// find all loop_spawner_triggers and thread off their think function (used to disable/enable loop_spawners)
loop_spawner_init()
{
	aeLoopSpawnerTriggers = getentarray ("loop_spawner_trigger", "targetname");
	array_thread (aeLoopSpawnerTriggers, ::loop_spawner_trigger);
	/*
	aeTargetnameLoopSpawners = [];
	aeNoteworthyLoopSpawners = [];
	aeSpawners = getspawnerarray ();
	
	for (i = 0; i < aeSpawners.size; i++)
	{
		if (isdefined (aeSpawners[i].script_loopspawner))
		{
			if (aeSpawners[i].script_loopspawner == "targetname"));
				aeTargetnameLoopSpawners[aeTargetnameLoopSpawners.size] = self.targetname;
			else if (aeSpawners[i].script_loopspawner == "script_noteworthy")
				aeNoteworthyLoopSpawners[aeNoteworthyLoopSpawners.size] = self.script_noteworthy;
		}
	}

	for (i = 0; i < aeTargetnameLoopSpawners.size; i++)
		thread loop_spawner (aeTargetnameLoopSpawners[i], "targetname");

	for (i = 0; i < aeNoteworthyLoopSpawners.size; i++)
		thread loop_spawner (aeNoteworthyLoopSpawners[i], "script_noteworthy");
	*/
}

loop_spawner (strSpawners, strKey, fnThink, bStartEnabled)
{
	aeSpawners = getentarray (strSpawners, strKey);
	assert (isdefined (aeSpawners));

	//// Sort the spawners by priority
	aeSpawners = loop_spawner_sort (aeSpawners);
	
	for (i = 0; i < aeSpawners.size; i++)
	{
		if (isdefined (aeSpawners[i].groupname))
			strGroup = aeSpawners[i].groupname;
		else
			strGroup = strSpawners;

		//// If the tracker doesn't exist, create it			
		if (!isdefined (level._loop_spawner_tracker) || !isdefined (level._loop_spawner_tracker[strGroup]))
			loop_spawner_tracker_init(strGroup);
		
		//// Add this spawner set to list of spawner sets owned by this tracker group
		level._loop_spawner_tracker[strGroup] ls_tracker_addsubgroup (strSpawners);
		
		//// Initialize the spawners
		aeSpawners[i] ls_spawner_init (strSpawners, strGroup, fnThink, bStartEnabled);
	}
}

loop_spawner_tracker_init (strGroup)
{
	level._loop_spawner_tracker[strGroup] = spawnstruct();
	level._loop_spawner_tracker[strGroup].strGroup = strGroup;
	
	if (!isdefined (level.loop_spawner_maxai) || !isdefined (level.loop_spawner_maxai[strGroup]))
		level._loop_spawner_tracker[strGroup].iMaxAI = 32;
	else
		level._loop_spawner_tracker[strGroup].iMaxAI = level.loop_spawner_maxai[strGroup];
	
	if (!isdefined (level.loop_spawner_multi) || !isdefined (level.loop_spawner_multi[strGroup]))
		level._loop_spawner_tracker[strGroup].bMulti = false;
	else
		level._loop_spawner_tracker[strGroup].bMulti = level.loop_spawner_multi[strGroup];
	
	level._loop_spawner_tracker[strGroup].iCurAI = 0;
	level._loop_spawner_tracker[strGroup].aeWaitList = [];
	level._loop_spawner_tracker[strGroup].astrSubGroups = [];
	level._loop_spawner_tracker[strGroup].bSpawnOk = true;
	level._loop_spawner_tracker[strGroup].astrLiveUniques = [];

	level._loop_spawner_tracker[strGroup] thread ls_tracker_waiter();
}

ls_spawner_init (strSpawners, strGroup, fnThink, bStartEnabled)
{
	self.bLoopSpawner = true;
	self.strEntName = strSpawners;
	self.eTracker = level._loop_spawner_tracker[strGroup]; // back link to tracker
	self.fnThink = fnThink;

	if (isdefined (bStartEnabled))
		self.bEnabled = bStartEnabled;
	else
		self.bEnabled = false;

	self thread ls_spawner_waiter();
	self thread ls_spawner_think();
}

ls_tracker_addsubgroup (strSubGroup)
{
	if (!is_in_array(self.astrSubGroups, strSubGroup))
		self.astrSubGroups = add_to_array(self.astrSubGroups, strSubGroup);
}

ls_spawner_think()
{
	self endon ("death");
	self endon ("killspawner");

	while (self.count)
	{
		//// Wait for the tracker to approve our spawn
		self ls_spawner_waitforapproval();

		//// Attempt to spawn AI
		eSpawnedAI = self dospawn();		
		self.eTracker ls_tracker_addai (self); // this is necessary to fix sequencing issues
		if (spawn_failed(eSpawnedAI))
		{
			self.eTracker ls_tracker_subai (self);
			wait 2.0;
			continue;
		}		

		if (isdefined (self.fnThink))
			eSpawnedAI thread [[self.fnThink]]();

		if (self.eTracker.bMulti)
			self thread ls_spawner_death_waiter (eSpawnedAI); // non-blocking death wait allows for multiple spawns
		else
			self ls_spawner_death_waiter (eSpawnedAI);
		
		wait eSpawnedAI get_script_delay();
	}
}

ls_spawner_death_waiter (eSpawnedAI)
{	
	self.eTracker ls_tracker_addliveunique (self.script_uniquename);
	eSpawnedAI waittill ("death");
	self.eTracker ls_tracker_subliveunique (self.script_uniquename);
	self.eTracker thread ls_tracker_subai (self);
}

loop_spawner_sort (aeSpawners)
{
	aeSortedSpawners = [];
	aeGenericSpawners = [];
	//// Sort out the named spawners
	for (i = 0; i < aeSpawners.size; i++)
	{
		if (isdefined (aeSpawners[i].script_uniquename))
			aeSortedSpawners[aeSortedSpawners.size] = aeSpawners[i];
		else
			aeGenericSpawners[aeGenericSpawners.size] = aeSpawners[i];		
	}
	//// Randomize the generic spawners
	aeGenericSpawners = array_randomize (aeGenericSpawners);
	
	//// Add generic spawners to end of named spawner list
	for (i = 0; i < aeGenericSpawners.size; i++)
		aeSortedSpawners[aeSortedSpawners.size] = aeGenericSpawners[i];
	
	return aeSortedSpawners;
}

ls_tracker_addliveunique (strUnique)
{
	if (isdefined (strUnique))
	{
		assertex(!self.bMulti, "script_uniquename specified in spawner set using multi-spawning");
		self.astrLiveUniques = add_to_array (self.astrLiveUniques, strUnique);
	}
}

ls_tracker_subliveunique (strUnique)
{
	if (isdefined (strUnique))
		self.astrLiveUniques = array_remove (self.astrLiveUniques, strUnique);
}

ls_spawner_waitforapproval()
{
	self endon ("killspawner");

	while (!self.bEnabled || !self.eTracker.bSpawnOk)
	{
		if (self.bEnabled) // only on the wait list if we're enabled
			self.eTracker ls_tracker_addwaiter (self);

		self waittill ("checkspawn");
		self.eTracker ls_tracker_subwaiter (self); // used to prevent redundant adds to the wait list if we're not allowed to spawn
	}
}

//// Handler for level wide messages
ls_tracker_waiter()
{
	while (1)
	{
		level waittill (self.strGroup, strAction, strExcluder);
		
		switch (strAction)
		{
		case "disablegroup":
			for (i = 0; i < self.astrSubGroups.size; i++)
			{
				if (!isdefined (strExcluder) || self.astrSubGroups[i] != strExcluder)
					level notify (self.astrSubGroups[i], "disable");
			}
			break;
		case "killgroup":
			for (i = 0; i < self.astrSubGroups.size; i++)
				level notify (self.astrSubGroups[i], "kill");
			break;
		}
	}	
}

//// Handler for level wide messages
ls_spawner_waiter()
{
	while (1)
	{
		level waittill (self.strEntName, strAction);
		
		switch (strAction)
		{
		case "enable":
			if (self.bEnabled)
				continue;
			self.bEnabled = true;
			self.eTracker ls_tracker_addwaiter (self);
			self.eTracker ls_tracker_checkspawn (self);
			break;
		case "disable":
			if (!self.bEnabled)
				continue;
			self.bEnabled = false;
			self.eTracker ls_tracker_subwaiter (self);
			self.eTracker ls_tracker_checkspawn (self);
			break;
		case "kill":
			self.eTracker ls_tracker_subwaiter (self);
			self notify ("killspawner");
			break;
		}
	}	
}

ls_tracker_addai (eSpawner)
{
	self.iCurAI++;
	
	if (self.iCurAI >= self.iMaxAI)
		self.bSpawnOk = false;
}

ls_tracker_subai (eSpawner)
{
	self.iCurAI--;

	if (self.iCurAI < self.iMaxAI)
		self.bSpawnOk = true;

	self ls_tracker_checkspawn (eSpawner); // try to spawn an AI since we now have a free slot
}

ls_tracker_checkspawn (eSpawner)
{
	if (!self.bSpawnOk)
		return;
		
	self.aeWaitList = loop_spawner_sort (self.aeWaitList);
	for (i = 0; i < self.aeWaitList.size; i++)
	{
		// prevents living unique AI from being duplicated
		if (isdefined (self.aeWaitList[i].script_uniquename) && (is_in_array(self.astrLiveUniques, self.aeWaitList[i].script_uniquename)))
			continue;

		self.aeWaitList[i] notify ("checkspawn");
		break;
	}
}

ls_tracker_addwaiter (eCaller)
{
	isInArray = is_in_array (self.aeWaitList, eCaller);
	assert (!isInArray); // safety check
	
	self.aeWaitList = add_to_array (self.aeWaitList, eCaller);
}

ls_tracker_subwaiter(eCaller)
{
	self.aeWaitList = array_remove (self.aeWaitList, eCaller);
}

loop_spawner_trigger()
{
	while (1)
	{
		self waittill ("trigger");
		
		if (isdefined (self.script_disable))
		{
			if (self.script_disable == "all" && isdefined (self.groupname))
				level notify (self.groupname, "disablegroup", self.script_enable);
			else
				level notify (self.script_disable, "disable");
		}
		if (isdefined (self.script_enable))
		{
			level notify (self.script_enable, "enable");
		}
		if (isdefined (self.script_kill))
		{
			if (self.script_kill == "all" && isdefined (self.groupname))
				level notify (self.groupname, "killgroup");
			else
				level notify (self.script_kill, "kill");
		}
	}
}

get_script_delay()
{
	if (isdefined (self.script_delay))
		return (self.script_delay);
	else if ((isdefined (self.script_delay_min)) && (isdefined (self.script_delay_max)))
		return (self.script_delay_min + randomfloat (self.script_delay_max - self.script_delay_min));
	else
		return (1 + randomfloat (2));
}
