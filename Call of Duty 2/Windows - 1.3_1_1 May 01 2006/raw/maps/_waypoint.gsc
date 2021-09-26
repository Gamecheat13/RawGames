#include maps\_utility;
/*QUAKED info_friendly_waypoint (0.19 0.7 0.19) (-20 -20 -20) (20 20 20)
Friendly waypoint. Link them together to create a friendly web of waypoints.
*/
init(playerChain)
{
	level.friendly_waypoint_link = [];
	level.friendly_waypoint_unlink = [];

	level.print3dfunc = ::print3dnone;
	level.print3dfunc2 = ::print3dnone;
	level.linefunc = ::linenone;

	thread debugCvars();
		
	heading = getentarray ("script_friendly_waypoint","classname");
	oldheading = getentarray ("heading","script_noteworthy");
	for (i=0;i<oldheading.size;i++)
		heading[heading.size] = oldheading[i];
		
	// link the heading nodes
	LinkNodes( heading );

	level.waypointHeading = heading;
	if ((isdefined(playerChain)) && (!playerChain))
		return;
		
	prof_begin("waypoint");
	
	currentNode = heading[0];		
	dist = distance (level.player.origin, currentNode.origin);
	for (i=1;i<heading.size;i++)
	{
		header = heading[i];
		if (!header.chainLinked)
			continue;
		newdist = distance (level.player.origin, header.origin);
		if (newdist > dist)
			continue;
			
		dist = newdist;
		currentNode = heading[i];
	}
	
	lastNode = currentNode.link[0];
	dist = distance (level.player.origin, lastNode.origin);
	for (i=1;i<currentNode.link.size;i++)
	{
		node = currentNode.link[i];
		if (!node.chainLinked)
			continue;
		newdist = distance (level.player.origin, node.origin);
		if (newdist > dist)
			continue;
			
		dist = newdist;
		lastNode = node;
	}

/*
	pathnodes = getallnodes();	
	nodes = [];
	for (i=0;i<pathnodes.size;i++)
	{
		if ((pathnodes[i].type != "Cover Crouch Window")
		 && (pathnodes[i].type != "Cover Crouch")
		 && (pathnodes[i].type != "Cover Left")
		 && (pathnodes[i].type != "Cover Right")
		  && (pathnodes[i].type != "Cover Stand"))
			continue;
		nodes[nodes.size] = pathnodes[i];
	}
*/
	
	min = 30;
	max = 30;
//	level.player setorigin ((-558, 1351, 239));
	
	lastCurrentNode = currentNode;
	friendlyProgress = 1;
	level.lookahead = 0; // 150
	level.friendlyForwardDistance = 300;
	level.waypoint_get_new_nodes = false;
	mode = "last to current";	
	nextNodeTime = 0;
	nextNode = undefined;
	backtracking = false;
	for (;;)
	{
		prof_begin("waypoint");

		if (gettime() < nextNodeTime)
		{
			wait (0.05);
			continue;
		}
		nextNodeTime = gettime() + 500;
//		nextNodeTime = 0;
		
		if (level.waypoint_get_new_nodes)
		{
			wait (0.05);
			currentNode = heading[0];		
			dist = distance (level.player.origin, currentNode.origin);
			for (i=1;i<heading.size;i++)
			{
				header = heading[i];
				if (!header.chainLinked)
					continue;
				newdist = distance (level.player.origin, header.origin);
				if (newdist > dist)
					continue;
					
				dist = newdist;
				currentNode = heading[i];
			}
			
			lastNode = currentNode.link[0];
			dist = distance (level.player.origin, lastNode.origin);
			for (i=1;i<currentNode.link.size;i++)
			{
				node = currentNode.link[i];
				if (!node.chainLinked)
					continue;
				newdist = distance (level.player.origin, node.origin);
				if (newdist > dist)
					continue;
					
				dist = newdist;
				lastNode = node;
			}
		}
		
		unlinked = [];
		for (i=0;i<level.friendly_waypoint_unlink.size;i++)
			unlinked[i] = false;
			
		for (i=0;i<level.friendly_waypoint_unlink.size;i++)
		{
			unlinkNode = level.friendly_waypoint_unlink[i];
			if (unlinkNode == lastNode)
			{
				println ("^3Friendly Waypoints: Can't unlink node while it's Last Node");
				continue;
			}
			if (unlinkNode == currentNode)
			{
				println ("^3Friendly Waypoints: Can't unlink node while it's Current Node");
				continue;
			}
			if ((isdefined(nextnode)) && (unlinkNode == nextNode))
			{
				println ("^3Friendly Waypoints: Can't unlink node while it's the next Node");
				continue;
			}
			
			unlinked[i] = true;
			unlinkNode.chainLinked = false;
		}
		
		for (i=0;i<level.friendly_waypoint_link.size;i++)
			level.friendly_waypoint_link[i].chainLinked = true;

		level.friendly_waypoint_link = [];
		
		newUnlink = [];
		for (i=0;i<level.friendly_waypoint_unlink.size;i++)
		{
			if (!unlinked[i])
				newUnlink[newUnlink.size] = level.friendly_waypoint_unlink[i];
		}
		
		level.friendly_waypoint_unlink = newUnlink;

		level.friendlySpots = [];
		if (currentNode != lastCurrentNode)
			friendlyProgress = 1;
		lastCurrentNode = currentNode;
		
		/#
		if (level.waypointExtraDebug)
			thread drawHeading(heading);
		else
			[[level.lineFunc]] (lastNode.origin, currentNode.origin, (0.2, 0.5, 0.8), 0.5);
		#/
			
		/*
		for (i=0;i<currentNode.link.size;i++)
		{
			link = currentNode.link[i];
			if (link == lastNode)
				continue;
			if (link.chainLinked)
				[[level.lineFunc]] (currentNode.origin, link.origin, (0.2, 0.5, 0.8), 0.5);
			else
				[[level.lineFunc]] (currentNode.origin, link.origin, (0.8, 0.5, 0.1), 0.5);
			for (p=0;p<link.link.size;p++)
			{
				nextLink = link.link[p];
				if (nextLink == currentNode)
					continue;
	
				if (nextLink.chainLinked)
					[[level.lineFunc]] (link.origin, nextLink.origin, (0.2, 0.5, 0.8), 0.5);
				else
					[[level.lineFunc]] (link.origin, nextLink.origin, (0.8, 0.5, 0.2), 0.5);
			}
		}
		*/
				
		newNode = undefined;
		distToNewNode = 0;
		for (i=0;i<heading.size;i++)
		{
			if (heading[i] == currentNode)
				continue;
			if (heading[i] == lastNode)
				continue;
				
			// Don't make deadends the current node
			if (heading[i].link.size < 2)
				continue;
						
			distToNewNode = distance (level.player.origin, heading[i].origin);
			newNode = heading[i];
		}
		assert (distToNewNode != 0);

		for (i=0;i<heading.size;i++)
		{
			header = heading[i];
			if (!header.chainLinked)
				continue;
			if (header == lastNode)
				continue;
			if (header == currentNode)
				continue;

			// Don't make deadends the current node
			if (heading[i].link.size < 2)
				continue;
				
			newdist = distance (level.player.origin, header.origin);
			if (newdist > distToNewNode)
				continue;
			
			distToNewNode = newdist;
			newNode = header;
		}
		
		// Newnode is the closest node to the player that is not the last node nor the current node.
		// dist is the distance to newnode.		
		distanceToCurrentNode = distance (level.player.origin, currentNode.origin);
		distanceToLastNode = distance (level.player.origin, lastNode.origin);
		
		// If the current node is a dead end, Special check to see if we should swap the current and last node
		if (currentNode.link.size == 1)
		{
			if ((distanceToLastNode < distanceToCurrentNode) || (distanceToCurrentNode > distance(currentNode.origin, lastNode.origin)))
			{
				tempnode = currentNode;
				currentNode = lastNode;
				lastNode = tempnode;
				tempnode = undefined;
			}
		}
		
		if ((isdefined (nextNode)) && (nextNode != newNode))
		{
			if ((distToNewNode < distanceToLastNode) && (distToNewNode < distanceToCurrentNode))
			{
				lastNode = currentNode;
				currentNode = nextNode;
			}
		}
		else
		if (((isdefined (nextNode)) && (nextNode == newNode)) || backtracking)
		{
			if ((distToNewNode < distanceToLastNode) && (distToNewNode < distanceToCurrentNode))
			{
				if (distanceToLastNode > distanceToCurrentNode)
					lastNode = currentNode;
					
				currentNode = newNode;
			}
		}
		
		// Guess what the next node will be, if the player is not still walking along the last to current node path
		nextNode = undefined;
		
		start = (currentNode.origin[0], currentNode.origin[1], 0);
		end = (level.player.origin[0], level.player.origin[1], 0);
		angles = vectortoangles (end - start);

		start = (level.player.origin[0], level.player.origin[1], 0);
		end = (lastNode.origin[0], lastNode.origin[1], 0);
		difference = vectornormalize(end - start);
		forward = anglestoforward (angles);
		dot = vectordot(forward, difference);

		distanceFromLastToCurrent = distance(lastNode.origin, currentNode.origin);
		normal = vectorNormalize(currentNode.origin - lastNode.origin);
		vec = level.player.origin - lastNode.origin;
		progress = vectorDot (vec, normal);
		backtracking = progress < 0;
		
		if ((progress > distanceFromLastToCurrent) || (dot < 0.5))
		{
			dotMin = -2.0;
			
			for (i=0;i<currentNode.link.size;i++)
			{
				wait (0.05);
				link = currentNode.link[i];
				if (link == lastNode)
					continue;
				if (!link.chainLinked)
					continue;

				start = (currentNode.origin[0], currentNode.origin[1], 0);
				end = (link.origin[0], link.origin[1], 0); //(level.player.origin[0], level.player.origin[1], 0);
				angles = vectortoangles (end - start);
	
				start = (currentNode.origin[0], currentNode.origin[1], 0);
				end = (level.player.origin[0], level.player.origin[1], 0);
//				start = (level.player.origin[0], level.player.origin[1], 0);
//				end = (link.origin[0], link.origin[1], 0);
				difference = vectornormalize(end - start);
				forward = anglestoforward (angles);
				dot = vectordot(forward, difference);
//				[[level.print3dfunc]] (link.origin + (0,0,15), "Dot: " + dot, (0.6, 0.8, 0.3), 0.95, 1.0);
				
				if (dot < dotMin)
					continue;
					
				dotMin = dot;
				nextNode = link;
			}
		}
//		if (progress < distanceFromLastToCurrent)
//			nextNode = undefined;

		// Check to see if we've gone past the next node
		if ((isdefined (nextNode)) && (nextNode != lastNode))
		{
			start = currentNode.origin;
			end = nextNode.origin;
			friendlyForwardDistance = level.friendlyForwardDistance; // How far ahead the friendlies go
			normal = vectorNormalize(end - start);
			vec = level.player.origin - start;
			progress = vectorDot (vec, normal);
			
			if (progress > distance (currentNode.origin, nextNode.origin))
			{
				mode = "last to current";
				friendlyProgress += distanceFromLastToCurrent;
				friendlyProgress = 0;
				lastNode = currentNode;
				currentNode = nextNode;
				nextNode = undefined;
			}
		}
		level notify ("new_friendly_frame");

//		if ((isdefined (nextNode)) && (dist < distanceToLastNode))
		if ((isdefined (nextNode)) && (nextNode != lastNode))
		{
			if (mode == "last to current")
			{
				mode = "current to next";
				friendlyProgress = 0;
			}

			friendlyProgress = createLinesFromCurrentNode(currentNode, nextNode, lastNode, friendlyProgress);
		}
		else
		{
			if (mode == "current to next")
			{
				mode = "last to current";
//				friendlyProgress += distanceFromLastToCurrent;
			}

			friendlyProgress = createLinesFromLastNode(lastNode, currentNode, friendlyProgress);
		}
				
		[[level.print3dfunc]] (currentNode.origin, "Current Node", (0.2, 0.8, 0.5), 0.95, 1.0);
		[[level.print3dfunc]] (lastNode.origin, "Last Node", (0.2, 0.8, 0.5), 0.95, 1.0);
		if (isdefined (nextNode))
			[[level.print3dfunc]] (nextNode.origin, "Next Node", (0.2, 0.8, 0.5), 0.95, 1.0);

				
		ai = getaiarray ("allies");

		for (i=0;i<ai.size;i++)
		{
			if (!isdefined(ai[i].friendlyWaypoint))
				ai[i].friendlyWaypoint = false;
			ai[i].used = !(ai[i].friendlyWaypoint);
		}

		distrec = [];
		for (i=0;i<level.friendlySpots.size;i++)
		{
			for (p=0;p<ai.size;p++)
			{
				ent = spawnstruct();
				ent.distance = distance(level.friendlySpots[i].origin, ai[p].origin);
				ent.spot = level.friendlySpots[i];
				ent.ai = ai[p];
				distrec[distrec.size] = ent;
			}
		}

		orderedRecs = [];
		distrecs = distrec.size;
		for (i=0;i<distrecs;i++)
		{
			dist = distrec[0].distance;
			smallestRec = distrec[0];
			for (p=1;p<distrec.size;p++)
			{
				newdist = distrec[p].distance;
				if (newdist > dist)
					continue;
				dist = newdist;
				smallestRec = distrec[p];
			}			

			orderedRecs[orderedRecs.size] = smallestRec;
			
			newDistrec = [];
			for (p=0;p<distrec.size;p++)
			{
				if (distrec[p] == smallestRec)
					continue;
				newDistrec[newDistrec.size] = distrec[p];
			}			
			distrec = newDistrec;
		}
		
		minused = 0;
		for (p=0;p<orderedRecs.size;p++)
		{
			used = 0;
			for (i=0;i<level.friendlySpots.size;i++)
				used += level.friendlySpots[i].used;
			
			if (used >= ai.size)
				break;
			
			minused++;
			for (i=0;i<orderedRecs.size;i++)
			{
				rec = orderedRecs[i];
				if (rec.ai.used)
					continue;
				if (rec.spot.used >= minused)
					continue;
					
				rec.ai.used = true;
				rec.spot.used++;
				
				if (rec.distance < 150)
					continue;
				rec.ai setgoalpos (rec.spot.origin);
				rec.ai setpotentialthreat(rec.spot.angle);

				if (rec.ai.goalradius < 80)
					rec.ai.goalradius = 80; // 180; // 480
			}
		}

		wait (0.05);
	}
}


LinkNodes( heading )
{
	linkNameMap = [];

	for ( headerIndex = 0; headerIndex < heading.size; headerIndex++ )
	{
		header = heading[headerIndex];
		header.link = [];
		header.chainLinked = true;
		if ( !isdefined( header.radius ) )
			header.radius = 256;
		header.temp_linkMap = [];

		if ( !isdefined( header.script_linkName ) )
			continue;

		assert( !isdefined( linkNameMap[header.script_linkName] ) ); // script_linkName must uniquely specify the node
		linkNameMap[header.script_linkName] = headerIndex;
	}

	for ( headerIndex = 0; headerIndex < heading.size; headerIndex++ )
	{
		header = heading[headerIndex];
		if ( !isdefined( header.script_linkTo ) )
			continue;
	
		linkNames = strtok( header.script_linkTo, " " );

		for ( linkIndex = 0; linkIndex < linkNames.size; linkIndex++ )
		{
			linkName = linkNames[linkIndex];
			headerLinkIndex = linkNameMap[linkName];
			if ( !isdefined( headerLinkIndex ) )
				continue;
			if ( headerIndex == headerLinkIndex )
				continue;

			headerLink = heading[headerLinkIndex];

			if ( !isdefined( header.temp_linkMap[headerLinkIndex] ) )
			{
				header.temp_linkMap[headerLinkIndex] = true;
				header.link[header.link.size] = headerLink;
			}

			if ( !isdefined( headerLink.temp_linkMap[headerIndex] ) )
			{
				headerLink.temp_linkMap[headerIndex] = true;
				headerLink.link[headerLink.link.size] = header;
			}
		}
	}

	for ( headerIndex = 0; headerIndex < heading.size; headerIndex++ )
		heading[headerIndex].temp_linkMap = undefined;
}


debugText ()
{
	num = 4;
	lastOrg = [];
	for (i=0;i<num;i++)
		lastOrg[i] = (level.player.origin);
		
	angles = level.player getplayerangles();
	lastAng = [];
	for (i=0;i<num;i++)
		lastAng[i] = (angles);
	num = 1;
		
	for (;;)
	{
		lastOrg[0] = level.player.origin;
		angles = level.player getplayerangles();
		lastAng[0] = angles;
		forward = anglestoforward(angles);
		right = anglestoright(angles);
		up = anglestoup(angles);
		up = vectorScale(up, 37);
		forward = vectorScale(forward, 150);
		println (angles);
		
		ang = angles[0];
		if (ang > 75)
			ang = 75;
		bonus = (ang + 88) * -0.12;
//		right = vectorScale(right, -102 + bonus);
		right = vectorScale(right, -120);
		
		height = 38;
		doprint = true;
		for (i=0;i<num-1;i++)
		{
			if (lastOrg[i] == lastOrg[i+1])
				continue;
				
			doprint = false;
			break;
		}

		if (doprint)
		{		
			for (i=0;i<num-1;i++)
			{
				if (lastAng[i] == lastAng[i+1])
					continue;
					
				doprint = false;
				break;
			}
		}

		/*
			
			87	100
		*/
		
		if (doprint)
			[[level.print3dfunc]] ((bonus, 0, 0) + up + level.player.origin + right + forward, "testtest", (0.3,0.7,0.5), 1, 0.75);	// origin, text, RGB, alpha, scale
//		println (bonus, " ", angles[0], " ", angles[0] + 88);
		wait (0.05);
		for (i=num-1;i>0;i--)
			lastOrg[i] = lastOrg[i-1];
		for (i=num-1;i>0;i--)
			lastAng[i] = lastAng[i-1];
		
	}
}

/*
getFriendlySpot()
{
	dist = 99999999;
	finalSpot = undefined;
	for (i=0;i<level.friendlySpots.size;i++)
	{
		spot = level.friendlySpots[i];
		if (spot.used)
			continue;
					
		newdist = distance (self.origin, spot.origin);
		if (newdist > dist)
			continue;
		finalSpot = spot;
		dist = newdist;
	}
	
	// No place to go, or all taken.
	if (!isdefined (finalSpot))
		return;
	
	// Not far enough to be worth moving again.
	if (dist < 150)
		return;
	
	finalSpot.used = true;
	self setgoalpos (finalSpot.origin);
	self.goalradius = 256;
}
*/

/*
getFriendlyNode()
{
	dist = -1;
	friendlyNode = undefined;
	for (i=0;i<level.friendlyNodes.size;i++)
	{
		node = level.friendlyNodes[i];
		if (node.held)
			continue;
		newdist = distance (node.origin, self.origin);
		if ((newdist > dist) && (dist != -1))
			continue;
			
		dist = newdist;
		friendlyNode = node;
	}
	
	if (!isdefined (friendlyNode))
	{
		if (level.friendlySpots.size)
		{
			spot = level.friendlySpots[randomint(level.friendlySpots.size)];
			self setgoalpos (spot.origin);
			self.goalradius = 256;
		}
		return;
	}
	
	friendlyNode.held = true;
	self setgoalnode (friendlyNode);
	self.goalradius = 4;
}
*/

createLinesFromCurrentNode(startnode, endnode, ignoreNode, friendlyProgress)
{
	start = startnode.origin;
	end = endnode.origin;
	friendlyForwardDistance = level.friendlyForwardDistance; // How far ahead the friendlies go
	normal = vectorNormalize(end - start);
	vec = level.player.origin - start;
	progress = vectorDot (vec, normal);
	
	
	angles = vectortoangles(end - start);
	forward = anglestoforward (angles);
	forward = vectorScale(forward, progress);
	startPos = start + forward;
//	[[level.print3dfunc]] (startPos, "Player", (0.2, 0.8, 0.5), 1.95, 1.0);
	length = distance (end, start);
	if (progress <= 0)
		[[level.print3dfunc]] (startnode.origin, "Player", (0.2, 0.8, 0.5), 1.95, 1.0);
	else
	if (progress > length)
		[[level.print3dfunc]] (endnode.origin, "Player", (0.2, 0.8, 0.5), 1.95, 1.0);
	else
		[[level.print3dfunc]] (startPos, "Player", (0.2, 0.8, 0.5), 1.95, 1.0);

	progress+=friendlyForwardDistance;
	if (progress > friendlyProgress)
		friendlyProgress = progress;
		
	angles = vectortoangles(end - start);
	forward = anglestoforward (angles);
	forward = vectorScale(forward, friendlyProgress);
	startPos = start + forward;
	
	lookahead = level.lookahead;

	for (i=0;i<startnode.link.size;i++)
	{
		link = startnode.link[i];
		if (link == ignoreNode)
			continue;
		if (link != endnode)
			continue;
		if (!link.chainLinked)
		{
			endPos = link.origin;
			addFriendlySpot (startPos, endPos);
			continue;
		}

		drawLineDownPath(startnode, link, progress, 5000, false);
//		drawLineDownPath(startnode, link, progress);
	}
/*	
	if (friendlyProgress + lookahead < length)
	{
		// Draw a complete line because it doesn't reach the next node
		progress = lookahead;
		forward = anglestoforward (angles);
		forward = vectorScale(forward, progress);
		endPos = startPos + forward;
		line (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
		addFriendlySpot (startPos, endPos);
	}
	else
	if (friendlyProgress < length)
	{
		for (i=0;i<endnode.link.size;i++)
		{
			link = endnode.link[i];
			if (link == startnode)
				continue;

			dist = friendlyProgress + lookahead - length;
			angles = vectortoangles(link.origin - end);
			forward = anglestoforward (angles);
			forward = vectorScale(forward, dist);
			endPos = end + forward;
			line (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
			addFriendlySpot (startPos, endPos);
		}
	}
	else
	{
		progress = friendlyProgress - length;
		for (i=0;i<endnode.link.size;i++)
		{
			link = endnode.link[i];
			if (link == startnode)
				continue;

			drawLineDownPath(endnode, link, progress);
		}
	}
	*/
	return friendlyProgress;
}

createLinesFromLastNode(startnode, endnode, friendlyProgress)
{
	start = startnode.origin;
	end = endnode.origin;
	friendlyForwardDistance = level.friendlyForwardDistance; // How far ahead the friendlies go
	normal = vectorNormalize(end - start);
	vec = level.player.origin - start;
	progress = vectorDot (vec, normal);
	
	angles = vectortoangles(end - start);
	forward = anglestoforward (angles);
	forward = vectorScale(forward, progress);
	startPos = start + forward;

	length = distance (end, start);

	if (progress <= 0)
		[[level.print3dfunc]] (startnode.origin, "Player", (0.2, 0.8, 0.5), 1.95, 1.0);
	else
	if (progress > length)
		[[level.print3dfunc]] (endnode.origin, "Player", (0.2, 0.8, 0.5), 1.95, 1.0);
	else
		[[level.print3dfunc]] (startPos, "Player", (0.2, 0.8, 0.5), 1.95, 1.0);

	progress+=friendlyForwardDistance;
	if (progress > friendlyProgress)
		friendlyProgress = progress;
		
	angles = vectortoangles(end - start);
	forward = anglestoforward (angles);
	forward = vectorScale(forward, friendlyProgress);
	startPos = start + forward;
	
	lookahead = level.lookahead;
	if (friendlyProgress + lookahead < length)
	{
		progress = lookahead;
		forward = anglestoforward (angles);
		forward = vectorScale(forward, progress);
		endPos = startPos + forward;
		[[level.lineFunc]] (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
//		[[level.print3dfunc2]] (endPos + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
		addFriendlySpot (startPos, endPos);
	}
	else
	if (friendlyProgress < length)
	{
		for (i=0;i<endnode.link.size;i++)
		{
			link = endnode.link[i];
			if (link == startnode)
				continue;

			dist = friendlyProgress + lookahead - length;
			angles = vectortoangles(link.origin - end);
			forward = anglestoforward (angles);
			forward = vectorScale(forward, dist);
			endPos = end + forward;
			[[level.lineFunc]] (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
//			[[level.print3dfunc2]] (endPos + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
			addFriendlySpot (startPos, endPos);
		}
	}
	else
	{
		progress = friendlyProgress - length;
		for (i=0;i<endnode.link.size;i++)
		{
			link = endnode.link[i];
			if (link == startnode)
				continue;

			if (!link.chainLinked)
			{
				endPos = link.origin;
				addFriendlySpot (startNode.origin, endNode.origin);
				continue;
			}
			drawLineDownPath(endnode, link, progress, 5000, true); // was 0
		}
	}
	
	return friendlyProgress;
}

chooseFriendlySpot (node, range, dist)
{
	for (i=0;i<level.friendlySpots.size;i++)
	{
		
	}
}

testNode (node, range, dist)
{
	for (i=0;i<level.friendlySpots.size;i++)
	{
		spot = level.friendlySpots[i];
		if (distance (spot.origin, node.origin) > dist)
			continue;

		angle = spot.angle;
		nodeAngle = node.angles[1];
		failed = false;
		if (nodeAngle > angle + range)
			failed = true;
	
		if (nodeAngle < angle - range)
			failed = true;
			
		if (failed)
		{
			failed = false;
			nodeAngle += 360;
			if (nodeAngle > angle + range)
				failed = true;
	
			if (nodeAngle < angle - range)
				failed = true;
		}
		
		if (failed)
			continue;
			
		for (p=0;p<level.friendlyNodes.size;p++)
		{
			if (level.friendlyNodes[p] == node)
				return;
		}

		node.held = false;
		level.friendlyNodes[level.friendlyNodes.size] = node;
		
		level thread nodechoice(node);
	}
}

nodechoice(node)
{
	level endon ("stop drawing friendly node choice");
	for (;;)
	{
		[[level.print3dfunc]] (node.origin, "Node", (0.5, 0.2, 0.5), 0.95, 1.0);
		forward = anglestoforward (node.angles);
		forwardFar = vectorScale(forward, 30);
		forwardClose = vectorScale(forward, 20);
		right = anglestoright (node.angles);
		left = vectorScale(right, -10);
		right = vectorScale(right, 10);
		[[level.lineFunc]] (node.origin, node.origin + forwardFar, (0.9, 0.7, 0.6), 0.9);
		[[level.lineFunc]] (node.origin + forwardFar, node.origin + forwardClose + right, (0.9, 0.7, 0.6), 0.9);
		[[level.lineFunc]] (node.origin + forwardFar, node.origin + forwardClose + left, (0.9, 0.7, 0.6), 0.9);
		wait (0.05);
	}
}

drawLineDownPath(node, endNode, progress, progressCap, endLine)
{
	assert (endNode.chainlinked);
	
	if (progress > progressCap)
		progress = progressCap;
	dist = progress;
	angles = vectortoangles(endNode.origin - node.origin);
	forward = anglestoforward (angles);
	forward = vectorScale(forward, progress);
	startPos = node.origin + forward;
	lookahead = level.lookahead;
	length = distance (node.origin, endNode.origin);
	if (progress + lookahead < length)
	{
		dist = progress + lookahead;
		forward = anglestoforward (angles);
		forward = vectorScale(forward, dist);
		endPos = node.origin + forward;
		[[level.lineFunc]] (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
//		[[level.print3dfunc2]] (endPos + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
		addFriendlySpot (startPos, endPos);
	}
	else
	if (progress < length)
	{
		if (endNode.link.size > 1)
		{
			// Not a dead end, so spline it
			for (i=0;i<endNode.link.size;i++)
			{
				link = endNode.link[i];
				if (link == node)
					continue;
					
				if (!link.chainLinked)
				{
					endPos = link.origin;
					addFriendlySpot (startPos, endPos);
					continue;
				}
					
				dist = progress + lookahead - length;
				angles = vectortoangles(link.origin - endNode.origin);
				forward = anglestoforward (angles);
				forward = vectorScale(forward, dist);
				endPos = endNode.origin + forward;
				[[level.lineFunc]] (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
//				[[level.print3dfunc2]] (endPos + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
				addFriendlySpot (startPos, endPos);
			}
		}
		else
		{
			// Dead end so just draw past
			dist = progress + lookahead;
			forward = anglestoforward (angles);
			forward = vectorScale(forward, dist);
			endPos = node.origin + forward;
			if (progress > length)
				startPos = endNode.origin;
				
			[[level.lineFunc]] (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
//			[[level.print3dfunc2]] (endPos + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
			addFriendlySpot (startPos, endPos);
		}
	}
	else
	{
		if (endNode.link.size > 1)
		{
			// Exceeds the length of this connection so split down the way
			// Not a dead end, so spline it
//			[[level.print3dfunc2]] (endPos + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
			
			if (endLine && endNode.link.size > 2)
				addFriendlySpot (node.origin, endNode.origin);
			else
			{
				progress -= length;
				for (i=0;i<endnode.link.size;i++)
				{
					link = endnode.link[i];
					if (link == node)
						continue;
					if (!link.chainLinked)
					{
						endPos = link.origin;
						addFriendlySpot (startPos, endPos);
						continue;
					}
					drawLineDownPath(endnode, endnode.link[i], progress, 5000, endLine);
			//		drawLineDownPath(startnode, link, progress);
				}
			}
			
			/*
			progress -= length;
			for (i=0;i<endnode.link.size;i++)
			{
				link = endnode.link[i];
				if (link == node)
					continue;
				drawLineDownPath(endnode, endnode.link[i], progress, 5000);
		//		drawLineDownPath(startnode, link, progress);
			}
			else
			{
				// Not a dead end, so spline it
				dist = progress + lookahead;
				forward = anglestoforward (angles);
				forward = vectorScale(forward, dist);
				endPos = node.origin + forward;
				[[level.lineFunc]] (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
	//			[[level.print3dfunc2]] (endPos + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
				addFriendlySpot (startPos, endPos);
			}
			*/
		}
		else
		{
			// Dead end so just draw past
			dist = progress + lookahead;
			forward = anglestoforward (angles);
			forward = vectorScale(forward, dist);
			endPos = node.origin + forward;
			if (progress > length)
				startPos = endNode.origin;
			
			[[level.lineFunc]] (startPos + (0,0,5), endPos + (0,0,5), (0.9, 0.3, 0.1), 0.5);
//			[[level.print3dfunc2]] (endPos + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
			addFriendlySpot (startPos, endPos);
		}
	}
}

addFriendlySpot (startPos, endPos)
{
	ent = spawnstruct();
	trace = bulletTrace(endpos + (0,0,35), endpos + (0,0,-500), true, undefined);
	ent.origin = trace["position"];
//	thread showPoints(endpos + (0,0,35), endpos + (0,0,-500), trace["position"]);

	[[level.print3dfunc2]] (trace["position"] + (0,0,15), "ALLIES HERE", (0.5, 0.8, 0.9), 0.95, 1.0);
	
	angles = vectorToAngles(endPos - startPos);
	angle = angles[1];
	while (angle < 0)
			angle += 360;
	ent.angle = angle;

	ent.used = false;	
	level.friendlySpots[level.friendlySpots.size] = ent;
}

showPoints(start, end, point)
{
	for (;;)
	{
		line(start, end, (1,0,0), 1);
		print3d (point, "x", (1,0.2,0), 1,1);
		
		wait (0.05);
	}
}

linenone (start, end, color, alpha)
{
}

linepassthrough (start, end, color, alpha)
{
	thread startLine(start, end, color, alpha);
}

startLine(start, end, color, alpha)
{
	level endon ("new_friendly_frame");
	
	for (;;)
	{
		line(start, end, color, alpha);
		wait (0.05);
	}
}

print3dnone (org, msg, color, alpha, size)
{
}

print3dpassthrough (org, msg, color, alpha, size)
{
	thread startprint3d (org, msg, color, alpha, size);
}

startprint3d (org, msg, color, alpha, size)
{
	level endon ("new_friendly_frame");
	
	for (;;)
	{
		print3d (org, msg, color, alpha, size);
		wait (0.05);
	}
}


debugCvars()
{
	/#
	level.waypointExtraDebug = false;
	if (getdebugcvar ("debug_waypoint") != "on")
		setcvar ("debug_waypoint", "off");
	
	debugging = false;

	for (;;)
	{		
		level.print3dfunc = ::print3dnone;
		level.print3dfunc2 = ::print3dnone;
		level.linefunc = ::linenone;
		level.waypointExtraDebug = false;
		
		if (getdebugcvar ("debug_waypoint") == "on")
		{
			debugging = true;
			level.print3dfunc = ::print3dpassthrough;
			level.linefunc = ::linepassthrough;
			level.print3dfunc2 = ::print3dpassthrough;
			level.waypointExtraDebug = true;
		}
		else
		if (debugging)
		{
			debugging = false;
			level notify ("stop_drawing_heading");
		}
		wait (1);
	}
	#/
	
}

squads()
{
	init(false);
}

getNextNodes(lastPos, currentPos)
{
	heading = level.waypointHeading;
	currentNode = heading[0];		
	dist = distance (currentPos, currentNode.origin);
	for (i=1;i<heading.size;i++)
	{
		header = heading[i];
		if (!header.chainLinked)
			continue;
		newdist = distance (currentPos, header.origin);
		if (newdist > dist)
			continue;
			
		dist = newdist;
		currentNode = heading[i];
	}
	
	lastNode = currentNode.link[0];
	dist = distance (lastPos, lastNode.origin);
	for (i=1;i<currentNode.link.size;i++)
	{
		node = currentNode.link[i];
		if (!node.chainLinked)
			continue;
		newdist = distance (lastPos, node.origin);
		if (newdist > dist)
			continue;
			
		dist = newdist;
		lastNode = node;
	}
	
	nextNodes = [];
	for (i=0;i<currentNode.link.size;i++)
	{
		if (currentNode.link[i] != lastNode)
			nextNodes[nextNodes.size] = currentNode.link[i];
	}
	ent = spawnstruct();
	ent.currentNode = currentNode;
	ent.lastNode = lastNode;
	ent.nextNodes = nextNodes;
	return ent;
}

passedCurrentNode(start, middle, end, curpos)
{
	normal = vectorNormalize(middle - start);
	vec = curpos - start;
	progressFromStartTomiddle = vectorDot (vec, normal);
	lengthFromStartTomiddle = distance (middle, start);
	distanceToMiddle = lengthFromStartToMiddle - progressFromStartToMiddle;
	
	normal = vectorNormalize(end - middle);
	vec = curpos - middle;
	progressFromMiddleToEnd = vectorDot (vec, normal);
//	lengthFrommiddleToend = distance (middle, end);
	
	// Bias the middle to end progress because you're really just trying to check if progress towards end is 
	// significantly positive 
	return (distanceToMiddle < (progressFromMiddleToEnd*2));
//	return (progress > length);
}

drawHeading (heading)
{
	level notify ("stop_drawing_heading");
	level endon ("stop_drawing_heading");
	for (;;)
	{
		for (i=0;i<heading.size;i++)
		{
			header = heading[i];
			if (!header.chainLinked)
				continue;
			for (p=0;p<header.link.size;p++)
			{
				if (!header.link[p].chainLinked)
					continue;
				line (header.origin + (0,0,-10), header.link[p].origin + (0,0,-10), (0.3, 0.43, 0.5), 0.5);
			}
		}
		wait (0.05);
	}
}