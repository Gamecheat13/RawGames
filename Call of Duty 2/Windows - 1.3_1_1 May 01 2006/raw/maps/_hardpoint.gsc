#include maps\_utility;
createHardpoint (name, msg, obj, icon)
{
	if (!isdefined (level.objective_hardPoint))
		level.objective_hardPoint = [];
		
	ent = spawnstruct();
	ent.name = name;
	ent.msg = msg;
	
	if (isdefined (obj))
		ent.obj = obj;
	else
		ent.obj = -1;
	
	if(isdefined (icon))
	{
		if(icon == "A" || icon == "B" || icon == "C" || icon == "D" || icon == "E" || icon == "F")
			ent.icon = ("objective" + icon);
		else
		{
			ent.icon = undefined;
			assertEX(isdefined(ent.icon),"Hardpoint " + name + " is using an invalid Icon Letter: valid ones are A-F");
		}
	}
	else
		ent.icon = undefined;
		
	level.objective_hardPoint[level.objective_hardPoint.size] = ent;
}

getHardPointMsg (name)
{
	for (i=0;i<level.objective_hardPoint.size;i++)
	{
		if (level.objective_hardPoint[i].name != name)
			continue;
		
		return level.objective_hardPoint[i].msg;
	}

	assertMsg("Hardpoint " + name + " does not exist");
	return undefined;
}

getHardPointIcon (name)
{
	for (i=0;i<level.objective_hardPoint.size;i++)
	{
		if (level.objective_hardPoint[i].name != name)
			continue;
		
		return level.objective_hardPoint[i].icon;
	}

	assertMsg("Hardpoint " + name + " does not exist");
	return undefined;
}

getHardPointObj (name)
{
	for (i=0;i<level.objective_hardPoint.size;i++)
	{
		if (level.objective_hardPoint[i].name != name)
			continue;
		
		return level.objective_hardPoint[i].obj;
	}

	assertMsg("Hardpoint " + name + " does not exist");
	return undefined;
}

startHardPointObjectives()
{
	//Establish hardpoints
	
	aHardpoints = getentarray ("hardpoint","targetname");
	aHardpointTriggers = getentarray ("hardpoint_trigger","targetname");
	if (!aHardpoints.size)
		return;
	aHardpointObjectives = [];
	
//	for(i=0; i<aHardpoints.size; i++)
//		level.eHardpoint[aHardpoints[i].script_noteworthy] = aHardpoints[i];
	
	for(i=0; i<aHardpoints.size; i++)
	{
		msg = undefined;
		hardpoint = aHardpoints[i];
		
		assertEX(isdefined(hardpoint.script_noteworthy), "Hardpoint script_noteworthy isn't being defined");
		level.flag["Hardpoint Complete " + hardpoint.script_noteworthy] = false;
		
		msg 	= getHardPointMsg 	(hardpoint.script_noteworthy);
		icon 	= getHardPointIcon 	(hardpoint.script_noteworthy);	
		obj 	= getHardPointObj 	(hardpoint.script_noteworthy);		
		if (obj == -1)
			obj = i+1;

		

		hardpoint.obj = obj;
		if(msg != "no message")
		{
			if(isdefined (icon))
				objective_add(obj, "active", msg, hardpoint.origin, icon);
			else
				objective_add(obj, "active", msg, hardpoint.origin);
			aHardpointObjectives[aHardpointObjectives.size] = hardpoint;
		}		
		for (p=0;p<aHardpointTriggers.size;p++)
		{
			assertEX(isdefined(aHardpointTriggers[p].script_noteworthy), "Hardpoint_trigger script_noteworthy isn't being defined as name of hardpoint");
		
			if (aHardpointTriggers[p].script_noteworthy != hardpoint.script_noteworthy)
				continue;
			if(msg != "no message")		
				aHardpointTriggers[p].objectiveNumber = obj;
			else
				aHardpointTriggers[p].objectiveNumber = -2;
		}
	}
		
	if (aHardpointObjectives.size == 1)
		objective_current( aHardpointObjectives[0].obj );
	if (aHardpointObjectives.size == 2)
		objective_current( aHardpointObjectives[0].obj, aHardpointObjectives[1].obj );
	if (aHardpointObjectives.size == 3)
		objective_current( aHardpointObjectives[0].obj, aHardpointObjectives[1].obj, aHardpointObjectives[2].obj  );
	if (aHardpointObjectives.size == 4)
		objective_current( aHardpointObjectives[0].obj, aHardpointObjectives[1].obj, aHardpointObjectives[2].obj, aHardpointObjectives[3].obj   );
	if (aHardpointObjectives.size == 5)
		objective_current( aHardpointObjectives[0].obj, aHardpointObjectives[1].obj, aHardpointObjectives[2].obj, aHardpointObjectives[3].obj, aHardpointObjectives[4].obj );
	if (aHardpointObjectives.size == 6)
		objective_current( aHardpointObjectives[0].obj, aHardpointObjectives[1].obj, aHardpointObjectives[2].obj, aHardpointObjectives[3].obj, aHardpointObjectives[4].obj, aHardpointObjectives[5].obj );
	if (aHardpointObjectives.size == 7)
		objective_current( aHardpointObjectives[0].obj, aHardpointObjectives[1].obj, aHardpointObjectives[2].obj, aHardpointObjectives[3].obj, aHardpointObjectives[4].obj, aHardpointObjectives[5].obj, aHardpointObjectives[6].obj );
	
	level.objectivesRemaining = aHardpoints.size;
	array_levelthread (aHardpointTriggers, ::hardPointTrigger);

	//objective_additionalposition(<integer objective_index>, <integer position_index>, <vect3 position>);
	
//	for(i=0; i<aHardpoints.size; i++)
//		objective_additionalposition(0, i, level.eHardpoint[aHardpoints[i].script_noteworthy].origin);
		
}

playerHardpointTest()
{
	self endon ("player left hardpoint trigger");
	for (;;)
	{
		wait (0.5);
		if (level.player istouching (self))
			continue;
			
		self notify ("player left hardpoint trigger");
		break;
	}
}

hardPointClearingLogic(ent)
{
	self notify ("player left hardpoint trigger");
	self endon ("player left hardpoint trigger");
	self thread playerHardpointTest();
	self waittill ("trigger");
	waitUntil_HardpointIsCleared(self);
	ent.cleared = true;
	self notify ("player left hardpoint trigger");
}

hardPointTrigger (trigger)
{
	ent = spawnstruct();
	ent.cleared = false;
	
	if (isdefined(trigger.target))
	{
		// If the hardpoint targets triggers, they're used to spawn reinforcement friendlies that attack the hardpoint.
		array_levelthread (getentarray (trigger.target, "targetname"), ::reinforceTrigger, trigger.script_noteworthy);
	}
	
	for (;;)
	{
		trigger hardPointClearingLogic(ent);
		if (ent.cleared)
			break;
	}
	if(trigger.objectiveNumber != -2)
		objective_state (trigger.objectiveNumber, "done");
	flag_set("Hardpoint Complete " + trigger.script_noteworthy);
	autoSaveByName (trigger.script_noteworthy);
	
	if (isdefined (trigger.script_emptyspawner))
	{
		spawners = getspawnerarray();
		for (i=0;i<spawners.size;i++)
		{
			if ((isdefined (spawners[i].script_emptyspawner)) && (trigger.script_emptyspawner == spawners[i].script_emptyspawner))
			{
//				level thread debug_message ("DELETED", spawners[i].origin);
				spawners[i] delete();
			}
		}
	}
		
	trigger delete();
	level.objectivesRemaining--;
}

waitUntilEvac(trigger)
{
	self endon ("death");
	for (;;)
	{
		wait (0.05);
		if (self istouching (trigger))
			continue;
			
		wait (1);
		
		if (self istouching (trigger))
			continue;
		
		break;
	}
}

waitUntil_HardpointIsCleared(trigger)
{
	for (;;)
	{
		cleared = true;
		ai = getaiarray ("axis");
		for (i=0;i<ai.size;i++)
		{
			enemy = ai[i];
			wait (0.05);
			
			if (!isalive (enemy))
				continue;
				
			if (!(enemy istouching (trigger)))
				continue;
				
			cleared = false;
			enemy waitUntilEvac(trigger);
			break;
		}
		
		if (cleared)
			break;
	}
	/*
	// Get all the current hardpoint defenders
	defenders = [];
	ai = getaiarray ("axis");
	for (i=0;i<ai.size;i++)
	{
		if (!ai[i] istouching (trigger))
			continue;
			
		// Don't count AI that are currently fleeing
		if (isdefined (ai[i].escapingHardpoint))
			continue;
			
		defenders[defenders.size] = ai[i];
	}
	ai = undefined;
	
	// no defenders?
	if (!defenders.size)
		return;

	ent = spawnstruct();
	ent.count = defenders.size;
	
	for (i=0;i<defenders.size;i++)
		level thread hardPointDefender_WaitsForDeath(defenders[i], ent);
		
	for (;;)
	{
		ent waittill ("Guy died or fled");
		if (!ent.count)
			break;
	}
	*/
}

hardPointDefender_WaitsForDeath(guy, ent)
{
	waitUntil_defenderDiesOrFlees(guy);	
	ent.count--;
	ent notify ("Guy died or fled");
}

waitUntil_defenderDiesOrFlees(guy)
{
	guy endon ("death");
	guy waittill ("escape your doom");
}


// Handles the spawning of extra friendlies from nearby buildings that help attack the hardpoint.
friendlyReinforcements()
{
	array_levelthread (getentarray ("reinforcement","targetname"), ::reinforceTrigger, undefined);
}

reinforceTrigger(trigger, hardpoint)
{
	// The spawners don't use the auto spawning logic.
	spawners = getentarray (trigger.target,"targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i].triggerUnlocked = true;
		
	if (isdefined (trigger.script_noteworthy))
		level waittill (trigger.script_noteworthy);
		
	for (;;)
	{
		trigger waittill ("trigger");
		spawners = getentarray (trigger.target,"targetname");
		
		// spawners have been deleted?
		if (!spawners.size)
			return;
			
		// Total # of friendlies from the spawner and current living allies combined fits into the max # of friendlies allowed
		allies = getaiarray ("allies");
		if (allies.size + spawners.size <= level.maxFriendlies)
			break;

		wait (0.5);
	}		

	hardPointTarget = trigger.targetname;
	trigger delete();

	// Reinforcements with no hardpoint just join the player's party after moving to some set destination.
	if (!isdefined (hardpoint))
	{
		for (i=0;i<spawners.size;i++)
		{	
			spawner = spawners[i];
			
			spawner.count = 1;
			spawn = spawner dospawn();
			
			if (spawn_failed(spawn))
				continue;
				
			assert (isdefined(spawn.target));
				
			spawn thread reinforcementAllyThinkNoHardpoint();
		}
	
		for (i=0;i<spawners.size;i++)
			spawners[i] delete();

		return;
	}

	// Hardpoint is already cleared
	if (flag ("Hardpoint Complete " + hardpoint))
		return;

	spawned = [];

	for (i=0;i<spawners.size;i++)
	{	
		spawner = spawners[i];
		
		spawner.count = 1;
		spawn = spawner dospawn();
		
		if (spawn_failed(spawn))
			continue;
			
		spawned[spawned.size] = spawn;
		spawn thread reinforcementAllyThink(hardpoint);
	}

	for (i=0;i<spawners.size;i++)
		spawners[i] delete();
	
	
	hardPointTrigger = undefined;
	hardPointTrigger = getentarray(hardPointTarget, "target")[0];
	
	for (;;)
	{
		defenders = [];
		ai = getaiarray ("axis");
		for (i=0;i<ai.size;i++)
		{
			// Spread it out over a second just to be nice to the framerate
			wait (0.05);
			if (!isalive (ai[i]))
				continue;
				
			if (!(ai[i] istouching (hardPointTrigger)))
				continue;
				
			defenders[defenders.size] = ai[i];
		}
		
		if (defenders.size)
			break;

		wait (0.05);
	}
	
	newDefenders = [];
	for (i=0;i<defenders.size;i++)
	{
		defender = defenders[i];
		if (!isalive(defender))
			continue;
		newDefenders[newDefenders.size] = defender;
	}
	
	for (i=0;i<spawned.size;i++)
	{
		spawn = spawned[i];
		if (!isalive(spawn))
			continue;
			
		spawn notify ("found an enemy for the reinforcements", newDefenders);
	}
}

reinforcementAllyThinkNoHardpoint()
{
	self endon ("death");
	reinforcementAllyMoveToGoal();
	self.friendlyWaypoint = true;
}

reinforcementAllyThink(hardpoint)
{
	self thread reinforcementAllyHardpointCleared(hardpoint);
	// Hardpoint is already cleared
	if (flag ("Hardpoint Complete " + hardpoint))
		return;
	
	level endon ("Hardpoint Complete " + hardpoint);
	self endon ("death");
	self waittill ("found an enemy for the reinforcements", defenders);
	
	if (defenders.size)
		enemy = defenders[randomint(defenders.size)];
	else
	{
		self.friendlyWaypoint = true;
		// put him on the friendly waypoint
		return;
	}
		
	self.favoriteEnemy = enemy;
	reinforcementAllyMoveToGoal();
}


	/*
	level.smoke_thrown["smoke"+org] = true;
	level notify ("smoke_was_thrown"+org);
	
	oldWeapon = self.grenadeWeapon;

	for (;;)
	{	
		// Give him a smoke grenade
		self.grenadeWeapon = "smoke_grenade_british";
		self.grenadeAmmo++;
		
		// Point him towards the grenade point
		myYawFromTarget = VectorToAngles(org - self.origin );
		self OrientMode( "face angle", myYawFromTarget[1] );
		
		//give him time to get aimed towards it
		wait (0.25);
		
		offset = undefined;
		if (isdefined (self.smoke_grenade_throw))
			offset = self.smoke_grenade_offset;
		if ((self animscripts\combat::TryGrenadePos(org, self.smoke_grenade_throw, offset)))
		{
			// throw was a success, notify the group
			level.smoke_thrown["smoke"+org] = true;
			level notify ("smoke_was_thrown"+org);
			break;
		}
		else
		{
			// Take the grenade back
			self.grenadeAmmo--;
			wait (1);
		}
	}

	// Give him his old grenades back		
	self.grenadeWeapon = oldWeapon;
	*/


// If nobody throws smoke for X seconds, then abort the event
smoke_throw_overRide(org)
{
	wait (25);
	level.smoke_thrown["smoke"+org] = true;
	level notify ("smoke_was_thrown"+org);
}

waitUntilSmokeIsThrown(ent)
{
	org = ent.origin;
	if (!isdefined(level.smoke_thrown["smoke"+org]))
	{
		level.smoke_thrown["smoke"+org] = false;
		level.smoke_thrower["smoke"+org] = undefined;
		level thread smoke_throw_overRide(org);
	}
	else
	{
		// Return if the smoke was already thrown
		if (level.smoke_thrown["smoke"+org])
			return;
	}
//		level endon ("smoke_was_thrown"+org);

	throwSmoke(undefined, org);
}

throwSmoke(node,org)
{
	oldRadius = self.goalradius;
	oldFightdist = self.fightdist;
	oldMaxdist = self.maxdist;
	// Give him his old grenades back		
	oldWeapon = self.grenadeWeapon;
	
	self.smoke_destination_node = node;
	self.smoke_destination_org = org;

	self.exception_exposed = animscripts\combat_utility::smoke_grenade;
	self.exception_corner = animscripts\combat_utility::smoke_grenade;
	self.exception_corner_normal = animscripts\combat_utility::smoke_grenade;
	self.exception_cover_crouch = animscripts\combat_utility::smoke_grenade;
	self.exception_stop = animscripts\combat_utility::smoke_grenade;
	self.exception_stop_immediate = animscripts\combat_utility::smoke_grenade;
	self.exception_move = animscripts\combat_utility::smoke_grenade;
	
	self.exception_exposed = ::tempThink;
	self.exception_corner = ::tempThink;
	self.exception_corner_normal = ::tempThink;
	self.exception_cover_crouch = ::tempThink;
	self.exception_stop = ::tempThink;
	self.exception_stop_immediate = ::tempThink;
	self.exception_move = ::tempThink;
	
	self animcustom(animscripts\combat_utility::smoke_grenade);

	level waittill ("smoke_was_thrown"+org);

	self.smoke_destination_node = undefined;
	self.smoke_destination_org = undefined;


	self.goalradius = oldRadius;
	self.fightdist = oldFightdist;
	self.maxdist = oldMaxdist;
	// Give him his old grenades back		
	self.grenadeWeapon = oldWeapon;

	self.exception_exposed = anim.defaultException;
	self.exception_corner = anim.defaultException;
	self.exception_corner_normal = anim.defaultException;
	self.exception_cover_crouch = anim.defaultException;
	self.exception_stop = anim.defaultException;
	self.exception_stop_immediate = anim.defaultException;
	self.exception_move = anim.defaultException;
}

tempThink()
{
	self endon ("killanimscript");
	for (;;)
		wait (5135);
}

	
checkForSmokeHintProc(node)
{
	if (!isdefined (node.target))
		return;
		
	ent = getent (node.target,"targetname");
	if (!isdefined(ent))
	{
		// No smoke hint
		return;
	}
	
	self maps\_hardpoint::waitUntilSmokeIsThrown(ent);
	
	if (!isdefined (ent.script_delay))
	{
		level notify ("waiting on smoke to fill air");
		return;
	}
		
	// If the smoke was actually thrown
	if (level.smoke_thrown["smoke"+ent.origin])
	{
		level notify ("waiting on smoke to fill air");
		// Give smoke time to fill the area
		self GatherDelay("smoke" + ent.origin, ent.script_delay); 
	}
}

reinforcementAllyMoveToGoal()
{
	suppressionwait = self.suppressionwait;
	target = self.target;
	while (isdefined(target))
	{
		nodeArray = getnodearray (target, "targetname");
		if (!nodeArray.size)
			return;
			
		node = nodeArray[0];
		if (nodeArray.size > 1)
		{
			for (i=0;i<nodeArray.size;i++)
			{
				if (!isdefined (nodeArray[i].reinforceCount))
					nodeArray[i].reinforceCount = 0;
			}
			
			count = nodeArray[0].reinforceCount;
			for (i=0;i<nodeArray.size;i++)
			{
				if (nodeArray[i].reinforceCount >= count)
					continue;
				count = nodeArray[i].reinforceCount;
				node = nodeArray[i];
			}
			node.reinforceCount++;
		}
	
		// Don't get suppressed while you're moving or supporting the mover		
		self.suppressionwait = 0;
		checkForSmokeHintProc(node);
		self setgoalnode (node);
		if (isdefined (node.radius))
			self.goalradius = node.radius;
		target = node.target;
		self waittill ("goal");
		self.suppressionwait = suppressionwait;
		if (isdefined (node.script_delay))
			self GatherDelay("reinforce" + node.origin, node.script_delay);
	}
}

reinforcementAllyHardpointCleared(hardpoint)
{
	self endon ("death");
	flag_wait ("Hardpoint Complete " + hardpoint);
	self.friendlyWaypoint = true;
	// put him on the friendly waypoint
}