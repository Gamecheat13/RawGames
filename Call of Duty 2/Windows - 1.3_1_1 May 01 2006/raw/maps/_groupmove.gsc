#include maps\_utility;
// Issue this command on an array of AI to make them work together to reach the endpos.
main()
{
	/#
	if (getdebugcvar("debug_groupmove_nodes") == "")
		setcvar("debug_groupmove_nodes", "off");
	if (getdebugcvar("debug_astar") == "")
		setcvar("debug_astar", "off");
	if (getdebugcvar("debug_groupmove_nodes") == "on")
		thread showCover();
	if (getcvar ("debug_groupmove_new") == "")
		setcvar("debug_groupmove_new", "off");
	#/

	
//	linkCover(getNodesByPodType("cover"));
	
	thread squadMove_findGroups();
}

squadMove_findGroups()
{
	eSpawners = getspawnerarray();
	groups = [];
	groupNum = [];
	
	for (i=0;i<eSpawners.size;i++)
	{
		if (!isdefined (eSpawners[i].script_squadmove))
			continue;
		
		index = -1;
		squadNum = int(eSpawners[i].script_squadmove);
		for (p=0;p<groups.size;p++)
		{
			if (squadNum != groupNum[p])
				continue;
			
			index = p;
			break;
		}
		
		if (index == -1)
		{
			// new group
			groups[groups.size] = [];
			groupNum[groupNum.size] = squadNum;
			index = groups.size - 1;
		}
		
		groups[index][groups[index].size] = eSpawners[i];
	}

	for (i=0;i<groups.size;i++)
		thread squadMove_groupThink(groups[i]);
}

squadMove_groupThink(spawners)
{
	ent = spawnstruct();
	ent.members = [];
	array_thread(spawners, ::squadMove_spawnerThink, ent);
	ent thread squadMove_makeAIGroupMove();
	for (;;)
	{
		ent waittill ("new_guy_spawned", spawn);
		ent.members[ent.members.size] = spawn;
	}
}

squadMove_makeAIGroupMove()
{
	for (;;)
	{
		self waittill ("new_guy_spawned");
		wait (0.05);
		thread squadMove_makeAIGroupMove_Think(self.members);
		self.members = [];
	}
}

squadMove_makeAIGroupMove_Think(ai)
{
	//get node accociated with this group
	nodes = getallnodes();
	for (i=0;i<nodes.size;i++)
	{
		if (!isdefined (nodes[i].script_squadmove))
			continue;
		if (nodes[i].script_squadmove == ai[0].script_squadmove)
		{
			//get the node that this node targets (throw out the first node)
			gotoNode = getnode (nodes[i].target,"targetname");
			radius = undefined;
			if (nodes[i].radius != 0)
				radius = nodes[i].radius;
				
			if (isdefined (gotoNode.target))
			{
				orgChain = [];
				orgChain[orgChain.size] = gotonode.origin;
				while (isdefined(gotoNode.target))
				{
					gotoNode = getnode(gotoNode.target,"targetname");
					orgChain[orgChain.size] = gotonode.origin;
					if (gotonode.radius != 0)
						radius = gotonode.radius;
				}

				level groupMoveChain (ai, orgChain, radius);
				return;
			}
				
			level groupMove (ai, gotoNode.origin, radius);
			return;
		}
	}
	assertmsg ("spawners at " + ai[0].origin + " with script_squadmove " + ai[0].script_squadmove + " dont have a node grouped with them");
}

squadMove_spawnerThink(ent)
{
	for (;;)
	{
		self waittill ("spawned",spawn);
		if (spawn_failed(spawn))
			continue;
		ent notify ("new_guy_spawned",spawn);
	}
}


getNodesByPodType(type)
{
	AllNodes = getallnodes();
	validNodes = [];
	for (i=0;i<AllNodes.size;i++)
	{
		if ( (isdefined (AllNodes[i].targetname)) && (AllNodes[i].targetname == type) )
			validNodes[validNodes.size] = AllNodes[i];
		else if ( (isdefined (AllNodes[i].script_podtype)) && (AllNodes[i].script_podtype == type) )
			validNodes[validNodes.size] = AllNodes[i];
	}
	return validNodes;
}

createGroupMoveSquad (members)
{
	squadName = animscripts\squadmanager::generateSquadName();
	for (i = 0; i < members.size; i++)
		members[i] animscripts\squadmanager::addToSquad (squadName);

	squad = anim.squads[squadName];
	squad.memberRemoveFuncs[squad.memberRemoveFuncs.size] = ::removeFromSquad;

	squad.hiders = [];
	squad.concealers = [];
	squad.supporters = [];
	squad.newhiders = [];
	squad.newconcealers = [];
	squad.newsupporters = [];

	return (squad);
}

removeFromSquad (squadName)
{
	squad = self.squad;
	
	livingHiders = [];
	for (i=0;i<squad.hiders.size;i++)
	{
		if (!isalive(squad.hiders[i]))
			continue;
		if (squad.hiders[i] == self)
			continue;
		livingHiders[livingHiders.size] = squad.hiders[i];
	}
	livingConcealers = [];
	for (i=0;i<squad.Concealers.size;i++)
	{
		if (!isalive(squad.Concealers[i]))
			continue;
		if (squad.concealers[i] == self)
			continue;
		livingConcealers[livingConcealers.size] = squad.Concealers[i];
	}
	livingSupporters = [];
	for (i=0;i<squad.Supporters.size;i++)
	{
		if (!isalive(squad.Supporters[i]))
			continue;
		if (squad.supporters[i] == self)
			continue;
		livingSupporters[livingSupporters.size] = squad.Supporters[i];
	}
	
	livingNewHiders = [];
	for (i=0;i<squad.newhiders.size;i++)
	{
		if (!isalive(squad.newhiders[i]))
			continue;
		if (squad.newhiders[i] == self)
			continue;
		livingNewHiders[livingNewHiders.size] = squad.newhiders[i];
	}
	livingNewConcealers = [];
	for (i=0;i<squad.newConcealers.size;i++)
	{
		if (!isalive(squad.newConcealers[i]))
			continue;
		if (squad.newconcealers[i] == self)
			continue;
		livingNewConcealers[livingNewConcealers.size] = squad.newConcealers[i];
	}
	livingNewSupporters = [];
	for (i=0;i<squad.newSupporters.size;i++)
	{
		if (!isalive(squad.newSupporters[i]))
			continue;
		if (squad.newsupporters[i] == self)
			continue;
		livingNewSupporters[livingNewSupporters.size] = squad.newSupporters[i];
	}
	
	squad.hiders = livingHiders;
	squad.concealers = livingConcealers;
	squad.supporters = livingSupporters;
	squad.newhiders = livingnewHiders;
	squad.newconcealers = livingnewConcealers;
	squad.newsupporters = livingnewSupporters;

	if ((!isalive(squad.lead)) || (squad.lead == self))
		squad.lead = undefined;
	if ((!isalive(squad.newlead)) || (squad.newlead == self))
		squad.newlead = undefined;
	
	if (!squad.members.size)
		squad notify ("squad_wiped_out");	
}

aiSquadThink()
{
	self notify ("reset_aiThink");
	self endon ("reset_aiThink");
	spawn_failed(self);
	self.goalradius = 4;
	self.fightdist = 120;
	self.maxdist = 120;
	thread animscripts\shared::SetInCombat();
}

squadMoveThink(goalArray, radius, midpoint)
{
	self endon ("squad_wiped_out");
	self endon ("squad deleted " + self.squadName);
	protoMove(goalArray);
}

attackPlayerGroupMoveThink(goalArray)
{
	self endon ("squad_wiped_out");
	self endon ("squad deleted " + self.squadName);
	axisAttacksPlayer(goalArray);
}

/*
generatePathFromPlayer()
{
	/#
	if (getdebugcvar("debug_groupmove_nodes") == "on")
		thread showCover();
	#/
	
	set = level.player.origin;
	path =  potentialPath(set, level.player.origin);
	waypoints = getentarray("heading","script_noteworthy");

	if (getcvar("debug_groupmove_radius") == "")
		setcvar("debug_groupmove_radius", "256");
	if (getcvar("debug_groupmove_setstart") == "")
		setcvar("debug_groupmove_setstart", "off");

	for (i=0;i<waypoints.size;i++)
	{
		if (!isdefined(waypoints[i].radius))
			waypoints[i].radius = 256;
	}
		
	set = level.player.origin;
	for (;;)
	{
		radius = getcvarint("debug_groupmove_radius");
		if (radius > 0)
		{
			for (i=0;i<waypoints.size;i++)
				waypoints[i].radius = radius;
		}
		
		level notify ("newpath");
		level thread potentialPath(set, level.player.origin);
		
		if (getcvar("debug_groupmove_setstart") == "on")
		{
			set = level.player.origin;
			setcvar("debug_groupmove_setstart", "off");
		}
		wait (0.5);
	}
}
*/

showCover()
{
	cover = getnodearray("cover","targetname");
	for (i=0;i<cover.size;i++)
		cover[i] thread debugorigin();
	
	/*
	for (;;)
	{
		for (i=0;i<cover.size;i++)
			print3d (cover[i].origin + (0,0,-10), "x", (1, 0.5, 0.0), 1.95, 1.0);
		wait (0.05);
	}
	*/
}


protoMove(pathArray)
{
	path = maps\_astar::getPathBetweenArrayOfPoints(self.members[0].origin, pathArray);
	alliesMoveOnPath(path, pathArray, true);
}

axisAttacksPlayer(pathArray)	
{	
	if (!isdefined (pathArray))
		pathArray[0] = level.player.origin;
		
	waittillframeend;
	for (i=0;i<self.members.size;i++)
	{
		self.members[i].foundPosition = false;
		self.members[i].fightdist = 320;
		self.members[i].goalnode = undefined;
	}

	// First move towards the destination until you see an enemy
//	groupMovesOnPathPreCombat(pathArray);
	
	enemy = undefined;
	for (;;)
	{
		groupMovesOnPathUntilPlayerMoves();
		wait (0.05);
	}
}

trackPlayerWaypoint()
{
	self endon ("squad_wiped_out");
	self endon ("squad deleted " + self.squadName);
	self endon ("player_left_waypoint");
	// End when the player has moved from one waypoint to another.
	currentNode = getClosest(level.player.origin, level.waypointHeading);
	nodes = currentNode.link;
	nodes[nodes.size] = currentNode;
	
	thickCheck = 5;
	startOrg = level.player.origin;
	for (;;)
	{
		for (;;)
		{
			if (distance (startOrg, level.player.origin) > 300)
			{
				newNode = getClosest(level.player.origin, nodes);
				thickCheck--;
				if (!thickCheck)
				{
					// Check against all waypoints every once in awhile in case he moves in some way that keeps him
					// near the currentNode but is moving away from it and the links.
					newNode = getClosest(level.player.origin, level.waypointHeading);
					thickCheck = 5;
				}
		
				if (newNode != currentNode)
					break;
			}
			wait (0.3);
		}
		
		if (self.path.size < 2 || newNode != self.path[self.path.size - 2])
			break;
		currentNode = newNode;
		newPath = [];
		for (i=0;i<self.path.size-1;i++)
			newPath[newPath.size] = self.path[i];
		self.path = newPath;
		/#
		if (getdebugcvar("debug_groupmove_simplepaths") == "on")
			level thread maps\_astar::drawPath (self.path, 1000, self.squadid);
		else
		if (getdebugcvar("debug_groupmove_simplepaths") != "off")
		{
			if (getdebugcvarint("debug_groupmove_simplepaths") == self.squadid)
				level thread maps\_astar::drawPath (self.path, 1000, self.squadid);
		}
		#/
	}
	
	self notify ("player_left_waypoint");
}

groupMovesOnPathUntilPlayerMoves()
{
	self endon ("player_left_waypoint");
	self thread trackPlayerWaypoint();
	waittillframeend;
	enemy = level.player;
	enemyOrg[0] = enemy.origin;

	org = getFarthest (level.player.origin, self.members).origin;
	/*
	org = (0,0,0);
	for (i=0;i<self.members.size;i++)
		org += self.members[i].origin;
	org = (org[0] / self.members.size, org[1] / self.members.size, org[2] / self.members.size);
	*/

	// Remove the connection between the node nearest the player and the one before it
	nearNode = getClosest(enemy.origin, level.waypointHeading);
	nearNodeLink = getHighestDot(nearNode.origin, enemy.origin, nearNode.link);
	assert (isdefined (nearNodeLink));


	path = maps\_astar::getPathBetweenArrayOfPoints(org, enemyOrg);
	if (path.size < 2)
		level waittill ("eternity");
	
	oldPath = path;
	lastNode = undefined;
	node = undefined;

/*
	thread debug_message_clear ("nearNode", nearNode.origin, 500);
	thread debug_message_clear ("nearNodeLink", nearNodeLink.origin, 500);
	thread debug_message_clear ("path-1", path[path.size-1].origin + (0,0,35), 500);
	thread debug_message_clear ("path-2", path[path.size-2].origin + (0,0,35), 500);
*/

	if (path[path.size-1] == nearNode && path[path.size-2] == nearNodeLink)
	{
		// If the player is standing on the last link of the path then disconnect that link
		lastNode = nearNode;
		node = nearNodeLink;
	}
	else
	{
		// If the player is not standing on the last link of the path, then find the link closest
		// to the player and disconnect it.
		nearIndex = getClosestIndex(enemy.origin, path);
		lastNode = path[nearIndex];
		node = path[nearIndex-1];
		if (!isdefined (node))
		{
			lastNode = path[1];
			node = path[0];
		}
	}

	
//	thread debug_message ("last", lastNode.origin, 500);
//	thread debug_message ("next", node.origin, 500);
	
	oldLinks = [];
	for (i=0;i<lastnode.link.size;i++)
		oldLinks[oldLinks.size] = lastNode.link[i];

	newLinks = [];
	for (i=0;i<lastnode.link.size;i++)
	{
		if (lastnode.link[i] == node)
			continue;
		newLinks[newLinks.size] = lastNode.link[i];
	}
	
	lastNode.link = newLinks;
	path = maps\_astar::getPathBetweenArrayOfPoints(org, enemyOrg);
	lastNode.link = oldLinks;
	
	if (path.size < 2)
	{
		// Revert the path if the new one is only one node.
		path = oldPath;
	}
	else
	if (path[path.size-1] == nearNode && path[path.size-2] == nearNodeLink)
	{
		// revert the path if the path ends up being the one the player is walking on
		path = oldPath;
	}
	
	pathArray[0] = enemyOrg;
	groupMovesOnPath(path, pathArray, false);
//	while (self.runners > 0)
//		self waittill ("runner_reached_goal");
	self waittill ("eternity");
	
	/*
	path = maps\_astar::getPathBetweenArrayOfPoints(org, enemyOrg);

	// If you're at the end of the path then just move in! Charge!
	if (path.size < 2)
	{
		waittillframeend;
		for (i=0;i<self.members.size;i++)
		{
			ai = self.members[i];
			ai setgoalentity (enemy);
			ai.goalradius = ai.maxdist * 0.5;
		}
		return;
	}
	

	// Remove the connection between the node nearest the player and the one before it
	nearIndex = getClosestIndex(enemy.origin, path);
	
	lastNode = path[nearIndex];
	node = path[nearIndex-1];
	if (!isdefined (node))
	{
		lastNode = path[1];
		node = path[0];
	}
	
//	thread debug_message ("last", lastNode.origin, 500);
//	thread debug_message ("next", node.origin, 500);
	
	oldLinks = [];
	for (i=0;i<lastnode.link.size;i++)
		oldLinks[oldLinks.size] = lastNode.link[i];

	newLinks = [];
	for (i=0;i<lastnode.link.size;i++)
	{
		if (lastnode.link[i] == node)
			continue;
		newLinks[newLinks.size] = lastNode.link[i];
	}
	
	lastNode.link = newLinks;
	newpath = maps\_astar::getPathBetweenArrayOfPoints(self.members[0].origin, enemyOrg);
	lastNode.link = oldLinks;
	
	if (newPath.size > 1)
		path = newPath;

	pathArray[0] = enemyOrg;
	groupMovesOnPath(path, pathArray, false);
	*/
}

groupMovesOnPathPreCombat(pathArray)
{
	self endon ("group member saw an enemy");
	waittillframeend;
	array_thread (self.members, ::seeEnemy, self);
	org = getFarthest (level.player.origin, self.members).origin;
	path = maps\_astar::getPathBetweenArrayOfPoints(org, pathArray);
	groupMovesOnPath(path, pathArray, true);
	while (self.runners > 0)
		self waittill ("runner_reached_goal");
}

seeEnemy(ent)
{
	self endon ("death");
	for (;;)
	{
		wait (0.5);
		if (!isalive(self.enemy))
			continue;
		if (self.enemy != level.player)
			continue;
		if (animscripts\utility::sawEnemyMove(500))
			break;
	}
	ent notify ("group member saw an enemy");
}

VecRight(forward1, forward2)
{
	return (vectorDot(forward1, forward2) < 0);
}

VecLeft(forward1, forward2)
{
	return (vectorDot(forward1, forward2) > 0);
}


groupMovesOnPath(path, pathArray, addEndOffShoots)
{
	self notify ("new_path");
	self.runners = 0;
	array = swatPath(path, addEndOffShoots);
	nodes = array[0];
	nodesMajor = array[1];
	nodesPathnum = array[2];

	routeArray = [];
	routeArrayNum = [];
	// Pick the nodes to run to for running along the path
	for (i=0;i<path.size-1;i++)
	{
		currentPath = path[i];
		nextPath = path[i+1];
		
		// Player becomes the end of the path
		if (i+2 >= path.size)
			endPath = level.player;
		else
			endPath = path[i+2];
		
		currentAngles = vectorToAngles(currentPath.origin - nextPath.origin);
		pathForward = anglesToForward(currentAngles);
		
		nextAngles = vectorToAngles(nextPath.origin - endPath.origin);
		nextForward = anglesToForward(nextAngles);
		
		// If the path is straight then we continue on to the next link to find a node to use
		if (vectordot(pathForward, nextForward) > 0.85)
			continue;

		nextNode = undefined;
		pathRight = anglesToRight(currentAngles);
		if (vectordot(pathRight, nextForward) > 0)
			compareFunc = ::VecLeft;
		else
			compareFunc = ::VecRight;

		// Path turns right
		// Get all the nodes on the right side of the path and find the closest one to the waypoint
		coverNodes = [];
		coverNodesNum = [];
		for (p=0;p<nodes.size;p++)
		{
			if (nodesPathnum[p] < i)
				continue;
			if (nodesPathnum[p] > i)
				break;
				
			nodeAngles = vectorToAngles(nodes[p].origin - currentPath.origin);
//			thread debug_message_clear (p + "ang " + nodeAngles[1], nodes[p].origin + (0,0,40), 500);
			nodeForward = anglesToForward(nodeAngles);
//			debuginfo = vectorDot(pathRight,nodeForward);
//			thread debug_message_clear (p + "fov " + debuginfo, nodes[p].origin + (0,0,20), 500);
			
			// Is node on the left of the path?
			if ([[compareFunc]](pathRight,nodeForward))
				continue;
			coverNodes[coverNodes.size] = nodes[p];
			coverNodesNum[coverNodesNum.size] = nodesPathnum[p];
		}

		if (coverNodes.size)
		{
			index = getClosestIndex(nextPath.origin, coverNodes);
			routeArray[routeArray.size] = coverNodes[index];
			routeArrayNum[routeArrayNum.size] = coverNodesNum[index];
		}
	}
	
	/#
	if (getdebugcvar("debug_groupmove_simplepaths") == "on")
	{
		for (i=0;i<routeArray.size;i++)
			thread debug_message_clear ("Route " + i, routeArray[i].origin + (0,0,0), 500, routeArray[i].origin);
	}
	else
	if (getdebugcvar("debug_groupmove_simplepaths") != "off")
	{
		if (getdebugcvarint("debug_groupmove_simplepaths") == self.squadid)
		{
			for (i=0;i<routeArray.size;i++)
				thread debug_message_clear ("Route " + i, routeArray[i].origin + (0,0,0), 500, self.squadid);
		}
	}
	
	#/

	self.path = path;
	waittillframeend;
	for (i=0;i<self.members.size;i++)
	{
		// If the AI is already happy where they are, verify that this pos is still legit, if not, break him out.
		if (self.members[i].foundPosition && nodeCanSeePlayer(self.members[i].goalnode, path))
			continue;
		self.members[i].foundPosition = false;
		self.members[i].isSupressable = true;
		self.members[i].anim_forced_cover = "none";

		self.members[i] thread ai_axisMoveThink(routeArray, routeArrayNum, self);
	}
//	level waittill ("eternity");
		
	// Go through all the nodes on the path and see if any of them are unused and can see the player
	// Store them so that the AI moving down the path know which nodes they can use.
	if (0)
	{
		goodNodes = [];
		memberUsingNode = [];
		memberEnt = [];
		
		ai = getaiarray();
		for (i=0;i<nodes.size;i++)
		{
			node = nodes[i];
			
			nodeInUse = false;
			for (z=0;z<self.members.size;z++)
			{
				if (!isdefined(self.members[z].goalnode))
					continue;
				if (self.members[z].goalnode != nodes[i])
					continue;
					
				nodeInUse = true;
				break;
			}
			
			if (nodeInUse)
				continue;

			if (!nodeCanSeePlayer(node, path))
				continue;
		
			// Found out if the node is already in use by another AI
			nodeInUse = false;
			memberUsingNode[goodNodes.size] = false;
			for (p=0;p<ai.size;p++)
			{
				member = false;
				for (z=0;z<self.members.size;z++)
				{
					if (ai[p] != self.members[z])
						continue;
						
					member = true;
					break;
				}
				
				if (!isdefined(ai[p].node))
					continue;
				if (ai[p].node != node)
					continue;
				if (member)
				{
					memberUsingNode[goodNodes.size] = true;
					memberEnt[goodNodes.size] = ai[p];
				}
				else
					nodeInUse = true;
				break;
			}
			
			if (nodeInUse)
				continue;

							
			self.goodNodeUsed[goodNodes.size] = false;
			goodNodes[goodNodes.size] = node;
		}
			
		self.goodNodes = goodNodes;
		self.memberUsingNode = memberUsingNode;
		self.memberEnt = memberEnt;
		
		wait (1);
	}
}

nodeCanSeePlayer(node, path)
{
	// If the node points at the last waypoint on the path then that means the player is right there so it better get covered
	lastNode = path[path.size-1];
    nodeforward = anglesToForward((0, node.angles[1], 0));
	pathforward = vectorToAngles(lastNode.origin - node.origin);
	pathForward = anglesToForward(pathForward);
	dot = vectordot(nodeforward, pathforward);
	skipToTrace = false;
	if (dot > 0.8)
		skipToTrace = true;

	traceTarget = undefined;
	if (!skipToTrace)
	{
		playerforward = vectorToAngles(level.player.origin - node.origin);
		playerforward = anglesToForward(playerforward);
	    
		dot = vectordot(nodeforward, playerforward);
		if (dot < 0.7)
			return false;
		
		traceTarget = level.player GetEye();
	}
	else
		traceTarget = lastNode.origin;		
	
	// continue if we cant trace to the player from the node
	offset = (0,0,0);
	if (node.type == "Cover Left")
	{
		offset = anglestoright(node.angles);
		offset = maps\_utility::vectorScale(offset, -32);
	}
	else
	if (node.type == "Cover Right")
	{
		offset = anglestoright(node.angles);
		offset = maps\_utility::vectorScale(offset, 32);
	}
	offset += (0,0,64);

	return bulletTracePassed(node.origin + offset, traceTarget, false, level.player);
}

ai_axisMoveThink(routeArray, routeArrayNum, ent)
{
//	self.favoriteEnemy = level.player;
	self.grenadeawareness = 1;
	if (self.maxdist < 512)
		self.maxdist = 512;
	ent endon ("new_path");
	
	nearIndex = getClosestIndex(self.origin, ent.path);
	currentPath = undefined;
	if (nearIndex == ent.path.size-1)
		currentPath = nearIndex;
	else
	if (nearIndex == 0)
		currentPath = nearIndex;
	else
	{
		// Find out if the AI is in front or behind of the waypoint he's near
		nextAngles = vectorToAngles(ent.path[nearIndex+1].origin - ent.path[nearIndex].origin);
		nextForward = anglesToForward(nextAngles);
		lastAngles = vectorToAngles(ent.path[nearIndex-1].origin - ent.path[nearIndex].origin);
		lastForward = anglesToForward(lastAngles);
		aiAngles = vectorToAngles(self.origin - ent.path[nearIndex].origin);
		aiForward = anglesToForward(aiAngles);
		
		if (vectorDot(nextForward, aiForward) > vectorDot(lastForward, aiForward))
			currentPath = nearIndex + 1;
		else
			currentPath = nearIndex;
	}
	
	ent.runners++;
	for (i=nearIndex;i<ent.path.size;i++)
	{
		for (p=0;p<routeArray.size;p++)
		{
			if (routeArrayNum[p] < i)
				continue;
			if (routeArrayNum[p] > i)
				break;

			pathnode = routeArray[p];
			self.goalradius = 100;
			self setgoalpos (pathnode.origin);
			self setpotentialthreat(pathnode.angles[1]);
			self waittill ("goal");
			if (self.keepClaimedNodeInGoal)
				continue;
				
			if (self useCoverNode(pathNode))
			{
				self.isSuppressable = false;
				self.anim_forced_cover = "show";
				ent.runners--;
				ent notify ("runner_reached_goal");
				return;
			}
		}
	}
	ent.runners--;
	ent notify ("runner_reached_goal");
//	self setgoalentity (level.player);
	self.goalradius = self.maxdist;
	self setgoalpos (ent.path[ent.path.size-1].origin);
	
	/*
	nearIndex = getClosestIndex(self.origin, path);
	for (i=nearIndex;i<path.size;i++)
	{
		// Move to the next waypoint on the path
		pathnode = path[i];
		if (isdefined (pathnode.radius))
			self.goalradius = pathnode.radius;
		else
			self.goalradius = 384;
		self setgoalpos (pathnode.origin);
		self waittill ("goal");
		
		for (p=0;p<ent.goodNodes.size;p++)
		{
			if (ent.goodNodeUsed[p])
				continue;
			
			if (ent.memberUsingNode[p] && ent.memberEnt[p] == self)
			{
				// I'm using this node so quit out of the function entirely and merily use the node.
				ent.goodNodeUsed[p] = true;
				self.foundPosition = true;
				self.goalnode = ent.goodNodes[p];
				self.isSupressable = false;
				self.anim_forced_cover = "show";
				return;
			}
			
			if (distance (self.origin, ent.goodNodes[p].origin) < self.goalradius)
			{
				ent.goodNodeUsed[p] = true;
				self setgoalnode (ent.goodNodes[p]);
//				self.goalradius = 64;
				self thread goalradiusResize(64);
				self.foundPosition = true;
				self.goalnode = ent.goodNodes[p];
				self.isSupressable = false;
				self.anim_forced_cover = "show";
				return;
			}
		}
	}
	*/
	
}

alliesMoveOnPath(path, pathArray, addEndOffShoots)
{
	array = alliesswatPath(path, addEndOffShoots);
	nodes = array[0];
	nodesMajor = array[1];
	
	if (!nodes.size)
	{
		print ("path from " + self.members[0].origin);
		for (i=0;i<pathArray.size;i++)
			print (" to " + pathArray[i]);
		println (" found no cover nodes.");
		return;
	}
	/*	
	for (i=0;i<nodes.size;i++)
	{
		println ("^3node direction " + nodes[i].angles[1]);
	}

	self.nodes = nodes;
	self.currentNodeNum = 0;
	self.nextNodeNum = 0;
//	currentAI = 0;
	self.lowestNode = 0;
	for (i=0;i<self.members.size;i++)
	{
		self.members[i] setgoalnode(nodes[self.currentNodeNum]);
		if (isdefined (nodes[self.currentNodeNum].radius))
			self.members[i].goalradius = nodes[self.currentNodeNum].radius;
		self.members[i].groupmoveNodeNum = self.currentNodeNum;
		if (i < self.nodes.size -1)
			self.currentNodeNum++;
	}
	*/

	// Scouts are the AI that check offshoots
	scouts = [];
	self.runners = 0;
	waittillframeend;
	for (i=0;i<self.members.size;i++)
		self.members[i] notify ("reached_goal_end");
	
	for (p=0;p<nodes.size;p++)
	{
		node = nodes[p];
		major = nodesMajor[p];
		waittillframeend;
		radius = 512;
		if (node.radius != 0)
			radius = node.radius;
		
		// Everybody runs to major nodes
		if (major)
		{
			while (self.runners)
				self waittill ("reached_goal");
			scouts = [];

			for (i=0;i<self.members.size;i++)
			{
				ai = self.members[i];
				ai.walkdist = 4;
				ai setgoalnode (node);
				ai setpotentialthreat(node.angles[1]);
				ai.goalradius = radius;
				self thread AiReachesGoalAndNotifies(ai);
			}
			
			while (self.runners)
				self waittill ("reached_goal");
		}
		else
		{
			// One guy goes to offshoots
			scout = undefined;
			
			// Get all the guys that're still at a major node
			ai = [];
			if (!scouts.size)
				ai = self.members;
			else
			{
				for (i=0;i<self.members.size;i++)
				{
					isScout = false;
					for (z=0;z<scouts.size;z++)
					{
						if (scouts[z] != self.members[i])
							continue;
						isScout = true;
						break;
					}
					if (!isScout)
						ai[ai.size] = self.members[i];
				}
			}
			
			if (ai.size)
			{
				if (ai.size == 1)
					scout = ai[0];
				else
					scout = getClosest(node.origin, ai);
			}
			else
				scout = getFarthest(node.origin, self.members);

			assert (isdefined (scout));
			scouts[scouts.size] = scout;
			scout.walkdist = 4;
			scout setgoalnode (node);
			scout setpotentialthreat(node.angles[1]);
			scout.goalradius = radius;
			self thread AiReachesGoalAndNotifies(scout);
		}
	}

//	array_thread (self.members, ::protoThink, self);
	self waittill ("finished_groupmove");
}

AiReachesGoalAndNotifies(guy)
{
	guy endon ("reached_goal_end");
	self.runners++;
	guy waittillDeathOrGoal();
	self.runners--;
	self notify ("reached_goal");
}

waittillDeathOrGoal()
{
	self endon ("death");
	self waittill ("goal");
	self endon ("time elapsed");
	self thread notifyOnTimeElapsed(2);
	for (;;)
	{
		if (!isdefined (self.node))
			break;
		if (distance (self.node.origin, self.origin) < 80)
			break;
		wait (0.5);
	}
	self notify ("stop waiting on time elapsed");
}

notifyOnTimeElapsed(timer)
{
	self endon ("death");
	self endon ("stop waiting on time elapsed");
	wait (timer);
	self notify ("time elapsed");
}

waittillDeathOrResetNotify()
{
	self endon ("reset_aiThink");
	self waittill ("death");
}

deathNotifier(ent)
{
	ent endon ("finished_groupmove");
	waittillDeathOrResetNotify();
	
	if (self.groupmoveNodeNum == ent.currentNodeNum)
		ent notify ("arrived");

	setLowestToNextLowestNode(ent);
}

setLowestToNextLowestNode(ent)
{
	ent.lowestNode = ent.nodes.size;
	for (i=0;i<ent.members.size;i++)
	{
		if (!isalive(ent.members[i]))
			continue;
		if (ent.lowestNode > ent.members[i].groupmoveNodeNum)
			ent.lowestNode = ent.members[i].groupmoveNodeNum;
	}
}

setNextToNextHighestNode(ent)
{
	waittillframeend;
	ent.currentNodeNum = ent.nextNodeNum;
	ent.nextNodeNum = 0;
	for (i=0;i<ent.members.size;i++)
	{
		if (ent.nextNodeNum < ent.members[i].groupmoveNodeNum)
			ent.nextNodeNum = ent.members[i].groupmoveNodeNum;
	}
	ent.nextNodeNum++;
}


protoThink(ent)
{
	wait (0.05);
	self notify ("reset_aiThink");
	self endon ("reset_aiThink");
	self endon ("death");
	
	self thread deathNotifier(ent);
	self thread goalradiusResize();
	
	for (;;)
	{
//		waittillGoalOrElapsedTime(8);
		self waittill ("goal");
		if (self.groupmoveNodeNum == ent.currentNodeNum)
			ent notify ("arrived");
		gotime = gettime() + 4000;
		for (;;)
		{
			if (self.groupmoveNodeNum == ent.lowestNode)
				break;
				
//			ent waittill ("arrived");
			self waittillArrivedOrElapsedTime(ent, 8);
		}
		if (ent.nextNodeNum >= ent.nodes.size)
			break;
			
		if (gettime() < gotime)
		{
			wait ((gotime - gettime()) * 0.001);
//			println ("waiting " + ((gotime - gettime()) * 0.001));
		}
		if (ent.nextNodeNum >= ent.nodes.size)
			break;
		self.keepclaimednodeingoal = false;
		self thread goalradiusResize(ent.nodes[ent.nextNodeNum].radius);
		self setgoalnode (ent.nodes[ent.nextNodeNum]);
		wait (0.05);
		if (ent.nextNodeNum >= ent.nodes.size)
			break;
		self.groupmoveNodeNum = ent.nextNodeNum;
		setLowestToNextLowestNode(ent);
		setNextToNextHighestNode(ent);
//		println ("current node: " + ent.currentnode + ", lowest node: " + ent.lowestNode);
	}
	ent notify ("finished_groupmove");
}

goalradiusResize(radius)
{
	self.goalradius = 4;
	wait (2);
	if (isdefined (radius))
		self.goalradius = radius;
	else
		self.goalradius = 256;
}


waittillArrivedOrElapsedTime(ent, timer)
{
	self endon ("timer stops now");
	self thread timerGo(timer);
	ent waittill ("arrived");
}

timerGo(timer)
{
	self endon ("goal");
	wait (timer);
	self notify ("timer stops now");
}



swatPath(path, addendOffshoots)
{		
	if (path.size < 2)
		return;
	/#
	if (getdebugcvar("debug_groupmove_paths") == "on")
		level thread maps\_astar::drawPathOffshoots (path, -1);
	if (getdebugcvar("debug_groupmove_simplepaths") == "on")
		level thread maps\_astar::drawPath (path, 1000, self.squadid);
	else
	if (getdebugcvar("debug_groupmove_simplepaths") != "off")
	{
		if (getdebugcvarint("debug_groupmove_simplepaths") == self.squadid)
			level thread maps\_astar::drawPath (path, 1000, self.squadid);
	}
		
	#/
	
	cover = getnodearray("cover","targetname");
	
	for (i=0;i<path.size;i++)
	{
		if (!isdefined(path[i].radius))
			path[i].radius = 256;
	}
	
	array = getSwatPath(path, cover, addendOffshoots);
	
	
	/#
	if (getdebugcvar("debug_groupmove_nodes") == "on")
		thread showSwatPath(array, 1000, "stopSquadPath" + self.squadid);
	#/
	return array;
}	

getSwatPath(path, cover, addendOffshoots)
{
	nodes = [];
	nodesMajor = [];
	nodesPathnum = [];
	
	// Go through the entire path and add each node and connection
	for (i=0;i<path.size-1;i++)
	{
		linkArray = [];
		for (p=0;p<path[i+1].link.size;p++)
		{
			if (path[i+1].link[p] == path[i])
				continue;
			linkArray[linkArray.size] = arrayOrderFovOnly(path[i+1], path[i+1].link[p], path[i], cover);
		}
		includers = [];
		for (p=0;p<linkArray.size;p++)
		{
			for (z=0;z<linkArray[p].size;z++)
				includers[includers.size] = linkArray[p][z];
		}
			
		multiArray = arrayOrder(path[i], path[i+1], cover, includers);
		// Major nodes are nodes that point along the direction of the path.
		nodeArray = multiArray[0];
		nodeMajorArray = multiArray[1];
		for (p=0;p<nodearray.size;p++)
		{
			nodes[nodes.size] = nodearray[p];
			nodesMajor[nodesMajor.size] = nodeMajorArray[p];
			nodesPathnum[nodesPathnum.size] = i;
		}
	}
	
	if (addendOffshoots)
	{
		// Add the first node from all the branches from the end point
		lastpath = path[path.size-1];
		additions = [];
		angles = vectorToAngles(lastPath.origin - path[path.size-2].origin);
		forwardAngles = anglesToForward((0, angles[1], 0));
		for (i=0;i<lastpath.link.size;i++)
		{
			// Dont check the path we just came from
			if (lastpath.link[i] == path[path.size-2])
				continue;
				
			arrayOfNodes = arrayOrderFovOnly(lastPath, lastPath.link[i], path[path.size-2], cover);
			if (arrayOfNodes.size)
			{
				addNode = arrayOfNodes[0];
				
			    nodeforward = anglesToForward((0, addNode.angles[1], 0));
				dot = vectordot(nodeforward, forwardAngles);
				// Make sure the node doesn't point back the way we came
				if (dot > -0.7)
					additions[additions.size] = arrayOfNodes[0];
	//			thread setDotPoint(addNode.origin, dot);
			}
		}
		for (p=0;p<additions.size;p++)
		{
			nodes[nodes.size] = additions[p];
			nodesMajor[nodesMajor.size] = true;
			nodesPathnum[nodesPathnum.size] = path.size-1;
		}
	}

	// Remove duplicates
	newnodes = [];
	newNodesMajor = [];
	newNodesPathnum = [];
	for (i=0;i<nodes.size;i++)
	{
		major = nodesMajor[i];
		exists = false;
		for (p=0;p<newnodes.size;p++)
		{
			if (newnodes[p] != nodes[i])
				continue;

			if (major)
				newNodesMajor[p] = true;
			exists = true;
			break;
		}
		if (exists)
			continue;
		
		newnodes[newnodes.size] = nodes[i];
		newnodesMajor[newnodesMajor.size] = major;
		newNodesPathnum[newNodesPathnum.size] = nodesPathnum[i];
	}
	
	nodes = newNodes;
	nodesMajor = newNodesMajor;
	nodesPathnum = newNodesPathnum;
	
	/*
	newNodes = [];
	newNodesMajor = [];
	newNodesPathnum = [];
	
	lastNode = undefined;
	lastMajor = undefined;
	for (p=0;p<nodes.size;p++)
	{
		currentNode = nodes[p];
		currentMajor = nodesMajor[p];
		currentPathnum = nodesPathnum[p];
		// Skip nodes that are extremely close to each other
		if (!p)
		{
			newNodes[newNodes.size] = currentNode;
			newNodesMajor[newNodesMajor.size] = currentMajor;
			newNodesPathnum[newNodesPathnum.size] = currentPathnum;
			lastNode = currentNode;
			lastMajor = currentMajor;
			continue;
		}

		dist = distance(lastNode.origin, currentNode.origin);
		if (dist < 128)
			continue;				
			
		// If we have 2 major nodes in a row that are close together, compare their distance
		// We dont want two majors in the same direction that are close together.
		if (lastMajor && currentMajor)
		{
			println ("dot was " + vectorDot(anglesToForward(lastNode.angles), anglesToForward(currentNode.angles)));
			if (vectorDot(anglesToForward(lastNode.angles), anglesToForward(currentNode.angles)) > 0.8)
			{
				angles = lastNode.angles;
				forward = anglesToForward(angles);
//				normal = vectorNormalize(end - start);
				normal = vectorNormalize(forward);
				vec = currentNode.origin - lastNode.origin;
				progress = vectorDot (vec, normal);
				
				println ("Progress was ", progress);
				if (progress < 500)
					continue;
			}
		}
		
		newNodes[newNodes.size] = currentNode;
		newNodesMajor[newNodesMajor.size] = currentMajor;
		newNodesPathnum[newNodesPathnum.size] = currentPathnum;
		lastNode = currentNode;
		lastMajor = currentMajor;
	}
	*/
	
	multiArray[0] = newnodes;
	multiArray[1] = newnodesMajor;
	multiArray[2] = newNodesPathnum;
	return multiarray;
}

showSwatPath(array, duration, ender)
{
	nodes = array[0];
	nodesMajor = array[1];
	nodesPathnum = array[2];
	
	level notify (ender);
	level endon (ender);
	for (p = 0; p < duration * 20; p++)
	{
		for (i=0;i<nodes.size;i++)
		{
			msg = "";
			if (nodesMajor[i])
				msg = "m";
			print3d (nodes[i].origin, i+1+msg + " " + nodesPathnum[i], (0.2, 0.8, 0.5), 1.95, 1.0);
			if (i < nodes.size -1)
				line(nodes[i].origin + (0,0,25), nodes[i+1].origin + (0,0,25), (0, 1, 0), 1.0);
		}
		wait (0.05);
	}
}

/*
potentialPath(start, dest)
{		
	level endon ("newpath");
	array = [];
	array[array.size] = dest;
	path = maps\_astar::getPathBetweenArrayOfPoints(start, array);
	if (path.size < 2)
		return;
	level thread maps\_astar::drawPathOffshoots (path, -1);
	
	cover = getnodearray("cover","targetname");
	array = getSwatPath(path, cover, true);
	nodes = array[0];
	nodesMajor = array[1];
	
	for (;;)
	{
		for (i=0;i<nodes.size;i++)
		{
			msg = "";
			if (nodesMajor[i])
				msg = "m";
			print3d (nodes[i].origin, i+1+msg, (0.2, 0.8, 0.5), 1.95, 1.0);
			if (i < nodes.size -1)
				line(nodes[i].origin + (0,0,25), nodes[i+1].origin + (0,0,25), (0, 1, 0), 1.0);
		}
		wait (0.05);
	}
}
*/

arrayOrder(startnode, endnode, cover, includers)
{
	start = startnode.origin;
	startradius = startnode.radius;
	end = endnode.origin;
	endradius = endnode.radius;

	angles = vectorToAngles(end - start);
	forwardAngles = anglesToForward((0, angles[1], 0));
	length = distance(start, end);
	
	nodes = [];
	nodesProgress = [];
	// Major nodes are those that don't point to offshots, they're along the main path.
	nodesMajor = [];
		
	for (i=0;i<cover.size;i++)
	{
		included = false;
		for (p=0;p<includers.size;p++)
		{
			if (cover[i] != includers[p])
				continue;
			included = true;
			break;
		}
		
		// Included nodes point to offshoots so we don't do the dot check on them.
		if (!included)
		{
		    nodeforward = anglesToForward((0, cover[i].angles[1], 0));
			dot = vectordot(nodeforward, forwardAngles);
	
//			thread setDotPoint(cover[i].origin, dot);
			if (dot < 0.8)
				continue;
		}

		normal = vectorNormalize(end - start);
		vec = cover[i].origin - start;
		progress = vectorDot (vec, normal);
		
		// Is the node in front of or beyond this set of waypoints?
		if (progress > length)
			continue;
		if (progress < 0)
			continue;
		
		forward = vectorScale(forwardAngles, progress);
		nodepos = start + forward;
		ratio = progress / length;
		maxdist = endRadius * ratio + startRadius * (1.0 - ratio);
		
		// Is the node too far from the path?
		if (distance (nodepos, cover[i].origin) > maxdist)
			continue;
		nodes[nodes.size] = cover[i];
		nodesProgress[nodesProgress.size] = ratio;
		nodesMajor[nodesMajor.size] = !included;
	}
	

	
	filled = undefined;
	for (i=0;i<nodes.size;i++)
		filled[i] = false;

	newArray = [];
	newMajor = [];
	for (p=0;p<nodes.size;p++)
	{
		dist = 1;
		index = -1;
		for (i=0;i<nodes.size;i++)
		{
			if (filled[i])
				continue;
				
			if (nodesProgress[i] >= dist)
				continue;
			dist = nodesProgress[i];
			index = i;
		}
		assert (index != -1);
		
		filled[index] = true;
		
		/*
		// Skip nodes that are extremely close to each other
		if (p > 0)
		{
			dist = distance(newArray[newArray.size-1].origin, nodes[index].origin);
			if (dist < 128)
				continue;				
				
			// If we have 2 major nodes in a row that are close together, compare their distance
			// We dont want two majors in the same direction that are close together.
			if (newMajor[newMajor.size-1] && nodesMajor[index])
			{
				println ("dot was " + vectorDot(newArray[newArray.size-1].angles, nodes[index].angles));
				if (vectorDot(newArray[newArray.size-1].angles, nodes[index].angles) > 0.8)
				{
					angles = newArray[newArray.size-1].angles;
					forward = anglesToForward(angles);
	//				normal = vectorNormalize(end - start);
					normal = vectorNormalize(forward);
					vec = nodes[index].origin - newArray[newArray.size-1].origin;
					progress = vectorDot (vec, normal);
					
					println ("Progress was ", progress);
					if (progress < 500)
						continue;
				}
			}
		}
		*/
		
		newArray[newArray.size] = nodes[index];
		newMajor[newMajor.size] = nodesMajor[index];
	}

	finalArray[0] = newArray;
	finalArray[1] = newMajor;
	return finalArray;
//	return newArray;
}

arrayOrderFovOnly(startnode, endnode, lastnode, cover)
{
	start = startnode.origin;
	startradius = startnode.radius;
	end = endnode.origin;
	endradius = endnode.radius;
	
	angles = vectorToAngles(end - start);
	forwardAngles = anglesToForward((0, angles[1], 0));
	length = distance(start, end);
	
	nodes = [];
	nodesProgress = [];

	lastangles = vectorToAngles(start - lastNode.origin);
	lastforwardAngles = anglesToForward((0, lastangles[1], 0));

	for (i=0;i<cover.size;i++)
	{
	    nodeforward = anglesToForward((0, cover[i].angles[1], 0));
		dot = vectordot(nodeforward, forwardAngles);

		if (dot < 0.8)
			continue;

		// Dont use nodes that point back the way we came
		dot = vectordot(nodeforward, lastforwardAngles);
		if (dot < -0.8)
			continue;
//		thread setDotPoint(cover[i].origin, dot);
			

		normal = vectorNormalize(end - start);
		vec = cover[i].origin - start;
		progress = vectorDot (vec, normal);
		
		// Is the node in front of or beyond this set of waypoints?
		if (progress > length)
			continue;
		if (progress < 0)
			continue;
		
		forward = vectorScale(forwardAngles, progress);
		nodepos = start + forward;
		ratio = progress / length;
		maxdist = endRadius * ratio + startRadius * (1.0 - ratio);
		
		// Is the node too far from the path?
		if (distance (nodepos, cover[i].origin) > maxdist)
			continue;
		nodes[nodes.size] = cover[i];
		nodesProgress[nodesProgress.size] = ratio;
	}

	filled = undefined;
	for (i=0;i<nodes.size;i++)
		filled[i] = false;
	
	newArray = [];
	for (p=0;p<nodes.size;p++)
	{
		dist = 1;
		index = -1;
		for (i=0;i<nodes.size;i++)
		{
			if (filled[i])
				continue;
				
			if (nodesProgress[i] >= dist)
				continue;
			dist = nodesProgress[i];
			index = i;
		}
		assert (index != -1);
		
		newArray[newArray.size] = nodes[index];
		filled[index] = true;
	}

	return newArray;
}

setDotPoint(org, dot)
{
	level notify ("stop dot" + org);
	level endon ("stop dot" + org);
	for (;;)
	{
		print3d (org + (0,0,40), dot, (0.5, 1, 0.5), 1.95, 1.0);
		wait (0.05);
	}
}




alliesSwatPath(path, addendOffshoots)
{		
	if (path.size < 2)
		return;
	/#
	if (getdebugcvar("debug_groupmove_paths") == "on")
		level thread maps\_astar::drawPathOffshoots (path, -1);
	if (getdebugcvar("debug_groupmove_simplepaths") == "on")
		level thread maps\_astar::drawPath (path, 1000, self.squadid);
		
	#/
	
	cover = getnodearray("cover","targetname");
	
	for (i=0;i<path.size;i++)
	{
		if (!isdefined(path[i].radius))
			path[i].radius = 256;
	}
	
	array = getAlliesSwatPath(path, cover, addendOffshoots);
	
	
	/#
	if (getdebugcvar("debug_groupmove_nodes") == "on")
		thread showSwatPath(array, 1000, "stopSquadPath" + self.squadid);
	#/
	return array;
}	

getAlliesSwatPath(path, cover, addendOffshoots)
{
	nodes = [];
	nodesMajor = [];
	nodesPathnum = [];
	
	// Go through the entire path and add each node and connection
	for (i=0;i<path.size-1;i++)
	{
		linkArray = [];
		for (p=0;p<path[i+1].link.size;p++)
		{
			if (path[i+1].link[p] == path[i])
				continue;
			linkArray[linkArray.size] = arrayOrderFovOnly(path[i+1], path[i+1].link[p], path[i], cover);
		}
		includers = [];
		for (p=0;p<linkArray.size;p++)
		{
			for (z=0;z<linkArray[p].size;z++)
				includers[includers.size] = linkArray[p][z];
		}
			
		multiArray = arrayOrder(path[i], path[i+1], cover, includers);
		// Major nodes are nodes that point along the direction of the path.
		nodeArray = multiArray[0];
		nodeMajorArray = multiArray[1];
		for (p=0;p<nodearray.size;p++)
		{
			nodes[nodes.size] = nodearray[p];
			nodesMajor[nodesMajor.size] = nodeMajorArray[p];
			nodesPathnum[nodesPathnum.size] = i;
		}
	}
	
	if (addendOffshoots)
	{
		// Add the first node from all the branches from the end point
		lastpath = path[path.size-1];
		additions = [];
		angles = vectorToAngles(lastPath.origin - path[path.size-2].origin);
		forwardAngles = anglesToForward((0, angles[1], 0));
		for (i=0;i<lastpath.link.size;i++)
		{
			// Dont check the path we just came from
			if (lastpath.link[i] == path[path.size-2])
				continue;
				
			arrayOfNodes = arrayOrderFovOnly(lastPath, lastPath.link[i], path[path.size-2], cover);
			if (arrayOfNodes.size)
			{
				addNode = arrayOfNodes[0];
				
			    nodeforward = anglesToForward((0, addNode.angles[1], 0));
				dot = vectordot(nodeforward, forwardAngles);
				// Make sure the node doesn't point back the way we came
				if (dot > -0.7)
					additions[additions.size] = arrayOfNodes[0];
	//			thread setDotPoint(addNode.origin, dot);
			}
		}
		for (p=0;p<additions.size;p++)
		{
			nodes[nodes.size] = additions[p];
			nodesMajor[nodesMajor.size] = true;
			nodesPathnum[nodesPathnum.size] = path.size-1;
		}
	}

	// Remove duplicates
	newnodes = [];
	newNodesMajor = [];
	newNodesPathnum = [];
	for (i=0;i<nodes.size;i++)
	{
		major = nodesMajor[i];
		exists = false;
		for (p=0;p<newnodes.size;p++)
		{
			if (newnodes[p] != nodes[i])
				continue;

			if (major)
				newNodesMajor[p] = true;
			exists = true;
			break;
		}
		if (exists)
			continue;
		
		newnodes[newnodes.size] = nodes[i];
		newnodesMajor[newnodesMajor.size] = major;
		newNodesPathnum[newNodesPathnum.size] = nodesPathnum[i];
	}
	
	nodes = newNodes;
	nodesMajor = newNodesMajor;
	nodesPathnum = newNodesPathnum;
	newNodes = [];
	newNodesMajor = [];
	newNodesPathnum = [];
	
	lastNode = undefined;
	lastMajor = undefined;
	for (p=0;p<nodes.size;p++)
	{
		currentNode = nodes[p];
		currentMajor = nodesMajor[p];
		currentPathnum = nodesPathnum[p];
		// Skip nodes that are extremely close to each other
		if (!p)
		{
			newNodes[newNodes.size] = currentNode;
			newNodesMajor[newNodesMajor.size] = currentMajor;
			newNodesPathnum[newNodesPathnum.size] = currentPathnum;
			lastNode = currentNode;
			lastMajor = currentMajor;
			continue;
		}

		dist = distance(lastNode.origin, currentNode.origin);
		if (dist < 128)
			continue;				
			
		// If we have 2 major nodes in a row that are close together, compare their distance
		// We dont want two majors in the same direction that are close together.
		if (lastMajor && currentMajor)
		{
			println ("dot was " + vectorDot(anglesToForward(lastNode.angles), anglesToForward(currentNode.angles)));
			if (vectorDot(anglesToForward(lastNode.angles), anglesToForward(currentNode.angles)) > 0.8)
			{
				angles = lastNode.angles;
				forward = anglesToForward(angles);
//				normal = vectorNormalize(end - start);
				normal = vectorNormalize(forward);
				vec = currentNode.origin - lastNode.origin;
				progress = vectorDot (vec, normal);
				
				println ("Progress was ", progress);
				if (progress < 500)
					continue;
			}
		}
		
		newNodes[newNodes.size] = currentNode;
		newNodesMajor[newNodesMajor.size] = currentMajor;
		newNodesPathnum[newNodesPathnum.size] = currentPathnum;
		lastNode = currentNode;
		lastMajor = currentMajor;
	}
	
	multiArray[0] = newnodes;
	multiArray[1] = newnodesMajor;
	multiArray[2] = newNodesPathnum;
	return multiarray;
}
