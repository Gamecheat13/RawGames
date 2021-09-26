#include maps\_utility;
// .script_health	a group of guys, one of which will drop health
// .script_delete	a group of guys, only one of which spawns
// .script_playerseek	spawn and run to the player
// .script_patroller	follow your targeted patrol
// .script_delayed_playerseek	spawn and run to the player with decreasing goal radius
// .script_followmin
// .script_followmax
// .script_radius
// .script_friendname
// .script_startinghealth
// .script_accuracy
// .script_grenades
// .script_sightrange
// .script_ignoreme

main()
{
	level._health_queue_max = 10;
	level._health_queue_num	= 0;
	level._nextcoverprint = 0;
	level._ai_group = [];
	level.current_spawn_num = 0;
	level.killedaxis = 0;
	level.ffpoints = 0;
	level.missionfailed = false;
	level.gather_delay = [];
	level.smoke_thrown = [];
	level.smoke_thrower = [];
	
	if (!isdefined (level.maxFriendlies))
		level.maxFriendlies = 11;

	mg42s = getentarray ("misc_mg42","classname");
	other_mg42s = getentarray ("misc_turret","classname");
	for (i=0;i<other_mg42s.size;i++)
		mg42s[mg42s.size] = other_mg42s[i];

 	maps\_utility::array_thread(mg42s, ::mg42_think);
//	precacheItem("item_ammo_stielhandgranate_closed");
	precacheModel("xmodel/german_grenade_bag");


	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		if (isdefined (ai[i].script_health))
		{
			array_size = 0;
			if (isdefined (level._ai_health))
			if (isdefined (level._ai_health[ai[i].script_health]))
				array_size = level._ai_health[ai[i].script_health].size;

			level._ai_health[ai[i].script_health][array_size] = ai[i];
			if (ai[i].script_health > level._max_script_health)
				level._max_script_health = ai[i].script_health;

//			println ("ai is member ", array_size," of script_health ",  ai[i].script_health);
		}
		
		if (isdefined (ai[i].script_aigroup))
		{
			aigroup = ai[i].script_aigroup;
			if (!isdefined(level._ai_group[aigroup]))
				aigroup_create(aigroup);
			ai[i] thread aigroup_soldierthink( level._ai_group[aigroup] );
		}
		
		ai[i] thread spawn_think ();
		level thread killfriends_missionfail_think(ai[i]);
	}

	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
		spawners[i] thread spawn_prethink();

	if (isdefined (level._ai_health))
	{
		for (i=0;i<level._max_script_health+1;i++)
		if (isdefined (level._ai_health[i]))
		{
			rnum = randomint (level._ai_health[i].size);
			level._ai_health[i][rnum].drophealth = true;
		}

		for (i=0;i<ai.size;i++)
		if (isdefined (ai[i].drophealth))
			ai[i] thread drophealth();
	}
}

mg42_think ()
{
	if (!isdefined (self.flagged_for_use))
		self.flagged_for_use = false;

	if (!isdefined (self.targetname))
		return;

	node = getnode (self.targetname,"target");
	if (!isdefined (node))
		return;

	if (!isdefined (node.script_mg42))
		return;

	if (!isdefined (node.mg42_enabled))
		node.mg42_enabled = true;

	self.script_mg42 = node.script_mg42;

	first_run = true;
	while (1)
	{
		if (first_run)
		{
			first_run = false;

			if ((isdefined (node.targetname)) || (self.flagged_for_use))
				self waittill ("get new user");
		}

		if (!node.mg42_enabled)
		{
			node waittill ("enable mg42");
			node.mg42_enabled = true;
		}

		excluders = [];
		ai = getaiarray();
		for (i=0;i<ai.size;i++)
		{
			excluded = true;
			if ((isdefined (ai[i].script_mg42)) && (ai[i].script_mg42 == self.script_mg42))
				excluded = false;

			if (isdefined (ai[i].used_an_mg42))
				excluded = true;
				
			if (excluded)
				excluders[excluders.size] = ai[i];
		}

		if (excluders.size)
			ai = maps\_utility::getClosestAIExclude (node.origin, undefined, excluders);
		else
			ai = maps\_utility::getClosestAI (node.origin, undefined);
		excluders = undefined;

		if (isdefined (ai))
		{
			ai notify ("stop_going_to_node");
			ai thread go_to_node (node);
			ai waittill ("death");
		}
		else
			self waittill ("get new user");
	}
}

flankBehavior (num, targetname)
{
	if (!isdefined (level.flankExists))
		level.flankExists[num] = true;
	else
	if (isdefined (level.flankExists[num]))
		return;
	else
		level.flankExists[num] = true;

	flankersHaveTarget = 0;
	flankerSpawner = [];
	// Get all the current spawners with this script_flanker
	spawner = getspawnerarray ();
	for (i=0;i<spawner.size;i++)
	{
		if (!isdefined (spawner[i].script_flanker))
			continue;
		if (spawner[i].script_flanker != num)
			continue;

		if (flankersHaveTarget == 0)
		{
			if (isdefined (spawner[i].target))		
				flankersHaveTarget = 1;
			else
				flankersHaveTarget = -1;
		}
		else
		{
			if (flankersHaveTarget == 1)
				assertEx(isdefined(spawner[i].target), "Flanker " + spawner[i].origin + " has no target but his buddies do");
			else
				assertEx(!isdefined(spawner[i].target), "Flanker " + spawner[i].origin + " has target but his buddies dont");
		}
		flankerSpawner[flankerSpawner.size] = spawner[i];
	}
	spawner = undefined;

	if (!flankerSpawner.size)
	{
		// The flankers have been deleted
		println ("^4 Not doing flanker spawning, the flankers at flank ", num, " have been deleted");
		return;
	}

	if (flankersHaveTarget)
	{
		flankersSeekTarget(flankerSpawner);
		return;
	}
	
	for (i=0;i<flankerSpawner.size;i++)
	{
		flankerSpawner[i].realCount = flankerSpawner[i].count;
		flankerSpawner[i].count = 0;
		flankerSpawner[i].triggerUnlocked = true;
	}
	
	// Get the nodes that the flankers will move to before flanking, so they can run out the backdoor and whatnot.
	moveNodes = [];
	nodes = getallnodes();
	for (i=0;i<nodes.size;i++)
	{
		if (!isdefined (nodes[i].script_flanker))
			continue;
			
		if (nodes[i].script_flanker != num)
			continue;
			
		moveNodes[moveNodes.size] = nodes[i];
	}
	nodes = undefined;
	

	shareTarget = flankerSpawner[0].script_shareTarget;

	if ((!isdefined (level.flankTimer)) || (!isdefined (level.flankTimer[num])))
		level.flankTimer[num] = 24;


	ent = getent(targetname,"target");
	ent waittill ("trigger");

	for (;;)
	{
		level thread flankBehaviorExecution(num, shareTarget, moveNodes, flankerSpawner);
		level waittill ("stop_flanker_behavior" + num);
		ent waittill ("trigger");
	}
}

flankerSpawnerWaitsForSpawn(ent)
{
	self waittill ("spawned", spawn);
	if (!spawn_failed(spawn))
		spawn thread flankerTargetThink(ent);
}	

flankersSeekTarget (flankerSpawner)
{
	ent = spawnstruct();
 	array_thread(flankerSpawner, ::flankerSpawnerWaitsForSpawn, ent);
	ent waittill ("reached_final_destination", friendCenter);
	end = friendCenter;
	start = level.player.origin;
	
	difference = vectorToAngles((end[0],end[1],end[2]) - (start[0],start[1],start[2]));
	angles = (0, difference[1], 0);
    forward = anglesToForward(angles);

	vecdif = 1;	
	desiredRange = 0;
	node = undefined;
	lastflank = undefined;

	flankNodes = getnodearray ("displacement","targetname");
	assert (flankNodes.size);
	
	for (i=0;i<flankNodes.size;i++)
	{
		end = flankNodes[i].origin;

		if (distance (friendCenter, end) < 750)
			continue;
		if (distance (friendCenter, end) > 3000)
			continue;
		if (distance (start, end) > 3000)
			continue;

		difference = vectornormalize(end - start);
		newvecdif = vectordot(forward, difference);
		
		newvecdifAbs = abs(newvecdif - desiredRange);

/#
//			if (getdebugcvar ("anim_debug") != "")
//				level thread debugPrint("fov: " + newvecdif + ", abs: " + newvecdifAbs + ", dist: " + distance (start, end), end, 15, start);
#/

		if (newvecdifAbs >= vecdif)
			continue;
			
		node = flankNodes[i];
		vecdif = newvecdifAbs;
	}

	if (!isdefined (node))
		return;
		
	ent notify ("new_prime_directive", node);
}

flankerTargetThink (ent)
{
	ent endon ("new_prime_directive");
	self thread flankerTargetAwaitPrimeDirective(ent);
	self endon ("death");
	firstNode = getnode (self.target,"targetname");
	volume = undefined;
	if (!isdefined (firstNode))
	{
		volume = getent (self.target,"targetname");
		if (volume.classname != "info_volume")
			return;
			
		assertEx (volume.classname == "info_volume", "Flanker at origin " + self.origin + " targets something that is not a node or a volume");
		assertEx (isdefined (volume.target), "Goal volume at " + volume getorigin() + " doesn't target a node");
		firstNode = getnode(volume.target, "targetname");
		assertEx (isdefined (firstNode), "Goal volume at origin " + volume getorigin() + " doesn't target a node");
		self setgoalvolume(volume);
	}

	for (;;)
	{
		self setgoalnode (firstNode);
		if (isdefined (firstNode.radius))
			self.goalradius = firstNode.radius;
		self waittill ("goal");
		
		if (isdefined (firstNode.script_delay))
			level GatherDelay("flank" + firstNode.origin + self.script_flanker, firstNode.script_delay);
			
		if (isdefined (firstNode.target))
			firstNode = getnode (firstNode.target,"targetname");
		else
			break;
	}
	
	ent notify ("reached_final_destination", self.origin);
}	

flankerTargetAwaitPrimeDirective(ent)
{
	self endon ("death");
	ent waittill ("new_prime_directive", node);
	self setgoalnode (node);
	if (node.radius != 0)
		self.goalradius = node.radius;
	self waittill ("goal");
	level GatherDelay("flank_prepare" + node.origin + self.script_flanker, 8);
	
	self setgoalentity (level.player);
}

flankBehaviorExecution(num, shareTarget, moveNodes, flankerSpawner)
{
	success = true;
	level endon ("stop_flanker_behavior" + num);
	for (;;)
	{		
		if (success)
		{
			wait (level.flankTimer[num]);
			success = false;
		}
		else
			wait (8);
		
		friendCenter = (0,0,0);
		friendSpawners = 0;
		playerEnemy = false;
		// Get all the defender spawners so we have a point to dot product off of
		spawner = getspawnerarray ();
		for (i=0;i<spawner.size;i++)
		{
			if (!isdefined (spawner[i].script_shareTarget))
				continue;
			if (spawner[i].script_shareTarget != shareTarget)
				continue;
			
			friendCenter = (friendCenter[0] + spawner[i].origin[0], friendCenter[1] + spawner[i].origin[1], friendCenter[2] + spawner[i].origin[2]);
			friendSpawners++;
		}
		spawner = undefined;
	
		// no defenders
		if (!friendSpawners)
		{
			friendCenter = level.player.origin;
			friendSpawners = 1;
		}

		friendCenter = (friendCenter[0] / friendSpawners, friendCenter[1] / friendSpawners, friendCenter[2] / friendSpawners);
		enemyCenter = (0,0,0);
		enemies = 0;	

		if (distance(friendCenter, level.player.origin) < 2000)
			playerEnemy = true;
		else
		{			
			// Get all the current defenders so we can figure out where their enemy is
			ai = getaiarray ();
			for (i=0;i<ai.size;i++)
			{
				if (!isdefined (ai[i].script_shareTarget))
					continue;
				if (ai[i].script_shareTarget != shareTarget)
					continue;
				if (!isalive (ai[i].enemy))
					continue;
				
				enemies++;
	
				if (ai[i].enemy == level.player)
				{
					playerEnemy = true;
					break;
				}
				
				enemyCenter = (enemyCenter[0] + ai[i].enemy.origin[0], enemyCenter[1] + ai[i].enemy.origin[1], enemyCenter[2] + ai[i].enemy.origin[2]);
			}
			ai = undefined;
		}
		
		if (playerEnemy)
			enemyCenter = level.player.origin;
		else
		{
			// no enemies
			if (!enemies)
				continue;
			enemyCenter = (enemyCenter[0] / enemies, enemyCenter[1] / enemies, enemyCenter[2] / enemies);
		}
		
		start = enemyCenter;
		end = friendCenter;
		difference = vectorToAngles((end[0],end[1],end[2]) - (start[0],start[1],start[2]));
		angles = (0, difference[1], 0);
	    forward = anglesToForward(angles);
	
		vecdif = 1;	
		desiredRange = 0;
		node = undefined;
		lastflank = undefined;
		
		flankNodes = getnodearray ("displacement","targetname");
		assert (flankNodes.size);
		for (i=0;i<flankNodes.size;i++)
		{
			end = flankNodes[i].origin;

			if (distance (friendCenter, end) < 750)
				continue;
			if (distance (friendCenter, end) > 3000)
				continue;
			if (distance (start, end) > 3000)
				continue;

			difference = vectornormalize(end - start);
			newvecdif = vectordot(forward, difference);
			
			newvecdifAbs = abs(newvecdif - desiredRange);

/#
//			if (getdebugcvar ("anim_debug") != "")
//				level thread debugPrint("fov: " + newvecdif + ", abs: " + newvecdifAbs + ", dist: " + distance (start, end), end, 15, start);
#/

			if (isdefined (lastflank))
			{
				if (lastflank == flankNodes[i])
					continue;
			}

			if (newvecdifAbs >= vecdif)
				continue;
				
			node = flankNodes[i];
			vecdif = newvecdifAbs;
		}

		if (!isdefined (node))
			continue;

		vecdif = 0;
		
		moveNode = undefined;
		start = friendCenter;
		for (i=0;i<moveNodes.size;i++)
		{
			end = moveNodes[i].origin;

			difference = vectornormalize(end - start);
			newvecdif = vectordot(forward, difference);

/#
//			if (getdebugcvar ("anim_debug") != "")
//				level thread debugPrint("move: " + newvecdif, end, 15);
#/

			if (newvecdif <= vecdif)
				continue;
				
			moveNode = moveNodes[i];
			vecdif = newvecdif;
		}

		lastFlank = node;
		success = true;
		
		for (i=0;i<flankerSpawner.size;i++)
		{
			if (!isdefined (flankerSpawner[i]))
				continue;
			
			if (flankerSpawner[i].realCount <= 0)
				continue;
				
			flankerSpawner[i].realCount--;
			flankerSpawner[i].count = 1;
			spawn = flankerSpawner[i] dospawn();
			if (maps\_utility::spawn_failed(spawn))
			{
				flankerSpawner[i].count = 0;
				continue;
			}

			spawn thread flankThink(node, moveNode);
		}
	}
}


flankThink(node, moveNode)
{
	self endon ("death");
	
	// If the flanker targets a node, make him go to that node before flanking.
	// This is so the level designer can make a flanker do a certain thing based on the plyayer's known approach, then the
	// AI flanks afterwards.
	assert (!isdefined (self.target));
	if (isdefined (moveNode))
	{
		self setgoalnode (node);
		self.goalradius = 32;
		self waittill ("goal");
	}
	
	self.fightdist = 300;
	self setgoalnode (node);
	if (node.radius != 0)
		self.goalradius = node.radius;
	
	for (;;)
	{
		wait (8);
		self.goalradius = 750;
		self.maxdist -= 200;
		if (self.maxdist < 380)
			self.maxdist = 380;

		if (!isalive (self.enemy))
		{
			self setgoalentity (level.player);
			continue;
		}

		if (self.enemy == level.player)		
			self setgoalentity (self.enemy);
		else
			thread goalthread();
	}
}

goalthread ()
{
	self notify ("new goal");
	self endon ("new goal");
	self endon ("death");
	self.enemy endon ("death");

	for (;;)
	{
		self setgoalpos (self.enemy.origin);
		wait (5);
	}
}

/*
debugPrint (msg, origin, time, start)
{
	level notify ("stop debug at this origin " + origin);
	level endon ("stop debug at this origin " + origin);
//	for (i=0;i<time*20;i++)
	for (;;)
	if (isdefined (start))
	{
		line (start + (0,0, 50), origin + (0, 0, 50), (0.2, 0.5, 0.8), 0.5);
		print3d ((origin + (0, 0, 50)), msg, (0.28, 1.0, 0.95), 0.85);
		wait (0.05);
	}
	else
	for (;;)
	{
		print3d ((origin + (0, 0, 50)), msg, (0.28, 1.0, 0.95), 0.85);
		wait (0.05);
	}
}
*/


escapeBehavior (num)
{
	if (!isdefined (level.escapeExists))
		level.escapeExists[num] = true;
	else
	if (isdefined (level.escapeExists[num]))
		return;
	else
		level.escapeExists[num] = true;

	windowBlockers = getentarray ("escape blocker","targetname");
	for (i=0;i<windowBlockers.size;i++)
	{
		if (windowBlockers[i].script_escape == num)
			windowBlockers[i] disconnectPaths();
	}
	windowBlockers = undefined;
	

	fleeNodes = [];
	nodes = getallnodes();
	for (i=0;i<nodes.size;i++)
	{
		if (!isdefined (nodes[i].script_escape))
			continue;
		if (nodes[i].script_escape != num)
			continue;

		fleeNodes[fleeNodes.size] = nodes[i];
	}
	nodes = undefined;	
	
	// No nodes to flee to
	if (!fleeNodes.size)
		return;
	
	ent = spawnstruct();
	ent endon ("escape sequence terminated");

	ent.escape = false;
	level.escape[num] = true;
	
	escaper = [];
	escapeSpawner = [];
	escapeTally = 0;

	
	// Get all the current escapers with this script_escape
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		if (!isdefined (ai[i].script_escape))
			continue;
		if (ai[i].script_escape != num)
			continue;
		
		escaper[escaper.size] = ai[i];
	}
	ai = undefined;
	
	ent.liveEnemies = 0;
	for (i=0;i<escaper.size;i++)
		level thread escape_escaperThink (escaper[i], ent);
	
	// Get all the current spawners with this script_escape
	spawner = getspawnerarray ();
	for (i=0;i<spawner.size;i++)
	{
		if (!isdefined (spawner[i].script_escape))
			continue;
		if (spawner[i].script_escape != num)
			continue;
		
		escapeSpawner[escapeSpawner.size] = spawner[i];
	}
	spawner = undefined;

	escapeTally = ent.liveEnemies;
	for (i=0;i<escapeSpawner.size;i++)
	{
		// Use the "realcount" if it exists, that means its a floodspawner that could've been turned off
		if (isdefined (escapeSpawner[i].realCount))
			escapeTally += escapeSpawner[i].realCount;
		else
			escapeTally += escapeSpawner[i].count;
	}
	
	escapeMin = escapeTally * 0.4; // Run when we're down to this few escapers
	if ((isdefined (level.escapeOverride)) && (isdefined (level.escapeOverride[num])))
	{
		assertEx (level.escapeOverride[num] < escapeTally, "^2Script_escape group " + num + " was told to flee when the group strength drops below " + level.escapeOverride[num] + ", which is equal or greater than the total group members (" + escapeTally + ")");
		escapeMin = level.escapeOverride[num];
	}
	
	for (i=0;i<escapeSpawner.size;i++)
		level thread escape_escapeSpawnerThink (escapeSpawner[i], ent);
	
	fallbackEnemyCenter = undefined;
	// Wait until enough ai have died to start the fleeing sequence
	for (;;)
	{
		ent waittill ("escaper died", fallback);
		if (isdefined (fallback))
			fallbackEnemyCenter = fallback.origin;
	
		countTotal = 0;
		escapeSpawner = [];
		// Evaluate the spawner counts
		spawner = getspawnerarray ();
		for (i=0;i<spawner.size;i++)
		{
			if (!isdefined (spawner[i].script_escape))
				continue;
			if (spawner[i].script_escape != num)
				continue;
			
			escapeSpawner[escapeSpawner.size] = spawner[i];
			countTotal += spawner[i].count;
		}
		spawner = undefined;
		
		if (ent.liveEnemies + countTotal <= escapeMin)
			break;
	}

	escaper = [];
	// Get all the current escapers so we can figure out where their enemy is
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		if (!isdefined (ai[i].script_escape))
			continue;
		if (ai[i].script_escape != num)
			continue;
		
		escaper[escaper.size] = ai[i];
	}
	ai = undefined;

	// no escapers or spawners
	if ((!escaper.size) && (!escapeSpawner.size))
		return;

	playerEnemy = false;
	enemyCenter = (0,0,0);
	enemies = 0;	
	friendCenter = (0,0,0);
	for (i=0;i<escaper.size;i++)
		friendCenter = (friendCenter[0] + escaper[i].origin[0], friendCenter[1] + escaper[i].origin[1], friendCenter[2] + escaper[i].origin[2]);

	for (i=0;i<escapeSpawner.size;i++)
		friendCenter = (friendCenter[0] + escapeSpawner[i].origin[0], friendCenter[1] + escapeSpawner[i].origin[1], friendCenter[2] + escapeSpawner[i].origin[2]);

	friendCenter = (friendCenter[0] / (escaper.size + escapeSpawner.size), friendCenter[1] / (escaper.size + escapeSpawner.size), friendCenter[2] / (escaper.size + escapeSpawner.size));

	if (distance (friendCenter, level.player.origin) < 2000)
		playerEnemy = true;
	else
	{
		for (i=0;i<escaper.size;i++)
		{
			if (!isalive (escaper[i].enemy))
				continue;
	
			enemies++;
	
			if (escaper[i].enemy == level.player)
			{
				playerEnemy = true;
				break;
			}
			
			enemyCenter = (enemyCenter[0] + escaper[i].enemy.origin[0], enemyCenter[1] + escaper[i].enemy.origin[1], enemyCenter[2] + escaper[i].enemy.origin[2]);
		}
	
		// no enemies to flee from	
		if (!enemies)
		{
			if (!isdefined (fallbackEnemyCenter))
				return;
	
			enemyCenter = fallbackEnemyCenter;
		}
	}

	if (playerEnemy)
		enemyCenter = level.player.origin;
	else
		enemyCenter = (enemyCenter[0] / enemies, enemyCenter[1] / enemies, enemyCenter[2] / enemies);

	start = enemyCenter;
	end = friendCenter;
	difference = vectorToAngles((end[0],end[1],end[2]) - (start[0],start[1],start[2]));
	angles = (0, difference[1], 0);
    forward = anglesToForward(angles);

	vecdif = 0;	
	for (i=0;i<fleeNodes.size;i++)
	{
//		if (distance (start, end) > 1300)
//			continue;
		end = fleeNodes[i].origin;
		
		difference = vectornormalize(end - start);
		newvecdif = vectordot(forward, difference);
		if (newvecdif <= vecdif)
			continue;
			
		ent.goal = fleeNodes[i];
		vecdif = newvecdif;
	}

	if (isdefined (ent.goal))
	{
		// Make the spawners stop spawning additional AI.
		for (i=0;i<escapeSpawner.size;i++)
			escapeSpawner[i].count = 0;

		ent.escape = true;
		ent notify ("escape stop notify");
		windowBlockers = getentarray ("escape blocker","targetname");
		
		start = friendCenter;		

		for (i=0;i<windowBlockers.size;i++)
		{
			if (windowBlockers[i].script_escape != num)
				continue;

			end = windowBlockers[i] getorigin();
			difference = vectornormalize(end - start);
/#
//			if (getdebugcvar ("anim_debug") != "")
//				level thread debugPrint("Window Cleared: " + vectordot(forward, difference), end, 25, start);
#/

			if (vectordot(forward, difference) < 0.70)
				continue;
				
			windowBlockers[i] connectPaths();
			windowBlockers[i] delete();
		}
	}
}

escapeSpawnerTermination (spawner, ent)
{
	spawner endon ("death");
	ent endon ("escape sequence terminated");
	ent waittill ("escape stop notify");

	killspawner = spawner.script_killspawner;
	if (!isdefined (killspawner))
		return;
		
	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	{
		if ((isdefined (spawners[i].script_killspawner)) && (killspawner == spawners[i].script_killspawner))
			spawners[i] delete();
	}
}

escapeTermination (ai, ent)
{
	ai endon ("death");
	ai waittill ("escape sequence terminated");
	ent notify ("escape sequence terminated");
	level.escapeExists[ai.script_escape] = undefined;
}

// After the AI count has dropped low enough, AI run this logic
escape_escaperFlees (ai, ent)
{
	ent endon ("escape sequence terminated");
	level thread escapeTermination(ai, ent);

	ai endon ("death");
	ent waittill ("escape stop notify");
	escape_escaperFleesGoal (ai, ent);
}

escape_escaperFleesGoal (ai, ent)
{
	ent endon ("escape sequence terminated");
	ai.escapingHardpoint = true;
	ai notify ("escape your doom");

	ai setgoalnode (ent.goal);
	if (isdefined (ent.goal.radius))
		ai.goalradius = ent.goal.radius;

//	ai animscripts\combat::interruptpoint();
}

// AI report back when they died, so the script knows when to make them flee
escape_escaperThink ( ai, ent )
{
	ent endon ("escape sequence terminated");
	level thread escape_escaperFlees (ai, ent);
	ent endon ("escape stop notify");
	ent.liveEnemies++;
	ai waittill ("death");
	ent.liveEnemies--;
	ent notify ("escaper died", ent.enemy);
}

// Spawners report back when the ai dies so the script knows when to make them flee,
// and if its time to flee then they run the other logic
escape_escapeSpawnerThink ( spawner, ent )
{
	ent endon ("escape sequence terminated");
	level thread escapeTermination(spawner, ent);
	level thread escapeSpawnerTermination(spawner, ent);

	spawner endon ("death");
	lastCount = spawner.count;
	for (;;)
	{
		spawner waittill ("spawned", spawn);
		if (maps\_utility::spawn_failed(spawn))
		{
			ent notify ("escaper died");
			continue;
		}
		
		if (ent.escape)
		{
			level thread escape_escaperFleesGoal (spawn, ent);
			continue;
		}
			
		level thread escape_escaperFlees (spawn, ent);
		ent.liveEnemies++;
		spawn waittill ("death");
		ent.liveEnemies--;
		ent notify ("escaper died", ent.enemy);
	}
}

grenade_trigger (trigger)	// fix fix
{
	targets =  getentarray (trigger.target, "targetname");
	spawners = [];
	touchTriggers = [];
	for (i=0;i<targets.size;i++)
	{
		if (targets[i].classname == "trigger_multiple")
			touchTriggers[touchTriggers.size] = targets[i];
		else
			spawners[spawners.size] = targets[i];
	}
	
	if (isdefined (trigger.script_delay))
		delay = trigger.script_delay;
	else
		delay = 3.5;
		
	println ("^3 Touchers ", touchTriggers.size);

 	maps\_utility::array_thread(spawners, ::grenade_think, delay);
 	maps\_utility::array_thread(touchTriggers, ::grenade_trigger_think, delay);

	if (isdefined (trigger.count))
		count = trigger.count;
	else
		count = 2;
		
	println ("^3 Count is ", count);

	while (count > 0)
	{
		println ("^3 waiting for trigger..");
		trigger waittill ("trigger");
		println ("^3 ..triggered!");
		while (level.player istouching (trigger))
		{
			spawners = getentarray (trigger.target, "targetname");
			maps\_utility::array_notify(spawners, "throw");
		 	maps\_utility::array_notify(touchTriggers, "throw");
		 	println ("^3 Throw!");
			wait (2 + randomfloat (7));
			count--;
			if (count <= 0)
				break;
		}
	}

//	trigger delete();
}

grenade_trigger_once (trigger)
{
	spawners = getentarray (trigger.target, "targetname");
	if (isdefined (trigger.script_delay))
		delay = trigger.script_delay;
	else
		delay = 2;

	maps\_utility::array_thread(spawners, ::grenade_think, delay);

	trigger waittill ("trigger");
	kill_trigger (trigger);
}

grenade_trigger_think (delay)
{
	self endon ("death");
	grenade = getentarray (self.target, "targetname");
	
	while (1)
	{
		thrower = undefined;
		ai = getaiarray ("axis");
		for (i=0;i<ai.size;i++)
		{
			if (!(self istouching (ai[i])))
				continue;
			thrower = ai[i];
			break;
		}
		println ("^3thrower is ", thrower);
		
		if (isalive (thrower))
		{
			org = grenade[randomint (grenade.size)];
			dests = getentarray (org.target, "targetname");
			dest = dests[randomint (dests.size)];
			velocity = vectorNormalize (dest.origin - org.origin);
			velocity = maps\_utility::vectorScale (velocity, distance (org.origin, dest.origin)*2);
			thrower MagicGrenadeManual (org.origin, velocity, delay);
			wait (1);
		}
		self waittill ("throw");
		println ("^2THROW");
	}
}

grenade_think (delay)
{
	self waittill ("spawned", ent);
	ent endon("death");
	ent thread go_to_node ();
	ent.favoriteenemy = level.player;

	grenade = getentarray (ent.target, "targetname");
//	org = getent (ent.target, "targetname");
	while (1)
	{
		org = grenade[randomint (grenade.size)];
//		println ("^c target was ", org.target);
		dests = getentarray (org.target, "targetname");
		dest = dests[randomint (dests.size)];
		velocity = vectorNormalize (dest.origin - org.origin);
		velocity = maps\_utility::vectorScale (velocity, distance (org.origin, dest.origin)*2);
		ent MagicGrenadeManual (org.origin, velocity, delay);
		wait (1);
		self waittill ("throw");
	}
}

flood_trigger(trigger)
{
	prof_begin("flood_trigger");

	spawners = getentarray (trigger.target,"targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i].realcount = spawners[i].count;
	array_thread(spawners, ::flood_prethink);
	
	possibleAntitriggers = getentarray (trigger.target, "script_noteworthy");
	antiTriggers = [];
	for (i=0;i<possibleAntitriggers.size;i++)
	{
		if (!isdefined (possibleAntitriggers[i].targetname))
			continue;
			
		if (possibleAntitriggers[i].targetname != "antispawn")
			continue;
			
		antiTriggers[antiTriggers.size] = possibleAntitriggers[i];	
	}


	flankerNumbers = [];
//	flankerTargetnames = [];
	for (i=0;i<spawners.size;i++)
	{
		spawner = spawners[i];
		if (!isdefined(spawner.script_flanker))
			continue;
		numInUse = false;
		for (p=0;p<flankerNumbers.size;p++)
		{
			if (flankerNumbers[p] != spawner.script_flanker)
				continue;
			numInUse = true;
			break;
		}
		if (numInUse)
			continue;
		flankerNumbers[flankerNumbers.size] = spawner.script_flanker;
//		flankerTargetnames[flankerTargetnames.size] = spawner.targetname;
	}

//	for (i=0;i<antiTriggers.size;i++)
//		level thread flood_antithink(antiTriggers[i], trigger, flankerNumbers, flankerTargetnames);
		// auto 468
	array_levelthread(antiTriggers, ::flood_antithink, trigger);
	antispawned = false;
	target = trigger.target;
	for (;;)
	{
		prof_begin("flood_trigger");

		trigger waittill ("trigger");
		array_thread(getentarray (target,"targetname"), ::flood_think, trigger);

		// Done with this floodspawner if there are no antitriggers
		if (!antiTriggers.size)
			break;
			
		trigger triggerOff();
		trigger waittill ("antispawn");
		for (i=0;i<flankerNumbers.size;i++)
		{
			num = flankerNumbers[i];
			level notify ("stop_flanker_behavior" + num);
		}
		antispawned = true;
		trigger triggerOn();
	}
	if ((isdefined (trigger)) && (!isdefined (trigger.script_requires_player)))
		kill_trigger (trigger);
		
	prof_end("flood_trigger");
}

flood_antithink (antitrigger, trigger)
{
	for (;;)
	{
		antitrigger waittill ("trigger");
		trigger notify ("antispawn");
	}
}


spawnerflood_spawn (spawners)
{
	if ((!isdefined (spawners)) || (!spawners.size))
	{
		println ("Tried to flood spawn without passing any spawners");
		return;
	}

	maps\_utility::array_thread(spawners, ::flood_prethink);
	maps\_utility::array_thread(spawners, ::flood_think);
}

flood_prethink()
{
//	self.oldTargetname = self.targetname;
	self.triggerUnlocked = true;
//	self.targetname = ("null " + self.origin);
	self.start = true;
	self thread start_tracker();
}

flood_think(trigger)
{
//	if (isdefined (self.started_flood_spawner))
//		return;
	
	// Flankers dont floodspawn unless they're solo guided flankers
	if ((isdefined (self.script_flanker)) && (!isdefined (self.target)))
		return;
	antiTriggers = false;
	if (isdefined (trigger))
	{
		possibleAntitriggers = getentarray (trigger.target, "script_noteworthy");
		for (i=0;i<possibleAntitriggers.size;i++)
		{
			if (!isdefined (possibleAntitriggers[i].targetname))
				continue;
				
			if (possibleAntitriggers[i].targetname != "antispawn")
				continue;
				
			antiTriggers = true;
			break;
		}
		trigger endon ("antispawn");
	}
	
	self endon("death");
	self notify ("stop current floodspawner");
	self endon ("stop current floodspawner");

//	self.started_flood_spawner = true;

/#
	if ((isdefined (self.spawnflags)) && (!(self.spawnflags & 1)))
		maps\_utility::error ("Spawner at origin " + self.origin + "/" + (self getorigin()) + " is not a spawner");
#/

	count = 0;
	countrate = 1;
	if (isdefined (self.script_additive_delay))
		countrate = self.script_additive_delay;

	if ((isdefined (trigger)) && (isdefined (trigger.script_requires_player)))
		requires_player = true;
	else
		requires_player = false;
	
	if (antiTriggers)
		level thread antispawnerThink(self, trigger);

	maxSpawnCount = undefined;
	
	if (!isdefined(level.floodspawnMaxSpawn))
		level.floodspawnMaxSpawn = [];
	if ( (isdefined(trigger)) && (isdefined(trigger.script_maxspawn)) )
	{
		maxSpawnCount = trigger.script_maxspawn;
		level.floodspawnMaxSpawn[trigger.target] = 0;
	}
	
	// if the trigger has been turned back on then it resets to its original count
	if (isdefined (self.realcount))
		self.count = self.realcount;
	else
		self.realcount = self.count;
	
	while (self.count > 0)
	{
		while (1)
		{
			if (!self.start)
			{
				self waittill ("enable");
				self.start = true;
			}

			while ((requires_player) && (!(level.player istouching (trigger))))
				wait (0.5);

			if (self.start)
				break;
		}
		

		if (isdefined (self.script_prespawn_delay))
			wait (self.script_prespawn_delay);

		//control max number of spawns
		if ( (isdefined(maxSpawnCount)) && (level.floodspawnMaxSpawn[self.targetname] >= maxSpawnCount) )
		{
			wait (2);
			continue;
		}
		
		if (isdefined(self.script_forcespawn))
			ent = self stalingradspawn();
		else
			ent = self dospawn();
		if (spawn_failed(ent))
		{
			wait (2);
			continue;
		}
		if (isdefined(level.floodspawnMaxSpawn[self.targetname]))
			level.floodspawnMaxSpawn[self.targetname]++;
		
		if (antiTriggers)
			level thread antispawnThink(ent, trigger);
			
		ent thread countBoost(self);
			
		ent waittill ("death");
		if (isdefined(level.floodspawnMaxSpawn[self.targetname]))
			level.floodspawnMaxSpawn[self.targetname]--;
		
		// guy was force spawn deleted
		if (!isdefined (ent))
			continue;
/*			
		if (isdefined(ent))
			debug_message ("DIED", ent.origin);
		else
			debug_message ("DELETED");
*/
		if (!isdefined(self))
			return;

		if (isdefined (self.script_delay))
			wait (self.script_delay);
		else
		if ((isdefined (self.script_delay_min)) && (isdefined (self.script_delay_max)))
			wait (self.script_delay_min + randomfloat (self.script_delay_max - self.script_delay_min));
		else
			wait (5 + randomfloat (4));

		wait (count);
		count += countrate;
	}
}

countBoost (spawner)
{
	// If the spawned guy is deleted by forcespawn, reencrement the spawners count.
	self waittill ("death");
	if ((!isdefined (self)) && (isdefined (spawner)))
		spawner.count++;
}



antispawnThink (guy, trigger)
{
	startOrigin = guy.origin;
	guy endon ("death");
	trigger waittill ("antispawn");
	guy notify ("escape sequence terminated");
	if (distance (startOrigin, guy.origin) < 700)
		guy delete();
}

antispawnerThink (spawner, trigger)
{
	spawner endon ("death");
	for (;;)
	{
		trigger waittill ("antispawn");
		spawner notify ("escape sequence terminated");
	}
}

start_tracker()
{
	while (1)
	{
		self waittill ("disable");
		self.start = false;
		self waittill ("enable");
		self.start = true;
	}
}

increment(trigger)
{
	if (!isdefined(trigger.count))
		trigger.count = 1;

	while (trigger.count > 0)
	{
		trigger waittill ("trigger");

		for (p=0;p<2;p++)
		{
			switch (p)
			{
				case 0:
					aitype = "allies";
					break;

				default:
					assert(p == 1);
					aitype = "axis";
					break;
			}

			ai = getentarray(aitype, "classname");
			for (i=0;i<ai.size;i++)
			{
				if (isdefined (ai[i].script_increment))
				if (ai[i].script_increment == trigger.script_increment)
				{
					ai[i].count++;
				}
			}
		}

		trigger.count--;
		maps\_spawner::waitframe();

		if (isdefined (trigger.delay))
			wait (trigger.delay);
	}

	kill_trigger (trigger);
}

delete_start (startnum)
{
	for (p=0;p<2;p++)
	{
		switch (p)
		{
			case 0:
				aitype = "axis";
				break;

			default:
				assert(p == 1);
				aitype = "allies";
				break;
		}

		ai = getentarray(aitype, "team");
		for (i=0;i<ai.size;i++)
		{
			if (isdefined (ai[i].script_start))
			if (ai[i].script_start == startnum)
				ai[i] thread delete_me();
		}
	}
}

kill_trigger (trigger)
{
	if (!isdefined (trigger))
		return;
		
	if ((isdefined (trigger.targetname)) && (trigger.targetname != "flood_spawner"))
		return;
		
	trigger delete();
}

kill_spawner(trigger)
{
	killspawner = trigger.script_killspawner;

	trigger waittill ("trigger");
	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	if ((isdefined (spawners[i].script_killspawner)) && (killspawner == spawners[i].script_killspawner))
	{
//		level thread debug_message ("DELETED", spawners[i].origin);
		spawners[i] delete();
	}

	kill_trigger (trigger);
}

empty_spawner(trigger)
{
	emptyspawner = trigger.script_emptyspawner;

	trigger waittill ("trigger");
	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	{
		if (!isdefined (spawners[i].script_emptyspawner))
			continue;
		if (emptyspawner != spawners[i].script_emptyspawner)
			continue;

		if (isdefined(spawners[i].script_flanker))
			level notify ("stop_flanker_behavior" + spawners[i].script_flanker);
		spawners[i].count = 0;
		spawners[i] notify ("emptied spawner");
	}
	trigger notify ("deleted spawners");
}

kill_spawnerNum(number)
{
	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	{
		if (!isdefined (spawners[i].script_killspawner))
			continue;

		if (number != spawners[i].script_killspawner)
			continue;

		spawners[i] delete();
	}
}

trigger_spawn(trigger)
{
/*
	if (isdefined(trigger.target))
	{
		spawners = getentarray(trigger.target, "targetname");
		for (i=0;i<spawners.size;i++)
		if ((spawners[i].team == "axis") || (spawners[i].team == "allies"))
			level thread spawn_prethink(spawners[i]);
	}
*/
}

drophealth()
{
	// Disabling health, auto regen player health instead.
	if (1) return;
	// No health on hard.
	if (getcvar ("g_gameskill") == "3")
		return;
	self waittill ("death");
	
	if (!isdefined (self))
		return;

	health = spawn("item_health", self.origin + (0,0,10));
	health.angles = (0, randomint(360), 0);

	if (isdefined (level._health_queue))
	{
		if (isdefined (level._health_queue[level._health_queue_num]))
			level._health_queue[level._health_queue_num] delete();
	}

	level._health_queue[level._health_queue_num] = health;
 	level._health_queue_num++;
 	if (level._health_queue_num > level._health_queue_max)
	 	level._health_queue_num = 0;
}

// spawn maximum 16 grenades per team
spawn_grenade(origin, team)
{
	// delete oldest grenade
	if (!isdefined(level.grenade_cache) || !isdefined(level.grenade_cache[team]))
	{
		level.grenade_cache_index[team] = 0;
		level.grenade_cache[team] = [];
	}

	index = level.grenade_cache_index[team];
	grenade = level.grenade_cache[team][index];
	if (isdefined(grenade))
		grenade delete();

	grenade = spawn("weapon_Stielhandgranate", origin);
	level.grenade_cache[team][index] = grenade;

	level.grenade_cache_index[team] = (index + 1) % 16;

	return grenade;
}

waittillDeathOrPainDeath()
{
	self endon ("death");
	self waittill ("pain_death"); // pain that ends in death
}

drop_gear()
{
	team = self.team;
	waittillDeathOrPainDeath();

	if (!isdefined (self))
		return;

	// Drop the weapon as soon as they're dead.
	self animscripts\shared::DropAIWeapon();
	if (self.grenadeAmmo <= 0)
		return;
	
	level.nextGrenadeDrop--;
	if (level.nextGrenadeDrop > 0)
		return;

	level.nextGrenadeDrop = 2 + randomint(2);
	max = 25;
	min = 12;
	spawn_grenade_bag(self.origin + (randomint(max)-min,randomint(max)-min,2) + (0,0,42), (0, randomint(360), 0), self.team);
}
		
spawn_grenade_bag(org, angles, team)
{
	grenade = spawn_grenade(org, team);
	grenade setmodel ("xmodel/german_grenade_bag");
	grenade.count = 3;
//	wait (0.2);
//	if (isdefined (grenade))
	grenade.angles = angles;
	return grenade;
}

spawner_mg42_notify (num)
{
	mg42s = getentarray ("misc_mg42","classname");
	other_mg42s = getentarray ("misc_turret","classname");
	for (i=0;i<other_mg42s.size;i++)
		mg42s[mg42s.size] = other_mg42s[i];

	mg42 = [];
	for (i=0;i<mg42s.size;i++)
	if ((isdefined(mg42s[i].script_mg42)) && (mg42s[i].script_mg42 == num))
		mg42[mg42.size] = mg42s[i];

	if (!mg42.size)
		return;

	mg42s = undefined;

	while (1)
	{
		self waittill ("spawned");
		for (i=0;i<mg42.size;i++)
		{
			if (mg42[i].flagged_for_use)
				continue;
				
			mg42[i] notify ("get new user");
		}
	}
}


spawn_prethink()
{
	assert (self != level);
	if (getcvar ("noai") != "off")
	{
		// NO AI in the level plz
		self.count = 0;
		return;
	}
	
	prof_begin("spawn_prethink");

	if (isdefined(self.script_escape))
		level thread escapeBehavior(self.script_escape);

	if (isdefined(self.script_flanker))
		level thread flankBehavior(self.script_flanker, self.targetname);
	
	if (isdefined (self.script_health))
	{
		if (self.script_health > level._max_script_health)
			level._max_script_health = self.script_health;

		array_size = 0;
		if (isdefined (level._ai_health))
		if (isdefined (level._ai_health[self.script_health]))
			array_size = level._ai_health[self.script_health].size;

		level._ai_health[self.script_health][array_size] = self;
	}

	if (isdefined (self.script_aigroup))
	{
		aigroup = self.script_aigroup;
		if (!isdefined(level._ai_group[aigroup]))
			aigroup_create(aigroup);			
		self thread aigroup_spawnerthink( level._ai_group[aigroup] );
	}

	if (isdefined (self.script_mg42))
		self thread spawner_mg42_notify (self.script_mg42);

	if (isdefined (self.script_delete))
	{
		array_size = 0;
		if (isdefined (level._ai_delete))
		if (isdefined (level._ai_delete[self.script_delete]))
			array_size = level._ai_delete[self.script_delete].size;

		level._ai_delete[self.script_delete][array_size] = self;
	}
	
	// portable mg42 guys
	if (issubstr(self.classname, "mg42portable") || issubstr(self.classname, "30cal"))
		thread mg42setup_gun();
		
	while (1)
	{
		prof_begin("spawn_prethink");

		self waittill ("spawned", spawned);
		
		if (isdefined(level.spawnerCallbackThread))
			self thread [[level.spawnerCallbackThread]](spawned);
		
		if ((!isSentient (spawned)) || (!isalive (spawned)))
		{
			prof_end("spawn_prethink");
			continue;
		}
		
		level thread killfriends_missionfail_think(spawned);
		
//		level thread debug_message ("SPAWNED", spawned.origin);

		if (isdefined(self.script_delete))
		{
			for (i=0;i<level._ai_delete[self.script_delete].size;i++)
			{
				if (level._ai_delete[self.script_delete][i] != self)
					level._ai_delete[self.script_delete][i] delete();
			}
		}

		if (isdefined (self.targetname))
			spawned thread spawn_think (self.targetname);
		else
			spawned thread spawn_think ();
	}
}

// Wrapper for spawn_think
spawn_think (targetname)
{
	assert (self != level);
	spawn_think_action (targetname);
	assert (isalive(self));
	self.finished_spawning = true;
	self notify ("finished spawning");
	assert (isdefined(self.team));
	if (self.team == "allies" && !isdefined (self.script_nofriendlywave))
		self thread friendlydeath_thread();
}

// Actually do the spawn_think
spawn_think_action (targetname)
{
	self thread tanksquish();
//	maps\_spawner::waitframe(); // silly way to let the drop health get insured if a spawner is placed to go off at start

	/#
	if (getdebugcvar("debug_misstime") == "start")
		self thread maps\_load::debugMisstime();
	#/


	if ((isdefined (self.script_moveoverride)) && (self.script_moveoverride == 1))
		override = true;
	else
		override = false;

	
	if ( self.team == "allies" )
	{
		self.pathEnemyLookAhead = 350;
		self.pathEnemyFightDist = 350;
	}
	if ( self.team == "axis" )
	{
		self.pathEnemyLookAhead = 350;
		self.pathEnemyFightDist = 350;
	}
	

	portableMG42guy = issubstr(self.classname, "mg42portable") || issubstr(self.classname, "30cal");
	
	if (isdefined (targetname))
	{
//		println ("$$Targetname size is " + targetname.size + " and targetname is ", targetname);
		if ((targetname.size > 4) &&
			(targetname[0] == "a") &&
			(targetname[1] == "u") &&
			(targetname[2] == "t") &&
			(targetname[3] == "o"))
			{
				targetnamer = getentarray (targetname, "target");
				if ((targetnamer.size) && (isdefined (targetnamer[0].targetname)))
					targetname = targetnamer[0].targetname;
//				println ("new targetname is ", targetname);
			}

		if ((targetname == "mg42")
			|| (targetname == "grenade_spawner")
			|| (targetname == "friendly_wave")
			|| (targetname == "grenade_spawner_auto"))
				override = true;


		// special hack for burnville
		if (targetname == "secondfloor_gren_guy")
		{
			self.targetname = "secondfloor_gren_guy";
			self.maxSightDistSqrd = 90000;
		}
	}

	maps\_gameskill::grenadeAwareness();

	if (isdefined (self.script_bcdialog))
		self setBattleChatter(self.script_bcdialog);

	self.suppressionwait = 2;

	if (isdefined (self.script_suppression))
		self.suppressionwait = self.script_suppression;

	// Set the accuracy for the spawner
	if (isdefined(self.script_accuracy))
	{
		self.baseAccuracy = self.script_accuracy;
	}

	if (isdefined(self.script_accuracyStationaryMod))
	{
		// Currently accuracystationarymod and accuracy are overwritten by animscript
		self.baseAccuracy = self.script_accuracyStationaryMod;
//		self.accuracyStationaryMod = self.script_accuracyStationaryMod;
	}
	
	if (isdefined(self.script_escape))
		level thread escapeBehavior(self.script_escape);

	if (isdefined(self.script_flanker))
		level thread flankBehavior(self.script_flanker, self.targetname);

    // JBW - allied reinforcements are in a hurry
    if ( self.team == "allies" )
        self . walkdist = 16;

	if (isdefined(self.script_ignoreme))
		self.ignoreme = true;

	if (isdefined(self.drophealth))
		self thread drophealth();

	if (isdefined(self.script_sightrange))
		self.maxSightDistSqrd = self.script_sightrange;

	if (self.team != "axis")
	{
		self thread use_for_ammo();

		// Set the followmin for friendlies
		if (isdefined(self.script_followmin))
		{
			self.followmin = self.script_followmin;
		}

		// Set the followmax for friendlies
		if (isdefined(self.script_followmax))
		{
			self.followmax = self.script_followmax;
		}


		// Set the on death thread for friendlies
//		self maps\_names::get_name();
		level thread friendly_waittill_death (self);
	}

	if (self.team == "axis")
		self thread drop_gear();


	// sets the favorite enemy of a spawner
	if (isdefined(self.script_favoriteenemy))
	{
	//	println ("favorite enemy is defined");
		if (self.script_favoriteenemy == "player")
		{
			self.favoriteenemy = level.player;
			level.player.targetname = "player";
	//		println ("setting favoriteenemy = player");
		}
	}

	if (isdefined(self.script_deletonpathend))
		self thread deleteonpathend_think();
	
//added by mofo********
	if (isdefined(self.script_fightdist))
		self.pathenemyfightdist = self.script_fightdist;
	
	if (isdefined(self.script_maxdist))
		self.pathenemylookahead = self.script_maxdist;	
//end added by mofo********

	// disable long death like dying pistol behavior
	if (isdefined(self.script_longdeath) && self.script_longdeath == false)
	{
		self.anim_disableLongDeath = true;	
		assertEX(self.team != "allies", "Allies can't do long death, so why disable it on the guy at " + self.origin + "?");
	}
	else
	{
		// Make axis have 150 health so they can do dying pain.
		if (self.team == "axis" && !portableMG42guy)
			self.health = 150;
	}


	// Gives AI grenades
	if (isdefined(self.script_grenades))
	{
		self.grenadeAmmo = self.script_grenades;
	}
	else
		self.grenadeAmmo = 3;

	// Puts AI in pacifist mode
	if (isdefined(self.script_pacifist))
	{
		self.pacifist = true;
	}

	// Set the health for special cases
	if (isdefined(self.script_startinghealth))
	{
		self.health = self.script_startinghealth;
	}

	// The AI will spawn and attack the player
	if (isdefined(self.script_playerseek))
	{
		self setgoalentity (level.player);
		return;
	}

	// The AI will spawn and follow a patrol
	if (isdefined(self.script_patroller))
	{
		self thread maps\_patrol::patrol();
		return;
	}
	
	// The AI will spawn and use his .radius as a goalradius, and his goalradius will get smaller over time.
	if (isdefined(self.script_delayed_playerseek))
	{
		if (!isdefined (self.script_radius))
			self.goalradius = 800;

		self setgoalentity (level.player);

		level thread delayed_player_seek_think(self);
		
		return;
	}

	if (portableMG42guy)
	{
		thread mg42setup_target();
		return;
	}

	if (isdefined (self.used_an_mg42)) // This AI was called upon to use an MG42 so he's not going to run to his node.
		return;

	if (override)
	{
		if (isdefined (self.script_radius))
			self.goalradius = self.script_radius;
			
		self setgoalpos(self.origin);
		return;
	}

	if (isdefined (self.script_radius))
		self.goalradius = self.script_radius;
	else
		self.goalradius = 512;

	// The AI will run to a target node and use the node's .radius as his goalradius.
	// If script_seekgoal is set, then he will run to his node with a goalradius of 0, then set his goal radius
	//    to the node's radius.
	if (isdefined(self.target))
		self thread go_to_node ();
}

delayed_player_seek_think(spawned)
{
	spawned endon ("death");
	while (isalive (spawned))
	{
		if (spawned.goalradius > 200)
			spawned.goalradius -= 200;

		wait 6;
	}
}

flag_turret_for_use (ai)
{
	self endon("death");
	if (!self.flagged_for_use)
	{
		ai.used_an_mg42 = true;
		self.flagged_for_use = true;
		ai waittill ("death");
		self.flagged_for_use = false;
		self notify ("get new user");
		return;
	}

	println ("Turret was already flagged for use");
}

go_to_node(node)
{
	if (isdefined (self.used_an_mg42)) // This AI was called upon to use an MG42 so he's not going to run to his node.
		return;

	self endon ("stop_going_to_node");
	
	volume = undefined;

	if (!isdefined (node))
	{
		node = getnodearray(self.target, "targetname");
		if (node.size > 0)
		{
			level.current_spawn_num++;
			while (level.current_spawn_num >= node.size)
				level.current_spawn_num -= node.size;

			if (level.current_spawn_num < 0)
				level.current_spawn_num = 0;

//			println ("Going to node ", level.current_spawn_num);
			node = node[level.current_spawn_num];
		}
		else
		{
			volume = getentarray(self.target, "targetname");
			if (volume.size > 0)
			{
				level.current_spawn_num++;
				while (level.current_spawn_num >= volume.size)
					level.current_spawn_num -= volume.size;

				if (level.current_spawn_num < 0)
					level.current_spawn_num = 0;

//				println ("Going to volume ", level.current_spawn_num);
				volume = volume[level.current_spawn_num];
				if (volume.classname != "info_volume")
					return;
					
				assertEx (isdefined (volume.target), "Goal volume at " + volume getorigin() + " doesn't target a node");
				node = getnode(volume.target, "targetname");
			}
			else
			{
				return;
			}
		}
	}

	if (isdefined (node.target))
	{
		turret = getent (node.target, "targetname");
		if ((isdefined (turret)) && ((turret.classname == "misc_mg42") || (turret.classname == "misc_turret")))
			turret thread flag_turret_for_use (self);
	}

	// AI is moving to a goal node
	if (isdefined (node.height))
		self.goalheight = node.height;
	else
		self.goalheight = 512;
	
	self setgoalnode(node);
	if (node.radius != 0)
		self.goalradius = (node.radius);
	else
		self.goalradius = (512);

	if (isdefined(volume))
	{
		// AI is moving to a goal volume
		self setgoalvolume(volume);
	}
		
	/*
	if (isdefined (self.script_seekgoal))
	{
		self.goalradius = (0);
		self waittill ("goal");
	}
	*/


	if (isdefined (node.target))
	{
		self endon ("death");
		nextNode = getnode(node.target,"targetname");
		if (isdefined(nextNode))
		{
			self waittill ("goal");
			for (;;)
			{
				if (isdefined (node.script_delay))
					wait (node.script_delay);
				node = nextNode;
				if (node.radius != 0)
					self.goalradius = node.radius;
				self setgoalnode (node);
				self waittill ("goal");
				if (!isdefined (node.target))
				{
					self notify ( "reached_path_end" );
					return;
				}
				nextNode = getnode(node.target,"targetname");
				if (!isdefined(nextNode))
				{
					self notify ( "reached_path_end" );
					break;
				}
			}
		}
		
		turret = getent (node.target, "targetname");
		if ((isdefined (turret)) && ((turret.classname == "misc_mg42") || (turret.classname == "misc_turret")))
		{
			self setgoalnode(node);
			self.goalradius = (4);
			self waittill ("goal");
			self use_a_turret (turret);

//			while (isalive (self))
//			{
//				self setgoalnode(node);
//				self.goalradius = (64);
//				self waittill ("goal");
//				self useturret(turret); // dude should be near the mg42
//				wait (6);
//			}
		}
	}
	else
	{
		self thread reachPathEnd();
	}
}

reachPathEnd()
{
	self waittill ("goal");
	self notify ("reached_path_end");
}

autoTarget(targets)
{
	for (;;)
	{
		user = self getturretowner();
		if (!isalive(user))
		{
			wait (1.5);
			continue;
		}
		
		if (!isdefined (user.enemy))
		{
			self settargetentity (random(targets));
			self notify ("startfiring");
			self startFiring();
		}

		wait (2 + randomfloat(1));
	}
}

manualTarget(targets)
{
	for (;;)
	{
		self settargetentity (random(targets));
		self notify ("startfiring");
		self startFiring();

		wait (2 + randomfloat(1));
	}
}

use_a_turret (turret)
{
	if (self.team == "axis" && self.health == 150)
	{
		self.health = 100; // mg42 operators aren't going to do long death
		self.anim_disableLongDeath = true;
	}
		
	self useturret(turret); // dude should be near the mg42
	turret setmode("auto_ai"); // auto, auto_ai, manual
	if ((isdefined (turret.target)) && (turret.target != turret.targetname))
	{
		ents = getentarray (turret.target,"targetname");
		targets = [];
		for (i=0;i<ents.size;i++)
		{
			if (ents[i].classname == "script_origin")
				targets[targets.size] = ents[i];
		}
		
		if (isdefined(turret.script_autotarget))
			turret thread autoTarget(targets);
		else
		if (isdefined(turret.script_manualtarget))
		{
			turret setmode("manual_ai");
			turret thread manualTarget(targets);
		}
		else
		if (targets.size > 0)
		{
			if (targets.size == 1)
			{
				turret.manual_target = targets[0];
				turret settargetentity(targets[0]);
				turret setmode("manual_ai"); // auto, auto_ai, manual
				self thread maps\_mg42::manual_think (turret);
				if (isdefined (self.script_mg42auto))
					println ("AI at origin ", self.origin , " has script_mg42auto");
			}
			else
			{
				turret thread maps\_mg42::mg42_suppressionFire(targets);
			}
		}		
	}
	
	self thread maps\_mg42::mg42_firing(turret);
	
	turret notify ("startfiring");
	
	self useturret(turret); // dude should be near the mg42
}

fallback_spawner_think (num, node)
{
	self endon ("death");
	level.current_fallbackers[num]+= self.count;
	firstspawn = true;
	while (self.count > 0)
	{
		self waittill ("spawned", spawn);
		if (firstspawn)
		{
			if (getcvar ("fallback") == "1")
				println ("^a First spawned: ", num);
			level notify (("fallback_firstspawn" + num));
			firstspawn = false;
		}
		
		maps\_spawner::waitframe(); // Wait until he does all his usual spawned logic so he will run to his node
		if (maps\_utility::spawn_failed(spawn))
		{
			level notify (("fallbacker_died" + num));
			level.current_fallbackers[num]--;
			continue;
		}

		spawn thread fallback_ai_think (num, node, "is spawner");
	}

//	level notify (("fallbacker_died" + num));
}

fallback_ai_think_death(ai, num)
{
	ai waittill ("death");
	level.current_fallbackers[num]--;

	level notify (("fallbacker_died" + num));
}

fallback_ai_think (num, node, spawner)
{
	if ((!isdefined (self.fallback)) || (!isdefined (self.fallback[num])))
		self.fallback[num] = true;
	else
		return;

	self.script_fallback = num;
	if (!isdefined (spawner))
		level.current_fallbackers[num]++;

	if ((isdefined (node)) && (level.fallback_initiated[num]))
	{
		self thread fallback_ai (num, node);
		/*
		self notify ("stop_going_to_node");
		self setgoalnode (node);
		if (isdefined (node.radius))
			self.goalradius = node.radius;
		*/
	}

	level thread fallback_ai_think_death(self, num);
}

fallback_death(ai, num)
{
	ai waittill ("death");
	level notify (("fallback_reached_goal" + num));
//	ai notify ("fallback_notify");
}

fallback_goal()
{
	self waittill ("goal");
	self.suppressionwait = self.oldsuppressionwait;

	self notify ("fallback_notify");
	self notify ("stop_coverprint");
}

fallback_ai (num, node)
{
	self notify ("stop_going_to_node");

	self stopuseturret();
	self.oldsuppressionwait = self.suppressionwait;
	self.suppressionwait = 0;
	self setgoalnode (node);
	if (node.radius != 0)
		self.goalradius = node.radius;

	self endon ("death");
	level thread fallback_death(self, num);
	self thread fallback_goal();

	if (getcvar ("fallback") == "1")
		self thread coverprint(node.origin);

	self waittill ("fallback_notify");
	level notify (("fallback_reached_goal" + num));
}

coverprint (org)
{
	self endon ("fallback_notify");
	self endon ("stop_coverprint");

	while (1)
	{
		line (self.origin + (0,0,35), org, (0.2, 0.5, 0.8), 0.5);
		print3d ((self.origin + (0, 0, 70)), "Falling Back", (0.98,0.4,0.26), 0.85);
		maps\_spawner::waitframe();
	}
}


newfallback_overmind (num, group)
{
	fallback_nodes = undefined;
	nodes = getallnodes ();
	for (i=0;i<nodes.size;i++)
	{
		if ((isdefined (nodes[i].script_fallback)) && (nodes[i].script_fallback == num))
			fallback_nodes = maps\_utility::add_to_array (fallback_nodes, nodes[i]);
	}

	if (!isdefined (fallback_nodes))
		return;

	level.current_fallbackers[num] = 0;
	level.spawner_fallbackers[num] = 0;
	level.fallback_initiated[num] = false;

	spawners = getspawnerarray ();
	for (i=0;i<spawners.size;i++)
	{
		if ((isdefined (spawners[i].script_fallback)) && (spawners[i].script_fallback == num))
		{
			if (spawners[i].count > 0)
			{
				spawners[i] thread fallback_spawner_think(num,fallback_nodes[randomint (fallback_nodes.size)]);
				level.spawner_fallbackers[num]++;
			}
		}
	}

	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		if ((isdefined (ai[i].script_fallback)) && (ai[i].script_fallback == num))
			ai[i] thread fallback_ai_think(num);
	}

	if ((!level.current_fallbackers[num]) && (!level.spawner_fallbackers[num]))
		return;

	spawners = undefined;
	ai = undefined;

	thread fallback_wait (num, group);
	level waittill (("fallbacker_trigger" + num));
	if (getcvar ("fallback") == "1")
		println ("^a fallback trigger hit: ", num);
	level.fallback_initiated[num] = true;

	fallback_ai = undefined;
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		if (((isdefined (ai[i].script_fallback)) && (ai[i].script_fallback == num)) ||
			((isdefined (ai[i].script_fallback_group)) && (isdefined (group)) && (ai[i].script_fallback_group == group)))
			fallback_ai = maps\_utility::add_to_array (fallback_ai, ai[i]);
	}
	ai = undefined;

	if (!isdefined (fallback_ai))
		return;

	first_half = fallback_ai.size*0.4;
	first_half = int(first_half);

	level notify ("fallback initiated " + num);

	fallback_text(fallback_ai, 0, first_half);
	for (i=0;i<first_half;i++)
		fallback_ai[i] thread fallback_ai (num, fallback_nodes[randomint (fallback_nodes.size)]);

	for (i=0;i<first_half;i++)
		level waittill (("fallback_reached_goal" + num));

	fallback_text(fallback_ai, first_half, fallback_ai.size);

	for (i=first_half;i<fallback_ai.size;i++)
	{
		if (isalive (fallback_ai[i]))
			fallback_ai[i] thread fallback_ai (num, fallback_nodes[randomint (fallback_nodes.size)]);
	}
}

fallback_text(fallbackers, start, end)
{
	if (gettime() <= level._nextcoverprint)
		return;

	for (i=start;i<end;i++)
	{
		if (!isalive (fallbackers[i]))
			continue;
			
		level._nextcoverprint = gettime() + 2500 + randomint(2000);
		total = fallbackers.size;
		temp = int(total * 0.4);

		if (randomint (100) > 50)
		{
			if (total - temp > 1)
			{
				if (randomint (100) > 66)
					msg = "dawnville_defensive_german_1";
				else
				if (randomint (100) > 66)
					msg = "dawnville_defensive_german_2";
				else
					msg = "dawnville_defensive_german_3";
			}
			else
			{
				if (randomint (100) > 66)
					msg = "dawnville_defensive_german_4";
				else
				if (randomint (100) > 66)
					msg = "dawnville_defensive_german_5";
				else
					msg = "dawnville_defensive_german_1";
			}
		}
		else
		{

			if (temp > 1)
			{
				if (randomint (100) > 66)
					msg = "dawnville_defensive_german_2";
				else
				if (randomint (100) > 66)
					msg = "dawnville_defensive_german_3";
				else
					msg = "dawnville_defensive_german_4";
			}
			else
			{
				if (randomint (100) > 66)
					msg = "dawnville_defensive_german_5";
				else
				if (randomint (100) > 66)
					msg = "dawnville_defensive_german_1";
				else
					msg = "dawnville_defensive_german_2";
			}
		}

		fallbackers[i] animscripts\face::SaySpecificDialogue(undefined, msg, 1.0);
		
		return;
	}
}

fallback_wait (num, group)
{
	level endon (("fallbacker_trigger" + num));
	if (getcvar ("fallback") == "1")
		println ("^a Fallback wait: ", num);
	for (i=0;i<level.spawner_fallbackers[num];i++)
	{
		if (getcvar ("fallback") == "1")
			println ("^a Waiting for spawners to be hit: ", num, " i: ", i);
		level waittill (("fallback_firstspawn" + num));
	}
	if (getcvar ("fallback") == "1")
		println ("^a Waiting for AI to die, fall backers for group ", num, " is ", level.current_fallbackers[num]);

//	total_fallbackers = 0;
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		if (((isdefined (ai[i].script_fallback)) && (ai[i].script_fallback == num)) ||
			((isdefined (ai[i].script_fallback_group)) && (isdefined (group)) && (ai[i].script_fallback_group == group)))
			ai[i] thread fallback_ai_think(num);
	}
	ai = undefined;

//	if (!total_fallbackers)
//		return;

	max_fallbackers = level.current_fallbackers[num];

	deadfallbackers = 0;
	while (level.current_fallbackers[num] > max_fallbackers * 0.5)
	{
		if (getcvar ("fallback") == "1")
			println ("^cwaiting for " + level.current_fallbackers[num] + " to be less than " + (max_fallbackers * 0.5));
		level waittill (("fallbacker_died" + num));
		deadfallbackers++;
	}

	println (deadfallbackers , " fallbackers have died, time to retreat");
	level notify (("fallbacker_trigger" + num));
}

fallback_think(trigger) // for fallback trigger
{
	if ((!isdefined (level.fallback)) || (!isdefined (level.fallback[trigger.script_fallback])))
		level thread newfallback_overmind (trigger.script_fallback, trigger.script_fallback_group);

	trigger waittill ("trigger");
	level notify (("fallbacker_trigger" + trigger.script_fallback));
//	level notify (("fallback" + trigger.script_fallback));

	// Maybe throw in a thing to kill triggers with the same fallback? God my hands are cold.
	kill_trigger (trigger);
}

arrive (node)
{
	self waittill ("goal");

	if (node.radius != 0)
		self.goalradius = (node.radius);
	else
		self.goalradius = (512);
}

fallback_coverprint ()
{
//	self endon ("death");
	self endon ("fallback");
	self endon ("fallback_clear_goal");
	self endon ("fallback_clear_death");
	while (1)
	{
		if (isdefined (self.coverpoint))
			line (self.origin + (0,0,35), self.coverpoint.origin, (0.2, 0.5, 0.8), 0.5);
		print3d ((self.origin + (0, 0, 70)), "Covering", (0.98,0.4,0.26), 0.85);
		maps\_spawner::waitframe();
	}
}

fallback_print ()
{
//	self endon ("death");
	self endon ("fallback_clear_goal");
	self endon ("fallback_clear_death");
	while (1)
	{
		if (isdefined (self.coverpoint))
			line (self.origin + (0,0,35), self.coverpoint.origin, (0.2, 0.5, 0.8), 0.5);
		print3d ((self.origin + (0, 0, 70)), "Falling Back", (0.98,0.4,0.26), 0.85);
		maps\_spawner::waitframe();
	}
}

fallback ()
{
//	self endon ("death");
	dest = getnode (self.target, "targetname");
	self.coverpoint = dest;

	self setgoalnode(dest);
	if (isdefined (self.script_seekgoal))
		self thread arrive(dest);
	else
	{
		if (dest.radius != 0)
			self.goalradius = (dest.radius);
		else
			self.goalradius = (512);
	}

	while (1)
	{
		self waittill ("fallback");
		self.interval = 20;
		level thread fallback_death(self);

		if (getcvar ("fallback") == "1")
			self thread fallback_print();

		if (isdefined (dest.target))
		{
			dest = getnode (dest.target, "targetname");
			self.coverpoint = dest;
			self setgoalnode (dest);
			self thread fallback_goal();
			if (dest.radius != 0)
				self.goalradius = dest.radius;
		}
		else
		{
			level notify (("fallback_arrived" + self.script_fallback));
			return;
		}
	}
}


use_for_ammo()
{
	// Use for ammo is disabled pending further design decisions.
/*
	while (isalive (self))
	{
		self waittill("trigger");

		currentweapon = level.player getCurrentWeapon();
		level.player giveMaxAmmo(currentweapon);
		println ("Giving player ammo for current weapon");
		wait 3;
	}
*/
}

friendly_waittill_death (spawned)
{
	// Disabled globally by Zied, addresses bug 3092, too much text on screen.
	/////////////

/*
	if (isdefined (spawned.script_noDeathMessage))
		return;

	name = spawned.name;

	spawned waittill ("death");
	if ((level.script != "stalingrad") && (level.script != "stalingrad_nolight"))
		println (name, " - KIA");
*/
}

delete_me()
{
	maps\_spawner::waitframe();
	self delete();
}

vlength (vec1, vec2)
{
	v0 = vec1[0] - vec2[0];
	v1 = vec1[1] - vec2[1];
	v2 = vec1[2] - vec2[2];

	v0 = v0 * v0;
	v1 = v1 * v1;
	v2 = v2 * v2;

	veclength = v0 + v1 + v2;

	return veclength;
}

waitframe()
{
	wait (0.05);
}

specialCheck(name)
{
	for (;;)
	{
		assertEX (getentarray (name, "targetname").size, "Friendly wave trigger that targets " + name + " doesnt target any spawners");
		wait (0.05);
	}
}

friendly_wave (trigger)
{
//	thread specialCheck(trigger.target);
	
	if (!isdefined (level.friendly_wave_active))
		thread friendly_wave_masterthread();
/#
	if (trigger.targetname == "friendly_wave")
	{
		assert = false;
		targs = getentarray (trigger.target, "targetname");
		for (i=0;i<targs.size;i++)
		{
			if (isdefined (targs[i].classname[7]))
			if (targs[i].classname[7] != "l")
			{
				println ("Friendyl_wave spawner at ", targs[i].origin," is not an ally");
				assert = true;
			}
		}
		if (assert)
			maps\_utility::error ("Look above");
	}
#/
	while (1)
	{
		trigger waittill ("trigger");
		level notify ("friendly_died");
		if (trigger.targetname == "friendly_wave")
			level.friendly_wave_trigger = trigger;
		else
		{
			level.friendly_wave_trigger = undefined;
			println ("friendly wave OFF");
		}

		wait (1);
	}
}


set_spawncount(count)
{
	if (!isdefined (self.target))
		return;

	spawners = getentarray (self.target, "targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i].count = 0;
}

friendlydeath_levelthread(ai)
{
	if (!isdefined (level.totalfriends))
		level.totalfriends = 0;
	level.totalfriends++;
	ai waittill ("death");
	level notify ("friendly_died");
	level.totalfriends--;
}

friendlydeath_thread()
{
	level friendlydeath_levelthread(self);
}

friendly_wave_masterthread()
{
	level.friendly_wave_active = true;
	//level.totalfriends = 0;

	triggers = getentarray ("friendly_wave", "targetname");
	maps\_utility::array_thread(triggers, ::set_spawncount, 0);

	//friends = getaiarray ("allies");
	//maps\_utility::array_thread(friends, ::friendlydeath_thread);

	if (!isdefined (level.maxfriendlies))
		level.maxfriendlies = 7;

	names = 1;
	while (1)
	{
		if ((isdefined (level.friendly_wave_trigger)) && (isdefined (level.friendly_wave_trigger.target)))
		{
			old_friendly_wave_trigger = level.friendly_wave_trigger;

			spawn = getentarray (level.friendly_wave_trigger.target, "targetname");

			if (!spawn.size)
			{
				level waittill ("friendly_died");
				continue;
			}
			num = 0;
			script_delay = isdefined(level.friendly_wave_trigger.script_delay);
			while ((isdefined (level.friendly_wave_trigger)) && (level.totalfriends < level.maxfriendlies))
			{
				if (old_friendly_wave_trigger != level.friendly_wave_trigger)
				{
					script_delay = isdefined(level.friendly_wave_trigger.script_delay);
					old_friendly_wave_trigger = level.friendly_wave_trigger;
					assertex(isdefined(level.friendly_wave_trigger.target),"Wave trigger must target spawner");
					spawn = getentarray (level.friendly_wave_trigger.target, "targetname");
				}
				if(!script_delay)
					num = randomint (spawn.size);
				else if(num == spawn.size)
					num = 0;

				spawn[num].count = 1;
				if (isdefined(spawn[num].script_forcespawn))
					spawned = spawn[num] stalingradspawn();
				else
					spawned = spawn[num] dospawn();
				spawn[num].count = 0;
				
				if (spawn_failed(spawned))
				{
					wait (0.2);
					continue;
				}

				if (isdefined (level.friendlywave_thread))
					level thread [[level.friendlywave_thread]](spawned);
				else
					spawned setgoalentity (level.player);

				if(script_delay)
				{
					if(level.friendly_wave_trigger.script_delay == 0)
						waittillframeend;
					else
						wait level.friendly_wave_trigger.script_delay;
					num++;
				}
				else
					wait (randomfloat (5));
			}
		}

		level waittill ("friendly_died");
	}
}

friendly_mg42(trigger)
{
/#
	if (!isdefined (trigger.target))
		maps\_utility::error ("No target for friendly_mg42 trigger, origin:" + trigger getorigin());
#/

	node = getnode (trigger.target,"targetname");

/#
	if (!isdefined (node.target))
		maps\_utility::error ("No mg42 for friendly_mg42 trigger's node, origin: " + node.origin);
#/

	mg42 = getent (node.target,"targetname");
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	mg42 cleartargetentity();


	in_use = false;
	while (1)
	{
//		println ("^a mg42 waiting for trigger");
		trigger waittill ("trigger", other);
//		println ("^a MG42 TRIGGERED");
		if (isSentient (other))
		if (other == level.player)
			continue;

		if (!isdefined (other.team))
			continue;

		if (other.team != "allies")
		 	continue;

		if ((isdefined (other.script_usemg42)) && (other.script_usemg42 == false))
			continue;

		if (other thread friendly_mg42_useable (mg42, node))
		{
			other thread friendly_mg42_think(mg42, node);

			mg42 waittill ("friendly_finished_using_mg42");
			if (isalive (other))
				other.turret_use_time = gettime() + 10000;
		}

		wait (1);
	}
}

friendly_mg42_death_notify(guy, mg42)
{
	mg42 endon ("friendly_finished_using_mg42");
	guy waittill ("death");
	mg42 notify ("friendly_finished_using_mg42");
	println ("^a guy using gun died");
}

friendly_mg42_wait_for_use(mg42)
{
	mg42 endon ("friendly_finished_using_mg42");
	self.useable = true;
	self setcursorhint("HINT_NONE");
	self setHintString(&"PLATFORM_USEAIONMG42");
	self waittill ("trigger");
	println ("^a was used by player, stop using turret");
	self.useable = false;
	self setHintString("");
	self stopuseturret();
	self notify ("stopped_use_turret"); // special hook for decoytown guys -nate
	mg42 notify ("friendly_finished_using_mg42");
}

friendly_mg42_useable (mg42, node)
{
	if (self.useable)
		return false;
		
	if ((isdefined (self.turret_use_time)) && (gettime() < self.turret_use_time))
	{
//		println ("^a Used gun too recently");
		return false;
	}

	if (distance (level.player.origin, node.origin) < 100)
	{
//		println ("^a player too close");
		return false;
	}

	if (isdefined (self.chainnode))
	if (distance (level.player.origin, self.chainnode.origin) > 1100)
	{
//		println ("^a too far from chain node");
		return false;
	}
	return true;
}

friendly_mg42_endtrigger (mg42, guy)
{
	mg42 endon ("friendly_finished_using_mg42");
	self waittill ("trigger");
	println ("^a Told friendly to leave the MG42 now");
//	guy stopuseturret();
//	badplace_cylinder(undefined, 3, level.player.origin, 150, 150, "allies");

	mg42 notify ("friendly_finished_using_mg42");
}

friendly_mg42_stop_use ()
{
	if (!isdefined (self.friendly_mg42))
		return;
	self.friendly_mg42 notify ("friendly_finished_using_mg42");
}

noFour()
{
	self endon ("death");
	self waittill ("goal");
	self.goalradius = self.oldradius;
	if (self.goalradius < 32)
		self.goalradius = 400;
}

friendly_mg42_think (mg42, node)
{
	self endon ("death");
	mg42 endon ("friendly_finished_using_mg42");
//	self endon ("death");
	level thread friendly_mg42_death_notify(self, mg42);
//	println (self.name + "^a is using an mg42");
	self.oldradius = self.goalradius;
	self.goalradius = 28;
	self thread noFour();
	self setgoalnode (node);

	self.oldsuppressionwait = self.suppressionwait;

	self.suppressionwait = 0;

	self waittill ("goal");
	self.goalradius = self.oldradius;
	if (self.goalradius < 32)
		self.goalradius = 400;

//	println ("^3 my goal radius is ", self.goalradius);
	self.suppressionwait = self.oldsuppressionwait;

	// Temporary fix waiting on new code command to see who the player is following.
//	self setgoalentity (level.player);
	self.goalradius = self.oldradius;

	if (distance (level.player.origin, node.origin) < 32)
	{
		mg42 notify ("friendly_finished_using_mg42");
		return;
	}

	self.friendly_mg42 = mg42; // For making him stop using the mg42 from another script
	self thread friendly_mg42_wait_for_use(mg42);
	self thread friendly_mg42_cleanup (mg42);
	self useturret(mg42); // dude should be near the mg42
//	println ("^a Told AI to use mg42");

	if (isdefined (mg42.target))
	{
		stoptrigger = getent (mg42.target,"targetname");
		if (isdefined (stoptrigger))
			stoptrigger thread friendly_mg42_endtrigger(mg42, self);
	}

	while (1)
	{
		if (distance (self.origin, node.origin) < 32)
			self useturret(mg42); // dude should be near the mg42
		else
			break; // a friendly is too far from mg42, stop using turret

		if (isdefined (self.chainnode))
		{
			if (distance (self.origin, self.chainnode.origin) > 1100)
				break; // friendly node is too far, stop using turret
		}

		wait (1);
	}

	mg42 notify ("friendly_finished_using_mg42");
}

friendly_mg42_cleanup (mg42)
{
	self endon ("death");
	mg42 waittill ("friendly_finished_using_mg42");
	self friendly_mg42_doneUsingTurret();
}

friendly_mg42_doneUsingTurret ()
{
	self endon ("death");
	turret = self.friendly_mg42;
	self.friendly_mg42 = undefined;
	self stopuseturret();
	self notify ("stopped_use_turret"); // special hook for decoytown guys -nate
	self.useable = false;
	self.goalradius = self.oldradius;
	if (!isdefined (turret))
		return;

	if (!isdefined (turret.target))
		return;

	node = getnode (turret.target,"targetname");
	oldradius = self.goalradius;
	self.goalradius = 8;
	self setgoalnode (node);
	wait (2);
	self.goalradius = 384;
	return;
	self waittill ("goal");
	if (isdefined (self.target))
	{
		node = getnode (self.target,"targetname");
		if (isdefined (node.target))
			node = getnode (node.target,"targetname");
			
		if (isdefined (node))
			self setgoalnode (node);
	}
	self.goalradius = oldradius;
}

//	self thread maps\_mg42::mg42_firing(mg42);
//	mg42 notify ("startfiring");

tanksquish()
{
	if ( (isdefined(level.noTankSquish)) && (level.noTankSquish == true) )
		return;
	self notify ("tanksquishoff");
	self endon ("tanksquishoff");
	self endon ("death");
	
	while(1)
	{
		self waittill ("damage",amt,who);
		if(!isalive(self) && isdefined(who) && isdefined(who.vehicletype))
			self playsound ("human_crunch");
	}
}

killfriends_missionfail_think(ai, istank, team)
{
	level endon ("mission failed");
	
	if ( (isdefined (istank)) && (istank == 1) )
	{
		if (!isdefined (ai))
			return;
		if (!isdefined (team))
			team = "allies";
		
		ai waittill ("death", attacker);
		if (!isdefined (attacker))
			return;
		
		if (team == "allies")
		{
			if (attacker == level.player)
			{
				//always fail the mission on Veteran
				if (level.gameSkill >= 3)
				{
					if ( (isdefined (ai.damagelocation)) && (ai.damagelocation == "none") )
						return;
					thread killfriends_missionfail();
				}
				else 
				if ( (isdefined (ai.failWhenKilled)) && (ai.failWhenKilled == true) )
				{
					thread killfriends_missionfail();
				}
				else
				if (level.killedaxis < 4)// If the player hasn't killed at least 4 enemies before killing this friendly
				{
					thread killfriends_missionfail();
				}
				else
				{
					level.ffpoints = 0;
					level.killedaxis = 0;
				}
			}
		}
		else if (team == "axis")
		{
			//ghetto style to make turrets count as friendly fire since using a turret doesn't make you the attacker
			if (attacker == level.player)
				level.killedaxis++;
		}
	}
	else
	{
		trackDeath = true;
		if ((!isSentient (ai)) || (!isalive (ai)))
			trackDeath = false;
		if ( (isdefined(ai.targetname)) && (ai.targetname == "drone") )
			trackDeath = true;
		if ( (isdefined(ai.missionfail_trackDeath)) && (ai.missionfail_trackDeath == true) )
			trackDeath = true;
		
		if (!trackDeath)
			return;
		
		if ( (isdefined (ai.script_noteworthy)) && (ai.script_noteworthy == "missionfail_death") )
		{
			thread killfriends_damage_think(ai);
			ai waittill ( "death", other, mod );
			if (!isdefined (other))
				return;
			if (other != level.player)
				return;
			if ( (isdefined (ai.damagelocation)) && (ai.damagelocation == "none") )
				return;
			if ( (isdefined (mod)) && (issubstr(mod,"GRENADE")) )
				return;
			if ( (isdefined (ai.failWhenKilled)) && (ai.failWhenKilled == false) )
				return;
			thread killfriends_missionfail();
		}
		else if ( (isdefined (ai.script_noteworthy)) && (ai.script_noteworthy == "missionfail_damage") )
		{
			thread killfriends_damage_think(ai);
			while (1)
			{
				ai waittill ( "friendly_damage", damage, attacker, direction, point, method );
				if (!isdefined (attacker))
					continue;
				if (attacker != level.player)
					continue;
				if ( (isdefined (method)) && (method == "MOD_GRENADE_SPLASH") )
				{
					if(killfriends_savecommit_afterGrenade())
						continue;
				}
				if ( (isdefined (ai.failWhenKilled)) && (ai.failWhenKilled == false) )
					continue;
				thread killfriends_missionfail();
			}
		}
		else if ( (isdefined (ai.script_noteworthy)) && (ai.script_noteworthy == "missionfail_never") )
		{
			return;
		}
		else if (ai.team == "axis")
		{
			ai waittill ("death",other);
			if ( (isdefined (other)) && (other == level.player) )
				level.killedaxis++;
		}
		else if (ai.team == "allies")
		{
			thread killfriends_damage_think(ai);
			wasGrenade = false;
			ai waittill ("death", other, method);
			
			if ( (isdefined (other)) && (other == level.player) )
			{
				//check grenades
				if ( ( (isdefined(ai)) && (isdefined(ai.damageweapon)) && (ai.damageweapon == "none") ) ||
					( (isdefined (method)) && (method == "MOD_GRENADE_SPLASH") ) )
				{
					wasGrenade = true;
					if (killfriends_savecommit_afterGrenade())
					{
						level.killedaxis = 0;
						return;
					}
				}
				
				//always fail the mission on Veteran
				if ( (level.gameSkill >= 3) && (!wasGrenade) )
				{
					thread killfriends_missionfail();
				}
				else
				if ( (isdefined(ai)) && (isdefined (ai.failWhenKilled)) && (ai.failWhenKilled == false) )
				{
					return;
				}
				else// If the player was the one who killed the friendly
				{
					axisRequired = 4;
					if (wasGrenade)
						axisRequired = 1;
					if (level.killedaxis < axisRequired)// If the player hasn't killed at least 4 enemies before killing this friendly
					{
						if ( (isdefined(ai)) && (isdefined(ai.damageweapon)) && (ai.damageweapon == "none") )
						{
							if (killfriends_savecommit_afterGrenade())
							{
								level.ffpoints = 0;
								level.killedaxis = 0;
								return;
							}
						}
						thread killfriends_missionfail();
					}
					else
					{
						level.ffpoints = 0;
						level.killedaxis = 0;
					}
				}
			}
			else if ( (isdefined (other)) && (other.classname == "script_vehicle") )
			{
				//check if it's a turret the player is using
				owner = other getVehicleOwner();
				if ( (isdefined(owner)) && (owner == level.player) )
				{
					if (level.killedaxis < 4)// If the player hasn't killed at least 4 enemies before killing this friendly
					{
						if ( (isdefined(ai)) && (isdefined(ai.damageweapon)) && (ai.damageweapon == "none") )
						{
							if (killfriends_savecommit_afterGrenade())
								return;
						}
						thread killfriends_missionfail();
					}
					else
					{
						level.ffpoints = 0;
						level.killedaxis = 0;
					}
				}
			}
		}
	}
}

killfriends_savecommit_afterGrenade()
{
	currentTime = gettime();
	if (currentTime < 15000)
	{
		println("^3aborting friendly fire because the level just loaded and saved");
		return true;
	}
	else
	if ((currentTime - level.lastAutoSaveTime) < 4500)
	{
		println("^3aborting friendly fire because it could be caused by an autosave grenade loop");
		return true;
	}
	return false;
}

killfriends_missionfail()
{
	level.player endon ("death");
	level endon ("mine death");
	level notify ("mission failed");
	
	if (level.campaign == "british")
		setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_BRITISH");
	else if (level.campaign == "russian")
		setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN");
	else
		setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_AMERICAN");
	
	maps\_utility::missionFailedWrapper();
}

killfriends_damage_relay(ai, notifyString)
{
	level endon ("mission failed");
	ai endon ("death");
	while (1)
	{
		ai waittill ( notifyString, damage, attacker, direction, point, method );
		ai notify ( "friendly_damage", damage, attacker, direction, point, method );
	}
}

killfriends_damage_think(ai)
{
	level endon ("mission failed");
	ai endon ("death");
	if ( (isdefined (ai)) && (isalive (ai)) )
	{
		thread killfriends_damage_relay(ai, "damage");
		thread killfriends_damage_relay(ai, "damage_armor");

		while (1)
		{
			ai waittill ( "friendly_damage", damage, attacker, direction, point, method );
			
			playerDamage = false;
			if (!isdefined(attacker))
				continue;
			
			//check for turret the player might be on
			if ( (isdefined (attacker)) && (attacker.classname == "script_vehicle") )
			{
				//check if it's a turret the player is using
				owner = attacker getVehicleOwner();
				if ( (isdefined(owner)) && (owner == level.player) )
				{
					attacker = level.player;
					playerDamage = true;
				}
			}
			
			if (attacker == level.player)
				playerDamage = true;
			
			if (!playerDamage)
				continue;
			
			if ( (!isdefined (damage)) || (!isdefined (attacker)) )
				continue;
			
			if ( (isdefined (ai.failWhenKilled)) && (ai.failWhenKilled == false) )
				continue;
			else
			{
				d = distance(attacker.origin, point);
				scaledDamage = int(damage * (d/200));
				if (scaledDamage > damage)
					damage = scaledDamage;
				level.ffpoints = (level.ffpoints + damage);
				
				ffPointsAllowed = 250;
				if (level.gameSkill >= 3)
					ffPointsAllowed = 100;
				
				if ( (level.ffpoints >= ffPointsAllowed) && (level.killedaxis < 1) )
				{
					wasGrenade = false;
					if ( (isdefined(ai)) && (isdefined(method)) && (method == "MOD_GRENADE_SPLASH") )
					{
						wasGrenade = true;
						if (killfriends_savecommit_afterGrenade())
						{
							level.ffpoints = 0;
							level.killedaxis = 0;
							continue;
						}
					}
					if ( (wasGrenade) && (level.killedaxis >= 1) )
					{
						level.ffpoints = 0;
						level.killedaxis = 0;
						continue;
					}
					thread killfriends_missionfail();
					return;
				}
				else if ( (level.ffpoints >= ffPointsAllowed) && (level.killedaxis >= 4) )
				{
					level.ffpoints = 0;
					level.killedaxis = 0;
				}
			}
		}
	}
}


// Makes a panzer guy run to a spot and shoot a specific spot
panzer_target(ai, node, pos, targetEnt, targetEnt_offsetVec)
{
	ai endon ("death");
	ai.panzer_node = node;
	
	if (isdefined(node.script_delay))
		ai.panzer_delay = node.script_delay;
	
	if ( (isdefined (targetEnt)) && (isdefined (targetEnt_offsetVec)) )
	{
		ai.panzer_ent = targetEnt;
		ai.panzer_ent_offset = targetEnt_offsetVec;
	}
	else
		ai.panzer_pos = pos;
	ai setgoalpos (ai.origin);
	ai setgoalnode (node);
	ai.goalradius = 12;
	ai waittill ("goal");
	ai.goalradius = 28;
	ai waittill ("shot_at_target");	
	ai.panzer_ent = undefined;
	ai.panzer_pos = undefined;
	ai.panzer_delay = undefined;
//	ai.exception_exposed = animscripts\exposedcombat::exception_exposed_panzer_guy;
//	ai.exception_stop = animscripts\exposedcombat::exception_exposed_panzer_guy;
//	ai waittill ("panzer mission complete");
}

#using_animtree("generic_human");
showStart(origin, angles, anime)
{
	org = getstartorigin(origin,angles,anime);
	for (;;)
	{
		print3d (org, "x", (0.0,0.7,1.0), 1, 0.25);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}
}

mg42setup_gun()
{
	assertEX (isdefined(self.target), "Portable MG42 guy at origin " + self.origin + " has no target");
	mg42node = getnode (self.target,"targetname");
	mg42 = getent (self.target,"targetname");
	
	// If the portable gunner targets a node then he's going to do a chain of nodes to the destination, which should
	// be an mg42. Otherwise he's directly targetting an mg42.
	if (isdefined (mg42node))
	{
		// Set this so later we can run along it as a chain.
		self.mg42node = mg42node;
		assert (!isdefined (mg42), "guy at " + self.origin + " targets an ent and a node");
		for (;;)
		{
			newnode = getnode (mg42node.target,"targetname");
			if (!isdefined (newnode))
			{
				mg42 = getent (mg42node.target,"targetname");
				break;
			}
			mg42node = newnode;
		}
	}
	
	assertEX (isdefined(mg42), "Portable MG42 guy at origin " + self.origin + " doesn't target an mg42");
	assertEX (mg42.classname == "misc_turret", "Portable MG42 guy at origin " + self.origin + " doesn't target an mg42");
	if (!isdefined(mg42.isSetup))
	{
		mg42.isSetup = false;
		mg42.oldOrigin = mg42.origin;
		mg42.origin = (mg42.origin[0], mg42.origin[1], mg42.origin[2] - 1024);
		mg42 hide();
		mg42 setdefaultdroppitch(0);
		mg42 thread restoreDefaultPitch();
	}
	return mg42;
}

restoreDefaultPitch()
{
	self waittill ("gun_setup");
	wait (1);
	self restoredefaultdroppitch();
}

dropTurret()
{
	thread dropTurretProc();
}

dropTurretProc()
{
	turret = spawn ("script_model",(0,0,0));
	turret.origin = self gettagorigin ("J_gun");
	turret.angles = self gettagangles ("J_gun");
	turret setmodel (self.turretModel);
	forward = anglestoforward(self.angles);
	forward = vectorscale (forward, 100);
	turret moveGravity (forward, 0.5);
	self detach(self.turretModel, "J_gun");
	self.turretmodel = undefined;
	wait (0.7);
	turret delete();
}


turretDeathDetacher()
{
	self endon ("reached_gun_setup");
	self endon ("dropped_gun");
	self waittill ("death");
	if (!isdefined(self))
		return; // in case many guys die at once and we are removed
	dropTurret();
}

turretDetacher()
{
	self endon ("death");
	self endon ("reached_gun_setup");
	// in case the enemy gets close to a portable turret guy
	self waittill ("dropped_gun");
	self detach(self.turretModel, "J_gun");
}

mg42setup_target()
{
//	precacheModel("xmodel/weapon_mg42_carry");
	spawn_failed(self);
	
	self endon ("death");
	self endon ("dropped_gun");
	
	// Wait because if you try to make a guy that exists on the first frame run an exception, 
	// He just goes into base pose.

	mg42 = mg42setup_gun();
	
	self.mg42 = mg42;
	self.mg42setupanim = undefined;
	if (mg42.weaponinfo == "mg42_bipod_stand" || mg42.weaponinfo == "mg42_bipod_stand_distant" || mg42.weaponinfo == "mg42_bipod_duck" || mg42.weaponinfo == "30cal_stand")
		self.mg42setupanim = %mg42_sandbag_setup;
	else if (mg42.weaponinfo == "mg42_bipod_prone")
		self.mg42setupanim = %mg42_prone_setup;
	else
		assert(0);
		
//	thread showStart(self.mg42.origin, self.mg42.angles, self.mg42setupanim);		

	self.walkdist = 4;
	
	/*
	if (0)
	{
		self setexceptions(animscripts\exposedcombat::exception_exposed_mg42_portable_pickup);
		self waittill ("mg42 portable at pickup");
		// pickup anim
	}
	*/

//	assertEX (!mg42.isSetup, "an AI at origin " + self.origin + " was told to go setup an MG42 at a node where an MG42 was already setup.");
	oldhealth = self.health;

	if (issubstr(self.classname, "30cal"))	
		self.turretModel = "xmodel/weapon_30cal_carry";
	else
		self.turretModel = "xmodel/weapon_mg42_carry";


	// if the AI gets too close to their enemy
//	thread turretDetacher();
	
	self detach(self.turretModel, "TAG_ORIGIN");
	
	if (!mg42.isSetup)
	{
		// put gun in hand changes the animations used for crouch running
		self animscripts\shared::PutGunInHand("none");
		if (self.team == "axis")
			self.health = 1;
			
		self.run_noncombatanim = %mg42_run;
		self.run_combatanim = %mg42_run;
		self.crouchrun_combatanim = %mg42_run;
		
		// Detach the gun we add on from assetmanager to precache the gun
		self attach(self.turretModel, "J_gun");
		
		// if the AI dies
		thread turretDeathDetacher();
	}	

	while (isdefined (self.mg42node))
	{
		self setgoalnode(self.mg42node);
		self.goalradius = self.mg42node.radius;
		if (self.goalradius < 16)
			self.goalradius = 16;
		self waittill ("goal");
		self.mg42node = getnode (self.mg42node.target,"targetname");
	}
	
	self.goalradius = 16;
	org = getStartOrigin (self.mg42.Oldorigin, self.mg42.angles, self.mg42setupanim);
	self setgoalpos (org);	

	wait (0.05);
	if (!mg42.isSetup)
		self setexceptions(animscripts\exposedcombat::exception_exposed_mg42_portable);

//	self waittill ("mg42_portable_at_node");
	self waittill ("goal");
	wait (0.05);

	self notify ("reached_gun_setup");
	
	if (!mg42.isSetup)
	{
		if (self.team == "axis")
			self.health = oldhealth;
		mg42.origin = mg42.oldOrigin;
		if (soundexists("weapon_setup"))
			thread playsoundinspace("weapon_setup");
		self animscripted("setup done", self.mg42.origin, self.mg42.angles, self.mg42setupanim);
		self waittillmatch ("setup done", "end");
		
		mg42.isSetup = true;
		mg42 notify ("gun_setup");
		mg42 show();
	//	mg42pos = self gettagorigin("tag_mg");
	//	mg42.angles = self.mg42setup_node.angles;
		self animscripts\shared::PutGunInHand("right");
		turretWasUsed = self useturret(mg42);

		if (isdefined(mg42.script_autotarget))
			mg42 thread autoTarget(getentarray(mg42.target,"targetname"));
		else
		if (isdefined(mg42.script_manualtarget))
		{
			mg42 setmode("manual_ai");
			mg42 thread manualTarget(getentarray(mg42.target,"targetname"));
		}

		if (turretWasUsed)
			mg42 thread restorePitch();
		else
			mg42 restoredefaultdroppitch();
			
		wait (0.05);

		self detach(self.turretModel, "J_gun");
		self notify ("mg42_portable_setup");
	}
	else
	{
		self useturret(mg42);
		if (isdefined(mg42.script_autotarget))
			mg42 thread autoTarget(getentarray(mg42.target,"targetname"));
	}

	restoreDefaults();
}

restoreDefaults()
{
	self.maxdist = 500;
	self.fightdist = 320;
	self.goalradius = 350;
	self.run_noncombatanim = undefined;
	self.run_combatanim = undefined;
	self setexceptions(animscripts\init::empty);
}

restorePitch()
{
	self waittill ("turret_deactivate");
	self restoredefaultdroppitch();
}

roamingReinforcements()
{
	ent = spawnstruct();
	triggers = getentarray ("roaming_reinforcement","targetname");
 	array_thread(triggers, ::roaming_trigger, ent);
 	ent thread roaming_newTrigger();
 	ent thread roaming_stopTriggerent();
 	for (;;)
 	{
 		if (isdefined (ent.trigger))
 		{
		 	if (getaiarray("allies").size < 5)
		 		getent (ent.trigger.target,"targetname") notify ("spawn_friendlies");
	 	}
		wait (2);
 	}
}

roaming_newTrigger()
{
	for (;;)
	{
	 	self waittill ("player_touch", trigger);
	 	if (level.player istouching (getent(trigger.target,"targetname")))
	 	{
	 		// Player is touching the antitrigger, so dont spawn.
			wait (1);		
	 		continue;
	 	}
	 		
	 	if (!isdefined (self.trigger))
	 		self.trigger = trigger;
	 	
	 	if (self.trigger != trigger)
 		{
 			self.lastTrigger = self.trigger;
 			self.trigger = trigger;
		}

		wait (2);		
	}
}

roaming_stopTriggerent()
{
	for (;;)
	{
	 	self waittill ("trigger_stop", trigger);
	 	if (!isdefined(self.trigger))
	 	{
	 		wait (2);
	 		continue;
	 	}
	 	if (self.trigger == trigger)
 		{
 			if (isdefined(self.lastTrigger))
 			{
 				if (self.lastTrigger != trigger)
		 			self.trigger = self.lastTrigger;
	 		}
	 		else
	 			self.lastTrigger = trigger;
	 			
			self.trigger = undefined;
		}

		wait (2);		
	}
}

roaming_trigger(ent)
{
	getent(self.target,"targetname") thread roaming_stoptrigger(ent, self);
	for (;;)
	{
		self waittill ("trigger");
		ent notify ("player_touch", self);
		wait (1);
	}
}

roaming_stoptrigger(ent, trigger)
{
	self thread roaming_spawn();
	for (;;)
	{
		self waittill ("trigger");
		ent notify ("trigger_stop", trigger);
		wait (1);
	}
}

roaming_spawn()
{
	spawners = getentarray (self.target,"targetname");
	for (i=0;i<spawners.size;i++)
		spawners[i].triggerUnlocked = true;
	for (;;)
	{
		self waittill ("spawn_friendlies");
		array_thread(spawners,::spawnWaypointFriendlies);
	}
}

spawnWaypointFriendlies()
{
	self.count = 1;
	spawn = self dospawn();
	if (spawn_failed(spawn))
		return;
	spawn.friendlyWaypoint = true;
}

// Newvillers global stuff:

waittillDeathOrLeaveSquad()
{
	self endon ("death");
	self waittill ("leaveSquad");
}
	

friendlySpawnWave()
{
	/*
		Triggers a spawn point for incoming friendlies.
	
		trigger targetname friendly_spawn
		Targets a trigger or triggers. The targetted trigger targets a script origin.
		Touching the friendly_spawn trigger enables the targetted trigger.
		Touching the enabled trigger causes friendlies to spawn from the targetted script origin.
		Touching the original trigger again stops the friendlies from spawning.
		The script origin may target an additional trigger that halts spawning.
		Make friendly spawn spot sparkle
	*/
	
	/#
	triggers = getentarray(self.target, "targetname");
	for (i=0;i<triggers.size;i++)
	{
		if (triggers[i] getentnum() == 526)
			println ("Target: " + triggers[i].target);
	}
	#/
	array_thread(getentarray(self.target,"targetname"), ::friendlySpawnWave_triggerThink, self);
	for (;;)
	{
		self waittill ("trigger", other);
		// If we're the current friendly spawn spot then stop friendly spawning because
		// the player is backtracking
		if (activeFriendlySpawn() && getFriendlySpawnTrigger() == self)
			unsetFriendlySpawn();

		self waittill ("friendly_wave_start", startPoint);
		setFriendlySpawn(startPoint, self);
		
		
		// If the startpoint targets a trigger, that trigger can
		// disable the startpoint too
		if (!isdefined (startPoint.target))
			continue;
		trigger = getent (startPoint.target,"targetname");
		trigger thread spawnWaveStopTrigger(self);
	}
}



flood_and_secure(instantRespawn)
{
	/*
		Spawns AI that run to a spot then get a big goal radius. They stop spawning when auto delete kicks in, then start
		again when they are retriggered or the player gets close.
	
		trigger targetname flood_and_secure
		ai spawn and run to goal with small goalradius then get large goalradius
		spawner starts with a notify from any flood_and_secure trigger that triggers it
		spawner stops when an AI from it is deleted to make space for a new AI or when count is depleted
		spawners with count of 1 only make 1 guy.
		Spawners with count of more than 1 only deplete in count when the player kills the AI.
		spawner can target another spawner. When first spawner's ai dies from death (not deletion), second spawner activates.
	*/

	// Instantrespawn disables wave respawning or waiting for time to pass before respawning
	if (!isdefined(instantRespawn))
		instantRespawn = false;

	level.spawnerWave = [];
	spawners = getentarray(self.target, "targetname");
	array_thread (spawners, ::flood_and_secure_spawner, instantRespawn);
	
	playerTriggered = false;
	
		
	for (;;)
	{
		self waittill ("trigger", other);
		if (!objectiveIsAllowed())
			continue;
			
		if (self isTouching(level.player))
			playerTriggered = true;
		else
		{
			if (!isalive(other))
				continue;
			if (other == level.player)
				playerTriggered = true;
			else
			if (!isdefined(other.isSquad) || !other.isSquad)
			{
				// Non squad AI are not allowed to spawn enemies
				continue;
			}
		}
		
		// Reacquire spawners in case one has died/been deleted and moved up to another
		// because spawners can target other spawners that are used when the first spawner dies.
		spawners = getentarray(self.target, "targetname");
		for (i=0;i<spawners.size;i++)
		{
			spawners[i].playerTriggered = playerTriggered;
			spawners[i] notify ("flood_begin");
		}
			
		if (playerTriggered)
			wait (5);
		else
			wait (0.1);
	}
}

flood_and_secure_spawner(instantRespawn)
{
	if (isdefined(self.secureStarted))
	{
		// Multiple triggers can trigger a flood and secure spawner, but they need to run
		// their logic just once so we exit out if its already running.
		return;
	}

	self.secureStarted = true;
	self.triggerUnlocked = true; // So we don't run auto targetting behavior
	
	mg42 = issubstr(self.classname, "mg42") || issubstr(self.classname, "30cal");
	if (!mg42)
	{
		// So we don't go script error'ing or whatnot off auto spawn logic
		// Unless we're an mg42 guy that has to set an mg42 up.
		self.script_moveoverride = true; 
	}
	
	target = self.target;
	targetname = self.targetname;
	if (!isdefined(target))
	{
		println ("Entity " + self.classname + " at origin " + self.origin + " has no target");
		waittillframeend;
		assert (isdefined(target));
	}

	// follow up spawners
	possibleSpawners = getentarray(target, "targetname");
	spawners = [];	
	for (i=0;i<possibleSpawners.size;i++)
	{
		if (!issubstr(possibleSpawners[i].classname, "actor"))
			continue;

//		possibleSpawners[i] thread deathChainFallback();
		spawners[spawners.size] = possibleSpawners[i];
	}
	
	ent = spawnstruct();
	org = self.origin;
	flood_and_secure_spawner_think(mg42, ent, spawners.size > 0, instantRespawn);
	if (isalive(ent.ai))
		ent.ai waittill ("death");
	
	
	// follow up spawners
	possibleSpawners = getentarray(target, "targetname");
	if (!possibleSpawners.size)
		return;

	for (i=0;i<possibleSpawners.size;i++)
	{
		if (!issubstr(possibleSpawners[i].classname, "actor"))
			continue;

		possibleSpawners[i].targetname = targetname;
		newTarget = target;
		if (isdefined (possibleSpawners[i].target))
		{
			targetEnt = getent(possibleSpawners[i].target,"targetname");
			if (!isdefined(targetEnt) || !issubstr(targetEnt.classname, "actor"))
				newTarget = possibleSpawners[i].target;
		}

		// The guy might already be targetting a different destination
		// But if not, he goes to the node his parent went to. 
		possibleSpawners[i].target = newTarget;
			
		possibleSpawners[i] thread flood_and_secure_spawner(instantRespawn);

		// Pass playertriggered flag as true because at this point the player must have been involved because one shots dont
		// spawn without the player triggering and multishot guys require player kills or presense to move along
		possibleSpawners[i].playerTriggered = true;
		possibleSpawners[i] notify ("flood_begin"); 
	}
}

flood_and_secure_spawner_think(mg42, ent, oneShot, instantRespawn)
{
	assert(isdefined(instantRespawn));
	self endon ("death");
	count = self.count;
	//oneShot = (count == 1);
	if (!oneShot)
		oneshot = (isdefined (self.script_noteworthy) && self.script_noteworthy == "delete");
	self.count = 2; // running out of count counts as a dead spawner to script_deathchain

	if (isdefined(self.script_delay))
		delay = self.script_delay;
	else
		delay = 0;
	
	for (;;)
	{
		self waittill ("flood_begin");
		if (self.playerTriggered)
			break;
/*			
		// Lets let AI spawn oneshots!
		// Oneshots require player triggering to activate
		if (oneShot)
			continue;
*/
		// guys that have a delay require triggering from the player 	
		if (delay)
			continue;
		break;
	}

	dist = distance(level.player.origin, self.origin);

	while (count)
	{
		self.trueCount = count;
		self.count = 2;
		wait (delay);
		if (isdefined(self.script_forcespawn))
			spawn = self stalingradspawn();
		else
			spawn = self dospawn();
			
		if (spawn_failed(spawn))
		{
			playerKill = false;
			if (delay < 2)
				wait (2); // debounce 
			continue;
		}
		else
		{
			thread addToWaveSpawner(spawn);
			spawn thread flood_and_secure_spawn(self, mg42);
			ent.ai = spawn;
			ent notify ("got_ai");
			self waittill ("spawn_died", deleted, playerKill);
			if (delay > 2)
				delay = randomint(4) + 2; // first delay can be long, after that its always a set amount.		
			else
				delay = 0.5 + randomfloat (0.5);
		}

		if (deleted)
		{
			// Deletion indicates that we've hit the max AI limit and this is the oldest/farthest AI
			// so we need to stop this spawner until it gets triggered again or the player gets close
			
			waittillRestartOrDistance(dist);
		}
		else
		{
			/*
			// Only player kills count towards the count unless the spawner only has a count of 1
			// or NOT
			if (playerKill || oneShot)
			*/
			if (playerWasNearby(playerKill || oneShot, ent.ai))
				count--;
			if (!instantRespawn)
				waitUntilWaveRelease();
		}
	}
	
	self delete();
}

waittillDeletedOrDeath(spawn)
{
	self endon ("death");
	spawn waittill ("death");
}

addToWaveSpawner(spawn)
{
	name = self.targetname;
	if (!isdefined(level.spawnerWave[name]))
	{
		level.spawnerWave[name] = spawnStruct();
		level.spawnerWave[name].count = 0;
		level.spawnerWave[name].total = 0;
	}
	
	if (!isdefined (self.addedToWave))
	{
		self.addedToWave = true;
		level.spawnerWave[name].total++;
	}

	level.spawnerWave[name].count++;
	/*
	/#
	if (level.debug_corevillers)
		thread debugWaveCount(level.spawnerWave[name]);
	#/
	*/
	waittillDeletedOrDeath(spawn);
	level.spawnerWave[name].count--;
	if (!isdefined (self))
		level.spawnerWave[name].total--;

	/*
	/#
	if (isdefined (self))
	{
		if (level.debug_corevillers)
			self notify ("debug_stop");
	}
	#/
	*/
	
//	if (!level.spawnerWave[name].count)
	// Spawn the next wave if 68% of the AI from the wave are dead.
	if (level.spawnerWave[name].total)
	{
		if (level.spawnerWave[name].count / level.spawnerWave[name].total < 0.32)
			level.spawnerWave[name] notify ("waveReady");
	}
}

debugWaveCount(ent)
{
	self endon ("debug_stop");
	self endon ("death");
	for (;;)
	{
		print3d(self.origin, ent.count + "/" + ent.total, (0, 0.8, 1), 0.5);
		wait (0.05);
	}
}


waitUntilWaveRelease()
{
	name = self.targetName;
	if (level.spawnerWave[name].count)
		level.spawnerWave[name] waittill ("waveReady");
}


playerWasNearby(playerKill, ai)
{
	if (playerKill)
		return true;
	if (isdefined(ai) && isdefined(ai.origin))
		org = ai.origin;
	else
		org = self.origin;
	if (distance(level.player.origin, org) < 700)
		return true;

//	/#thread animscripts\utility::debugLine(level.player.origin, org, (0,1,0), 20);#/

	return bulletTracePassed(level.player geteye(), ai geteye(), false, undefined);
}

waittillRestartOrDistance(dist)
{
	self endon ("flood_begin");
	
	dist = dist * 0.75; // require the player to get a bit closer to force restart the spawner
	
	while (distance(level.player.origin, self.origin) > dist)
		wait (1);
}

flood_and_secure_spawn (spawner, mg42)
{
	if (!mg42)
		self thread flood_and_secure_spawn_goal();
	self waittill ("death", other);

	playerKill = isalive(other) && other == level.player;
	if (!playerkill && isdefined(other) && other.classname == "worldspawn") // OR THE WORLDSPAWN???
		playerKill = true;
	deleted = !isdefined(self);

	spawner notify ("spawn_died", deleted, playerKill);
}

flood_and_secure_spawn_goal()
{
	self endon ("death");
	node = getnode(self.target,"targetname");
	self setgoalnode(node);

	if (isdefined(self.script_deathChain))
		self setgoalvolume(level.goalVolume[self.script_deathChain]);
	
	if (isdefined (level.fightdist))
	{
		self.pathenemyfightdist = level.fightdist;
		self.pathenemylookahead = level.maxdist;
	}
	
	if (node.radius)
		self.goalradius = node.radius;
	else
		self.goalradius = 64;
		
	self waittill ("goal");
	
	while (isdefined(node.target))
	{
		newNode = getnode(node.target,"targetname");
		if (isdefined(newNode))
			node = newNode;
		else
			break;
			
		self setgoalnode(node);
			
		if (node.radius)
			self.goalradius = node.radius;
		else
			self.goalradius = 64;
			
		self waittill ("goal");
	}
	
	
	if (isdefined (self.script_noteworthy))
	{
		if (self.script_noteworthy == "delete")
		{
//			self delete();
			// Do damage instead of delete so he counts as "killed" and we dont have to write 
			// stuff to let the spawner know to stop trying to spawn him.
			self dodamage( (self.health *0.5), (0,0,0) );
			return;
		}
	}
	
	if (isdefined(node.target))
	{
		turret = getent (node.target, "targetname");
		if ((isdefined (turret)) && ((turret.classname == "misc_mg42") || (turret.classname == "misc_turret")))
		{
			self setgoalnode(node);
			self.goalradius = (4);
			self waittill ("goal");
			if (!isdefined (self.script_forcegoal))
				self.goalradius = 2000;
			self maps\_spawner::use_a_turret (turret);
		}
	}

	if (isdefined (self.script_noteworthy))
	{
		if (isdefined (self.script_noteworthy2))
		{
			if (self.script_noteworthy2 == "furniture_push")
				thread furniturePushSound();
		}

		if (self.script_noteworthy == "hide")
		{
			self thread setBattleChatter(false);
			return;
		}
	}
	
	if (!isdefined (self.script_forcegoal))
	{
		self.goalradius = 2000;
		if (self.script_displaceable != 0) // 0 means explicitly told not to do displace behavior
			self.script_displaceable = 1;
	}
}

furniturePushSound()
{
	org = getent(self.target,"targetname").origin;
	playSoundinSpace ("furniture_slide", org);
	wait (0.9);
	if (isdefined(level.whisper))
		playSoundinSpace (random(level.whisper), org);
		
}


friendlychain()
{
	/*
		Selectively enable and disable friendly chains with triggers

		trigger targetname friendlychain
		Targets a trigger. When the player hits the friendly chain trigger it enables the targetted trigger.
		When the player hits the enabled trigger, it activates the friendly chain of nodes that it targets.
		If the enabled trigger links to a "friendy_spawn" trigger, it enables that friendly_spawn trigger.
	*/
	waittillframeend;
	triggers = getentarray(self.target,"targetname");
	if (!triggers.size)
	{
		// trigger targets chain directly, has no direction
		node = getnode (self.target,"targetname");
		assert(isdefined(node));
	assert(isdefined(node.script_noteworthy));
		for (;;)
		{
			self waittill ("trigger");
			if (isdefined (level.lastFriendlyTrigger) && level.lastFriendlyTrigger == self)
			{
				wait (0.5);
				continue;
			}

			if (!objectiveIsAllowed())
			{
				wait (0.5);
				continue;
			}

			level notify ("new_friendly_trigger");
			level.lastFriendlyTrigger = self;
			
			rejoin = !isdefined(self.script_baseOfFire) || self.script_baseOfFire == 0;
			setNewPlayerChain(node, rejoin);
		}
	}
	
	/#
	for (i=0;i<triggers.size;i++)
	{
		node = getnode(triggers[i].target,"targetname");
		assert(isdefined(node));
		assert(isdefined(node.script_noteworthy));
	}
	#/
	
	for (;;)
	{
		self waittill ("trigger");
//		if (level.currentObjective != self.script_noteworthy2)
		while (level.player istouching (self))
			wait (0.05);

		if (!objectiveIsAllowed())
		{
			wait (0.05);
			continue;
		}
				
		if (isdefined (level.lastFriendlyTrigger) && level.lastFriendlyTrigger == self)
			continue;

		level notify ("new_friendly_trigger");
		level.lastFriendlyTrigger = self;

		array_thread(triggers, ::friendlyTrigger);
		wait (0.5);
	}
}

objectiveIsAllowed()
{
	active = true;
	if (isdefined(self.script_objective_active))
	{
		active = false;
		// objective must be active for this trigger to hit
		for (i=0;i<level.active_objective.size;i++)
		{
			if (!issubstr(self.script_objective_active, level.active_objective[i]))
				continue;
			active = true;
			break;
		}

		if (!active)				
			return false;
	}

	if (!isdefined(self.script_objective_inactive))
		return (active);

	// trigger only hits if this objective is inactive
	inactive = 0;
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (!issubstr(self.script_objective_inactive, level.inactive_objective[i]))
			continue;
		inactive++;
	}
	
	tokens = strtok( self.script_objective_inactive, " " );
	return (inactive == tokens.size);
}

friendlyTrigger(node)
{
	level endon ("new_friendly_trigger");
	self waittill ("trigger");
	node = getnode(self.target,"targetname");
	rejoin = !isdefined(self.script_baseOfFire) || self.script_baseOfFire == 0;
	setNewPlayerChain(node, rejoin);
}



waittillDeathOrEmpty()
{
	self endon ("death");
	num = self.script_deathChain;
	while (self.count)
	{
		self waittill ("spawned",spawn);
		spawn thread deathChainAINotify(num);
	}
}

spawnerDot()
{
	/*
	if (!level.debug_corevillers)
		return;
	org = self.origin;
 	level endon ("spawner dot" + org);
	for (;;)
	{
		print3d(org, ".", (1,0,0), 1, 1.2);
		wait (0.05);
	}
	*/
}
	
	

deathChainAINotify(num)
{
	level.deathSpawner[num]++;
	self waittill ("death");
	level.deathSpawner[num]--;
	level notify ("spawner_expired" + num);
}


deathChainSpawnerLogic()
{
	num = self.script_deathChain;
	level.deathSpawner[num]++;
	/#
	level.deathSpawnerEnts[num][level.deathSpawnerEnts[num].size] = self;
	#/

	org = self.origin;
	thread spawnerDot();
	self waittillDeathOrEmpty();
	/#
	newDeathSpawners = [];
	if (isdefined(self))
	{
		for (i=0;i<level.deathSpawnerEnts[num].size;i++)
		{
			if (!isdefined(level.deathSpawnerEnts[num][i]))
				continue;

			if (self == level.deathSpawnerEnts[num][i])
				continue;
			newDeathSpawners[newDeathSpawners.size] = level.deathSpawnerEnts[num][i];
		}
	}
	else
	{
		for (i=0;i<level.deathSpawnerEnts[num].size;i++)
		{
			if (!isdefined(level.deathSpawnerEnts[num][i]))
				continue;
			newDeathSpawners[newDeathSpawners.size] = level.deathSpawnerEnts[num][i];
		}
	}
	
	level.deathSpawnerEnts[num] = newDeathSpawners;
	#/
 	level notify ("spawner dot" + org);
	level.deathSpawner[num]--;
	level notify ("spawner_expired" + num);
}

friendlychain_onDeath()
{
	/*
		Enables a friendly chain when certain AI are cleared
		
		trigger targetname friendly_chain_on_death
		trigger is script_deathchain grouped with spawners
		When the spawners have depleted and all their ai are dead:
			the triggers become active.
		When triggered they set the friendly chain to the chain they target
		The triggers deactivate when a "friendlychain" targetnamed trigger is hit.
	*/
	triggers = getentarray("friendly_chain_on_death","targetname");
	spawners = getspawnerarray();
	level.deathSpawner = [];
	/#
	// for debugging deathspawners
	level.deathSpawnerEnts = [];
	#/
	for (i=0;i<spawners.size;i++)
	{
		if (!isdefined(spawners[i].script_deathchain))
			continue;
		
		num = spawners[i].script_deathchain;
		if (!isdefined(level.deathSpawner[num]))
		{
			level.deathSpawner[num] = 0;
			/#
			level.deathSpawnerEnts[num] = [];
			#/
		}

		spawners[i] thread deathChainSpawnerLogic();
//		level.deathSpawner[num]++;
	}
	
	for (i=0;i<triggers.size;i++)
	{
		if (!isdefined(triggers[i].script_deathchain))
		{
			println ("trigger at origin " + triggers[i] getorigin() + " has no script_deathchain");
			return;
		}
		
		triggers[i] thread friendlyChain_onDeathThink();
	}
}

friendlyChain_onDeathThink()
{
	while (level.deathSpawner[self.script_deathChain] > 0)
		level waittill ("spawner_expired" + self.script_deathChain);

	level endon ("start_chain");
	node = getnode (self.target, "targetname");
	for (;;)
	{
		self waittill ("trigger");
		setNewPlayerChain(node, true);
		iprintlnbold ("Area secured, move up!");
		wait (5); // debounce
	}
}

setNewPlayerChain(node, rejoin)
{
	level.player setFriendlyChainWrapper(node);
	level notify ("new_escort_trigger"); // stops escorting guy from getting back on escort chain 
	level notify ("new_escort_debug");
	level notify ("start_chain", rejoin); // get the SMG guy back on the friendly chain
}	

escortChain()
{
	/*
		Guides a select friendly SMG guy to use special targetted nodes. Your wingman.
	
		trigger targetname escortchain
		Targets a trigger (or triggers) which targets a node. 
		When the player touches the escortchain trigger, it activates the targetted trigger. 
		When the player touches the activated trigger, it makes the closest friendly with script_noteworthy "smg" move to the node.
		If the targetted node has a radius the AI will use that goalradius, otherwise they'll use goalradius 64.
		Friendly returns to friendly chains the next time a "friendlychain" is touched, unless the friendychain has 

		script_baseoffire set to true.
	*/
	
	if (!isdefined(self.target))
	{
		println ("escortchain at " + self getorigin() + " has no target");
		return;
	}
	array_thread (getentarray(self.target,"targetname"), ::escortChainTriggerThink, self);	
		
	for (;;)
	{
		self waittill ("trigger");
		if (!objectiveIsAllowed())
		{
			wait (1);
			continue;
		}
		handleEscortTriggers_untilNewChainIsTriggered();
	}
}

escortChainDebug()
{
	thread debugPrint("E-T","new_escort_debug");	
}


handleEscortTriggers_untilNewChainIsTriggered()
{
	level notify ("new_escort_trigger");
	level endon ("new_escort_trigger");
	level notify ("new_escort_debug");
	thread debugPrint("E-S","new_escort_debug");
	array_thread (getentarray(self.target,"targetname"), ::escortChainDebug);	
	
	for (;;)
	{	
		self waittill ("escort_trigger", node);
		level notify ("new_escort_debug");
		array_thread (getentarray(self.target,"targetname"), ::escortChainDebug);	
		level.smgNode = node;

		if (isalive(level.smgGuy))
			level.smgGuy notify ("new_node");
		else
		{
			smgGuy = getClosestLiving(level.player.origin, getentarray("smgguy","script_noteworthy"));
			if (isalive(smgGuy))
				smgGuy thread setSmgGuy();
		}
	}
}

escortChainTriggerThink(startTrigger)
{
	/*
		trigger targetname escortchain_instant
		This works the same way as escortchain except it targets a node, not a trigger, and the moment you touch the trigger the 

		SMG AI moves to the node.
	*/
	node = getnode(self.target,"targetname");
	for (;;)
	{
		self waittill ("trigger");
		startTrigger notify ("escort_trigger", node);
		wait (0.05);
		self notify ("new_color");
		thread debugPrint("E-T","new_escort_debug", (1,0,0));	
		wait (2); // debounce
	}
}


escortChainInstant()
{
	node = getnode(self.target,"targetname");
		
	for (;;)
	{
		self waittill ("trigger");
		level.smgNode = node;

		if (isalive(level.smgGuy))
			level.smgGuy notify ("new_node");
		else
		{
			smgGuy = getClosestLiving(level.player.origin, getentarray("smgguy","script_noteworthy"));
			if (isdefined(smgGuy))
				smgGuy thread setSmgGuy();
		}
	}
}

gotoSmgNode()
{
	self setgoalnode (level.smgNode);
	if (!level.smgNode.radius)
		self.goalradius = 64;
	else
		self.goalradius = level.smgNode.radius;
}

setSmgGuy()
{
	// lower threatbias on smg guy cause he needs to get where he's going so the player can see him
	self.threatbias = -150;
	level.smgGuy = self;
	level notify ("set_smgguy", level.smgGuy);
	gotoSmgNode();
	
	self endon ("death");
	self endon ("rejoined_chain");
	
	// If the player gets on a new friendly chain then this guy goes back to the chainn
	thread smgGuyRejoinsChain();
	for (;;)
	{
		self waittill ("new_node");
		gotoSmgNode();
	}
}

smgGuyRejoinsChain()
{
	self endon ("death");
	for (;;)
	{
		level waittill ("start_chain", rejoin);
		// Only rejoin the friendly chain if the friendly chain wants rejoining
		// otherwise the squad is probably setting up base of fire while this ai
		// moves with the player
		if (!rejoin)
			continue;
		self setgoalentity (level.player);
		level.smgNode = undefined;
		level.smgGuy = undefined;
		self notify ("rejoined_chain");
	}
}

squadRespawnThink()
{
	if (self.script_noteworthy == "smgguy")
	{
		self.followMin = 5;
		self.followMax = 10;
	}
	else
	{
		self.followMin = -10;
		
		self.followMax = -5;
	}

	flag_wait ("friendly_wave_spawn_enabled");
		
	spawner = random(level.friendly_spawner[self.script_noteworthy]);
	self.fightdist = level.fightdist;
	self.maxdist = level.maxdist;
	self.health = 150;
	waittillDeathOrLeaveSquad();
	if (isdefined(self))
	{
		self.isSquad = false;
		self notify ("leftSquad");
		self.targetname = "notSquad";
	}

	for (;;)
	{
		flag_wait("spawning_friendlies");
		flag_wait ("friendly_wave_spawn_enabled");
		spawner.origin = getFriendlySpawnStart();
		spawner.count = 1;
		spawn = spawner dospawn();
		if (spawn_failed(spawn))
		{
			wait (0.5 + randomfloat(1));
			continue;
		}
		break;
	}
	
	spawn setgoalpos (level.player.origin);
	spawn.goalradius = 512;
	// do it before we might make the guy an smg guy cause then he'd go elsewhere

	isSmgGuy = (spawner.script_noteworthy == "smg_spawner");
	if (isSmgGuy)
	{
		spawn.script_noteworthy = "smgguy";
		spawn.threatbias = -50;
		if (isdefined(level.smgNode) && !isalive(level.smgGuy))
		{
			// There is an SMGnode specified but no current SMG guys so find a new smg guy
			smgGuy = getClosestLiving(level.player.origin, getentarray("smgguy","script_noteworthy"));
			if (isalive(smgGuy))
				smgGuy thread setSmgGuy();
		}

		if (!isalive(level.smgGuy) || spawn != level.smgGuy)
			spawn thread delayedPlayerGoal();
	}
	else
	{
		spawn.script_noteworthy = "rifleguy";
		spawn thread delayedPlayerGoal();
	}

	spawn.isSquad = true;
	spawn thread squadRespawnThink();
}


friendlyChains()
{
	level.friendlySpawnOrg = [];
	level.friendlySpawnTrigger = [];	
	array_thread (getentarray("friendlychain", "targetname"), ::friendlychain);
}

unsetFriendlySpawn()
{
	newOrg = [];
	newTrig = [];
	for (i=0;i<level.friendlySpawnOrg.size;i++)
	{
		newOrg[newOrg.size] = level.friendlySpawnOrg[i];
		newTrig[newTrig.size] = level.friendlySpawnTrigger[i];
	}
	level.friendlySpawnOrg = newOrg;
	level.friendlySpawnTrigger = newTrig;
	
	if (activeFriendlySpawn())
		return;

	// If we've stepped back through all the spawners then turn off spawning
	flag_Clear ("spawning_friendlies");
}

getFriendlySpawnStart()
{
	assert (level.friendlySpawnOrg.size > 0);
	return (level.friendlySpawnOrg[level.friendlySpawnOrg.size-1]);
}

activeFriendlySpawn()
{
	return level.friendlySpawnOrg.size > 0;
}
	
getFriendlySpawnTrigger()
{
	assert (level.friendlySpawnTrigger.size > 0);
	return (level.friendlySpawnTrigger[level.friendlySpawnTrigger.size-1]);
}

setFriendlySpawn(org, trigger)
{
	level.friendlySpawnOrg[level.friendlySpawnOrg.size] = org.origin;
	level.friendlySpawnTrigger[level.friendlySpawnTrigger.size] = trigger;
	flag_set ("spawning_friendlies");
}

delayedPlayerGoal()
{
	self endon ("death");
	self endon ("leaveSquad");
	wait (0.5);
	self setgoalentity (level.player);
}

spawnWaveStopTrigger(startTrigger)
{
	self notify ("stopTrigger");
	self endon ("stopTrigger");
	
	self waittill ("trigger");
	if (getFriendlySpawnTrigger() != startTrigger)
		return;

	unsetFriendlySpawn();		
}

friendlySpawnWave_triggerThink(startTrigger)
{
	org = getent(self.target,"targetname");
//	thread linedraw();
	
	for (;;)
	{
		self waittill ("trigger");
		startTrigger notify ("friendly_wave_start", org);
		if (!isdefined(org.target))
			continue;
	}
}


goalVolumes()
{
	volumes = getentarray("info_volume","classname");
	for (i=0;i<volumes.size;i++)
	{
		if (!isdefined (volumes[i].script_deathChain))
			continue;
		level.goalVolume[volumes[i].script_deathChain] = volumes[i];
	}
}

debugPrint(msg, endonmsg, color)
{
//	if (!level.debug_corevillers)
	if (1)
		return;

	org = self getorigin();
	height = 40 * sin(org[0] + org[1]) - 40;
	org = (org[0], org[1], org[2] + height);
	level endon (endonmsg);
	self endon ("new_color");
	if (!isdefined (color))
		color = (0,0.8,0.6);
	num = 0;
	for (;;)
	{
		num+= 12;
		scale = sin(num) * 0.4;
		if (scale < 0)
			scale *= -1;
		scale += 1;
		print3d(org, msg, color, 1, scale);
		wait (0.05);
	}
}

squadThink()
{
	self.isSquad = true;
	self thread squadRespawnThink();
	self endon ("death");
	self endon ("leftSquad");
	wait (1);
	self setgoalentity (level.player);
}

aigroup_create( aigroup )
{
	level._ai_group[aigroup] = spawnstruct();
	level._ai_group[aigroup].aicount = 0;
	level._ai_group[aigroup].spawnercount = 0;
	level._ai_group[aigroup].ai = [];
	level._ai_group[aigroup].spawners = [];
}

aigroup_spawnerthink( tracker )
{
	self endon ( "death" );

	self.decremented = false;
	tracker.spawnercount++;

	self thread aigroup_spawnerdeath( tracker );
	self thread aigroup_spawnerempty( tracker );
	
	while ( self.count )
	{
		self waittill ( "spawned", soldier );
		
		if ( spawn_failed( soldier ) )
			continue;
		
		soldier thread aigroup_soldierthink( tracker );
	}
	waittillframeend;
	
	if ( self.decremented )
		return;

	self.decremented = true;
	tracker.spawnercount--;
}

aigroup_spawnerdeath( tracker )
{
	self waittill ( "death" );

	if ( self.decremented )
		return;

	tracker.spawnercount--;
}

aigroup_spawnerempty( tracker )
{
	self endon ( "death" );
	
	self waittill ( "emptied spawner" );

	waittillframeend;
	if ( self.decremented )
		return;

	self.decremented = true;
	tracker.spawnercount--;
}

aigroup_soldierthink( tracker )
{
	tracker.aicount++;
	tracker.ai[tracker.ai.size] = self;
	self waittill ( "death" );
	
	tracker.aicount--;
}

deleteonpathend_think()
{
	self endon ( "death" );

	self waittill ( "reached_path_end" );			
	self delete();
}


initScriptColors(nodes)
{
	wait(0.05); // begone infinite hangs
	level.scriptColors = [];
	triggers = [];
	triggers = array_combine(triggers,  getentarray("trigger_multiple"	,"classname"));
	triggers = array_combine(triggers,  getentarray("trigger_radius"	,"classname"));

	// assign the triggers their nodes	
	for (i=0;i<triggers.size;i++)
	{
		if (!isdefined(triggers[i].script_color))
			continue;
		triggers[i] thread triggerColorThink();
	}

	// go through all the nodes and if they have script_color then add them to 	
	for (i=0;i<nodes.size;i++)
	{
		if (!isdefined(nodes[i].script_color))
			continue;
		nodes[i].color_users = 0;
		assertEx (nodes[i].radius > 0, "Node " + nodes[i].type + " at origin " + nodes[i].origin + " does not have a radius set in Radiant.");
		colors = strtok( nodes[i].script_color, " " );
		for (p=0;p<colors.size;p++)
		{
			if (!isdefined (level.scriptColors[colors[p]]))
			{
				level.scriptColors[colors[p]][0] = nodes[i];
				level.ai_scriptColors[colors[p]] = [];
				level.spawner_scriptColors[colors[p]] = [];
			}
			else
				level.scriptColors[colors[p]][level.scriptColors[colors[p]].size] = nodes[i];
		}
	}
	
	level.ai_scriptColorsForced["red"]		= [];
	level.ai_scriptColorsForced["blue"]		= [];
	level.ai_scriptColorsForced["yellow"]	= [];
	level.ai_scriptColorsForced["cyan"]		= [];
	level.ai_scriptColorsForced["green"]	= [];
	level.ai_scriptColorsForced["purple"]	= [];
	level.ai_scriptColorsForced["orange"]	= [];
	
	array_thread (getaiarray(), ::aiSetScriptColors);
	array_thread (getspawnerarray(), ::spawnerSetScriptColors);
}

aiSetScriptColors(currentColorIndex)
{
	if (isdefined(self.script_forcecolor))
	{
		self.currentColorIndex = currentColorIndex;
		color = self.script_forcecolor;
		assert(colorIsLegit(color), "AI at origin " + self.origin + " has non-legit forced color " + color + ". Legit colors are red blue yellow cyan green purple and orange.");
		level.ai_scriptColorsForced[color] = array_add(level.ai_scriptColorsForced[color], self);
		thread gotocurrentColorIndex();
		return;
	}
	
	if (!isdefined(self.script_color))
		return;
	colors = strtok( self.script_color, " " );
	for (i=0;i<colors.size;i++)
	{
		self.currentColorIndex = currentColorIndex;
		assertEx (isdefined(level.ai_scriptColors[colors[i]]), "AI at origin " + self.origin + " has script_color " + colors[i] + " which does not exist on any nodes");
		level.ai_scriptColors[colors[i]] = array_add(level.ai_scriptColors[colors[i]], self);
		thread gotocurrentColorIndex();
	}
}

gotocurrentColorIndex(currentColorIndex)
{
	if (!isdefined(self.currentColorIndex))
		return;
	
	nodes = level.scriptColors[currentColorIndex];
	current_users = 0;
	for (;;)
	{
		for (i=0;i<nodes.size;i++)
		{
			if (nodes[i].current_users > current_users)
				continue;
			self setgoalnode(nodes[i]);
			self.goalradius = nodes[i].radius;
			thread decrementColorUsers(nodes[i]);
			return;
		}
		current_users++;
	}
	
}

spawnerSetScriptColors()
{
	if (!isdefined(self.script_forcecolor) && !isdefined(self.script_color))
		return;
	self endon ("death");
	self.currentColorIndex = undefined;

	colors = strtok( self.script_color, " " );
	for (i=0;i<colors.size;i++)
		level.spawner_scriptColors[colors[i]] = array_add(level.spawner_scriptColors[colors[i]], self);
	
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (spawn_failed(spawn))
			continue;
		spawn thread aiSetScriptColors(self.currentColorIndex);
	}
}

triggerColorThink()
{
	self endon ("death");
	colorIndices = strtok( self.script_color, " " );
	colors = [];
	for (i=0;i<colorIndices.size;i++)
	{
		color = undefined;
		if (issubstr(colorIndices[i], "red"))
			color = "red";
		else
		if (issubstr(colorIndices[i], "blue"))
			color = "blue";
		else
		if (issubstr(colorIndices[i], "yellow"))
			color = "yellow";
		else
		if (issubstr(colorIndices[i], "cyan"))
			color = "cyan";
		else
		if (issubstr(colorIndices[i], "green"))
			color = "green";
		else
		if (issubstr(colorIndices[i], "purple"))
			color = "purple";
		else
		if (issubstr(colorIndices[i], "orange"))
			color = "orange";
		else
			assertEx(0, "Trigger at origin " + self getorigin() + " had strange color index " + colorIndices[i]);
		colors[colors.size] = color;
		
	}
	
	assert(colors.size == colorIndices.size);
	
	for (;;)
	{
		self waittill ("trigger");
		waittillframeend; // give spawners activated by this trigger a chance to spawn their AI
		// remove all the dead from any colors this trigger effects
		// a trigger should never effect the same color twice
		for (i=0;i<colorIndices.size;i++)
		{
			for (p=0;p<level.spawner_scriptColors[colorIndices[i]].size;p++)
				level.spawner_scriptColors[colorIndices[i]][p].currentColorIndex = colorIndices[i];
		}

		for (i=0;i<colors.size;i++)
			level.ai_scriptColorsForced[colors[i]] = array_removeDead(level.ai_scriptColorsForced[colors[i]]);
		
		for (i=0;i<colorIndices.size;i++)
			thread issueColorOrder(colorIndices[i], colors[i]);
	}
}

issueColorOrder(index, color)
{
	// remove dead from this specific color index
	level.ai_scriptColors[index] = array_removeDead(level.ai_scriptColors[index]);
	ai = level.ai_scriptColors[index];
	ai = array_combine(ai, level.ai_scriptColorsForced[color]);
	newArray = [];
	for (i=0;i<ai.size;i++)
	{
		// ignore AI that are already going to this index
		if (isdefined(ai[i].currentColorIndex) && ai[i].currentColorIndex == index)
			continue;
		newArray[newArray.size] = ai[i];
	}

	ai = newArray;
	if (!ai.size)
		return;

	nodes = level.scriptColors[index];
	nodes = array_randomize(nodes);
	
	color_users = 0;
	for (;;)
	{
		for (i=0;i<nodes.size;i++)
		{
			// add guys to the nodes with the fewest AI on them
			if (nodes[i].color_users > color_users)
				continue;
				
			closestAI = getclosest(nodes[i].origin, ai);
			assert (isalive(closestAI));
			ai = array_remove (ai, closestAI);

			closestAI.currentColorIndex = index;			
			closestAI setgoalnode (nodes[i]);
			closestAI.goalradius = nodes[i].radius;
			setGoal = true;
			closestAI thread decrementColorUsers(nodes[i]);
			if (!ai.size)
				return;
		}
		
		color_users++;
	}
}

decrementColorUsers(node)
{
	node.color_users++;
	self waittill ("death");
	node.color_users--;
}

colorIsLegit(color)
{
	if (color == "red")
		return true;
	if (color == "blue")
		return true;
	if (color == "yellow")
		return true;
	if (color == "cyan")
		return true;
	if (color == "green")
		return true;
	if (color == "purple")
		return true;
	return (color == "orange");
}