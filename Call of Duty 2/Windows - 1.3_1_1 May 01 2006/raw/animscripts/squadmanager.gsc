// squadmanager.gsc

/****************************************************************************
 initialization
*****************************************************************************/

// initializes the squad management system
init_squadManager()
{
	if (isdefined (anim.squadInitialized) && anim.squadInitialized)
		return;
		
	anim.squadCreateFuncs = [];
	anim.squadCreateStrings = [];
	
	anim.squads = [];
	anim.squadIndex = [];
	anim.squadRand = 0;

	anim.squadInitialized = true;	
}

/****************************************************************************
 functionality
*****************************************************************************/

createSquad (squadName)
{
	assertex (!isdefined (anim.squads[squadName]), "createSquad attempted to create a squad with the same name as an existing squad");
	
	anim.squads[squadName] = spawnstruct();
	squad = anim.squads[squadName];
	squad.squadName = squadName;

	squad.sightTime = 0;
	squad.origin = undefined;
	squad.forward = undefined;
	squad.enemy = undefined;
	squad.isInCombat = false;
	
	squad.memberCount = 0;
	squad.members = [];
	squad.officers = [];
	squad.officerCount = 0;
	squad.squadList = [];

	squad.memberAddFuncs = [];
	squad.memberAddStrings = [];
	squad.memberRemoveFuncs = [];
	squad.memberRemoveStrings = [];
	squad.squadUpdateFuncs = [];
	squad.squadUpdateStrings = [];
	squad.squadID = anim.squadIndex.size;
	
	squad initState ("combat", 0.75);
	squad initState ("cover", 0.75);
	squad initState ("move", 0.75);
	squad initState ("stop", 0.75);
	squad initState ("death", 0.75);
	squad initState ("suppressed", 0.75);
	squad initState ("attacking", 0.5);
	
	// add this squad to the global index
	anim.squadIndex[anim.squadIndex.size] = squad;
	
	squad updateSquadList();
	
	// notifies for other scripts
	level notify ("squad created " + squadName);
	anim notify ("squad created " + squadName);

	for (i = 0; i < anim.squadCreateFuncs.size; i++)
	{
		squadCreateFunc = anim.squadCreateFuncs[i];
		squad thread [[squadCreateFunc]] ();
	}
	
	// battlechatter init
//	squad animscripts\battlechatter::init_squadBattleChatter();
	
	// tell all other squads to add us to their lists
	for (i = 0; i < anim.squadIndex.size; i++)
		anim.squadIndex[i] updateSquadList();
	
	squad thread updateWaiter();
	squad thread squadTracker();
	squad thread officerWaiter();
	squad thread updateMemberStates();
	return (squad);
}

deleteSquad (squadName)
{
	assertex (isdefined (anim.squads[squadName]), "deleteSquad attempted to delete a squad that does not exist");

	if (squadName == "axis" || squadName == "allies")
		return;

	squadID = anim.squads[squadName].squadID;
	squad = anim.squads[squadName];
	
//	for (i = 0; i < squad.members.size; i++)
	while (squad.members.size)
		squad.members[0] addToSquad(squad.members[0].team);

	anim.squadIndex[squadID] = anim.squadIndex[anim.squadIndex.size - 1];
	anim.squadIndex[squadID].squadID = squadID;
	anim.squadIndex[anim.squadIndex.size - 1] = undefined;

	anim.squads[squadName] = undefined;
	
	level notify ("squad deleted " + squadName);
	anim notify ("squad deleted " + squadName);

	for (i = 0; i < anim.squadIndex.size; i++)
		anim.squadIndex[i] updateSquadList();
}

generateSquadName()
{
	squadName = "auto" + anim.squadRand;
	anim.squadRand++;
	
	return (squadName);
}

addPlayerToSquad (squadName)
{
	if (!isdefined (squadName))
	{
		if (isdefined (self.script_squadname))
			squadName = self.script_squadname;
		else
			squadName = self.team;
	}

	if (!isdefined (anim.squads[squadName]))
		anim createSquad (squadName);
	
	squad = anim.squads[squadName];
		
	self.squad = squad;
	
//	self.squad updateOrigin();
}

// adds the ai that calls the function to the specified squad
// if not squad is specified, the ai is added to one of the defaults
squadChange()
{
	self endon ("death");
	wait (10.0); // ???

	if (!isdefined (self.script_squadname))
		squadName = (self.team + self.script_flanker);
	else
		squadName = (self.script_squadname + self.script_flanker);

	self addToSquad (squadName);
}

addToSquad (squadName)
{
	assertex (issentient (self), "addToSquad attempted to add a non-sentient member to a squad");
	
	if (!isdefined (squadName) && isdefined (self.script_flanker))
		self thread squadChange();
	
	if (!isdefined (squadName))
	{
		if (isdefined (self.script_squadname))
			squadName = self.script_squadname;
		//else if (isdefined (self.script_squad))
		//	squadName = self.script_squad;
		else
			squadName = self.team;
	}

	if (!isdefined (anim.squads[squadName]))
		anim createSquad (squadName);	
	
	squad = anim.squads[squadName];
	
	if (isdefined (self.squad))
	{
		if (self.squad == squad)
			return;
		else
			self removeFromSquad();
	}		

	// move to init.gsc
	self.lastEnemySightTime = 0;
	self.combatTime = 0;
	// end move
	
	self.squad = squad;
	self.memberID = squad.members.size;
	squad.members[self.memberID] = self;	
	squad.memberCount = squad.members.size;

	// this is handled in wait for loadout function
	if (isdefined(level.loadoutComplete) && level.loadoutComplete)
	{
		if (self.team == "allies" && self isOfficer())
			self addOfficerToSquad();
	}
	
//	self.squad updateOrigin();

	for (i = 0; i < self.squad.memberAddFuncs.size; i++)
	{
		memberAddFunc = self.squad.memberAddFuncs[i];
		self thread [[memberAddFunc]] (self.squad.squadName);
	}

	self thread memberCombatWaiter();
	self thread memberDeathWaiter();
}

removeFromSquad()
{
	assertex (isdefined (self.squad), "removeFromSquad attempted to remove a member who was not part of a squad (self.squad == undefined)");

	squad = self.squad;
	memberID = -1;
	
	if (isdefined (self))
	{
		memberID = self.memberID;
	}
	else
	{
		for (i = 0; i < squad.members.size; i++)
		{
			if (squad.members[i] == self)
				memberID = i;
		}
	}

	assertex (memberID > -1, "removeFromSquad could not find memberID");

	if (memberID != squad.members.size - 1)
	{
		other = squad.members[squad.members.size - 1];
		squad.members[memberID] = other;
		if (isdefined (other))
			other.memberID = memberID;
	}
	
	squad.members[squad.members.size - 1] = undefined;
	squad.memberCount = squad.members.size;
	
	if (isdefined (self.officerID))
		self removeOfficerFromSquad();
	
	for (i = 0; i < self.squad.memberRemoveFuncs.size; i++)
	{
		memberRemoveFunc = self.squad.memberRemoveFuncs[i];
		self thread [[memberRemoveFunc]] (squad.squadName);
	}
	
	assert (squad.members.size == squad.memberCount);
	
	if (squad.memberCount == 0)
		deleteSquad (squad.squadName);

	if (isdefined (self))
	{
		self.squad = undefined;
		self.memberID = undefined;
	}

	self notify ("removed from squad");	
}

addOfficerToSquad()
{
	squad = self.squad;
	
	if (isdefined (self.officerID))
		return;

	assertex (!isdefined (self.officerID), "addOfficerToSquad attempted to add a member that is already in an officers");
	
	self.officerID = squad.officers.size;
	squad.officers[self.officerID] = self;
	squad.officerCount = squad.officers.size;
}

removeOfficerFromSquad()
{
	squad = self.squad;
	officerID = -1;
	
	if (isdefined (self))
	{
		officerID = self.officerID;
	}
	else
	{
		for (i = 0; i < squad.officers.size; i++)
		{
			if (squad.officers[i] == self)
				officerID = i;
		}
	}

	assertex (officerID > -1, "removeOfficerFromSquad could not find officerID");

	if (officerID != squad.officers.size - 1)
	{
		other = squad.officers[squad.officers.size - 1];
		squad.officers[officerID] = other;
		if (isdefined (other))
			other.officerID = officerID;
	}
	
	squad.officers[squad.officers.size - 1] = undefined;
	squad.officerCount = squad.officers.size;
	
	assert (squad.officers.size == squad.officerCount);
	
	if (isdefined (self))
		self.officerID = undefined;

}

/****************************************************************************
 trackers/waiters
*****************************************************************************/

officerWaiter()
{
	if (!isdefined (level.loadoutComplete))
		anim waittill ("loadout complete");
	
	for (i = 0; i < self.members.size; i++)
	{
		if (self.members[i] isOfficer())
			self.members[i] addOfficerToSquad();
	}		
}

updateWaiter()
{
	while (1)
	{
		anim waittill ("squadupdate", action);
		
		switch (action)
		{
		case "squadlist":
			self updateSquadList();
			break;
		case "combat":
			self updateCombat();
			break;
		case "origin":
			self updateOrigin();
			break;
		case "forward":
			self updateHeading();
			break;
		}
	}
}

squadTracker()
{ 
	anim endon ("squad deleted " + self.squadName);
	// even with the long wait time, this is a crappy way to track things
	// ideally the updateFunctions would only be called when another function needs to know the status of something
	// rather than polling like it's doing now.
	while (1)
	{
		// combat can be removed
		self updateAll();
		
		wait (0.1);
	}
}

memberDeathWaiter()
{
//	self notify ("squad change");
	self endon ("removed from squad");

	self waittill ("death", attacker);

	if (isdefined (self))
		self.attacker = attacker;
	self removeFromSquad();
}

memberCombatWaiter()
{
//	self notify ("squad change");
	self endon ("removed from squad");

	while (1)
	{
		self waittill ("enemy");
		
		if (!isdefined (self.enemy))
			self.squad notify ("squadupdate", "combat");
		else
			self.squad.isInCombat = true;
			
		wait ( 0.05 );
	}
}

/****************************************************************************
 utility
*****************************************************************************/

updateHeading()
{
	if (isdefined (self.enemy))
	{
		self.forward = vectornormalize (self.enemy.origin - self.origin);
		return;
	}
	
	newHeading = (0, 0, 0);
	numInfluences = 0;
	
	for (i = 0; i < self.members.size; i++)
	{
		if (!isalive (self.members[i]))
			continue;
		// logic here to prune out separated members... otherwise origin could be too vague
		newHeading += anglestoforward (self.members[i].angles);
		numInfluences++;	
	}
	
	if (numInfluences)
		self.forward = (newHeading[0] / numInfluences, newHeading[1] / numInfluences, newHeading[2] / numInfluences);
	else
		self.forward = newHeading;
}

updateOrigin()
{
	newOrigin = (0, 0, 0);
	numInfluences = 0;
	
	for (i = 0; i < self.members.size; i++)
	{
		// logic here to prune out separated members... otherwise origin could be too vague

//		assertex (isdefined (self.members[i]), "updateOrigin run while a squad member was undefined");		
		if (!isalive (self.members[i]))
			continue;

		newOrigin += self.members[i].origin;
		numInfluences++;	
	}
	
	if (numInfluences)
		self.origin = (newOrigin[0] / numInfluences, newOrigin[1] / numInfluences, newOrigin[2] / numInfluences);
	else
		self.origin = newOrigin;
}

updateCombat()
{
	self.isInCombat = false;

	// reset squad contact status
	for (i = 0; i < anim.squadIndex.size; i++)
		self.squadList[anim.squadIndex[i].squadName].isInContact = false;

	for (i = 0; i < self.members.size; i++)
	{
		if (isdefined (self.members[i].enemy) && isdefined (self.members[i].enemy.squad) && self.members[i].combatTime > 0)
			self.squadList[self.members[i].enemy.squad.squadName].isInContact = true;
	}
}

updateEnemy()
{
	curEnemy = undefined;
	for (i = 0; i < self.members.size; i++)
	{
		if (isdefined (self.members[i].enemy) && isdefined (self.members[i].enemy.squad))
		{
			if (!isdefined (curEnemy))
				curEnemy = self.members[i].enemy.squad;
			else if (self.members[i].enemy.squad.memberCount > curEnemy.memberCount)
				curEnemy = self.members[i].enemy.squad;
		}
	}

	self.enemy = curEnemy;
}

updateAll()
{
	newOrigin = (0, 0, 0);
	numInfluences = 0;
	curEnemy = undefined;
	isInCombat = false;

	self updateCombat();
	
	for (i = 0; i < self.members.size; i++)
	{
		if (!isalive (self.members[i]))
			continue;
			
		// logic here to prune out separated members... otherwise origin could be too vague
		newOrigin += self.members[i].origin;
		numInfluences++;
		
		if (isdefined (self.members[i].enemy) && isdefined (self.members[i].enemy.squad))
		{
			if (!isdefined (curEnemy))
				curEnemy = self.members[i].enemy.squad;
			else if (self.members[i].enemy.squad.memberCount > curEnemy.memberCount)
				curEnemy = self.members[i].enemy.squad;
		}
	}

	if (numInfluences)
		self.origin = (newOrigin[0] / numInfluences, newOrigin[1] / numInfluences, newOrigin[2] / numInfluences);
	else
		self.origin = newOrigin;

	self.isInCombat = isInCombat;
	self.enemy = curEnemy;
	
	// integreate this at some point
	self updateHeading();
}

updateSquadList()
{
	for (i = 0; i < anim.squadIndex.size; i++)
	{
		if (!isdefined (self.squadList[anim.squadIndex[i].squadName]))
		{
			self.squadList[anim.squadIndex[i].squadName] = spawnstruct();
			self.squadList[anim.squadIndex[i].squadName].isInContact = false;		
		}
		
		for (j = 0; j < self.squadUpdateFuncs.size; j++)
		{
			squadUpdateFunc = self.squadUpdateFuncs[j];
			self thread [[squadUpdateFunc]] (anim.squadIndex[i].squadName);
		}
	}
}

printAboveHead (string, duration, offset, color)
{
	self endon ("death");
	
	if (!isdefined (offset))
		offset = (0, 0, 0);
	if (!isdefined (color))
		color = (1,0,0);
		
	for(i = 0; i < (duration * 2); i++)
	{
		if (!isalive (self))
			return;
			
		aboveHead = self GetEye() + (0,0,10) + offset;
		print3d (aboveHead, string, color, 1, 0.5);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}	
}

isOfficer()
{
	fullRank = self animscripts\battlechatter::getRank();
	
	if (fullRank == "sergeant" || fullRank == "lieutenant" || fullRank == "captain" || fullRank == "sergeant")
		return (true);
		
	return (false);
}


/****************************************************************************
 ai functions
*****************************************************************************/

aiUpdateAnimState (animscript)
{
	switch (animscript)
	{
	case "aim":
	case "l33t truckride combat":
		self.anim_state = "combat";
		break;
		
	case "concealment_crouch":
	case "concealment_prone":
	case "concealment_stand":
	case "cover_crouch":
	case "cover_left":
	case "cover_prone":
	case "cover_right":
	case "cover_stand":
	case "cover_wide_left":
	case "cover_wide_right":
	case "stalingrad_cover_crouch":
		self.anim_state = "cover";
		break;

	case "combat":
	case "move":
	case "stop":
	case "death":
		self.anim_state = animscript;
		break;

	case "grenadecower":
	case "pain":
		break;
		
	}
}

/****************************************************************************
 squad functions
*****************************************************************************/

updateStates()
{
	self resetState ("combat");
	self resetState ("cover");
	self resetState ("move");
	self resetState ("stop");
	self resetState ("death");
	self resetState ("suppressed");
	self resetState ("attacking");

	for (i = 0; i < self.members.size; i++)
	{
		if (!isalive (self.members[i]))
			continue;	
	
		self queryMemberAnimState (self.members[i]);
		self queryMemberState (self.members[i], "suppressed");
		self queryMemberState (self.members[i], "combat");
		self queryMemberState (self.members[i], "attacking");
		self queryMemberState (self.members[i], "cover");
	}
}

updateMemberStates()
{
	anim endon ("squad deleted " + self.squadName);
		
	timeSlice = 0.05;
	while (1)
	{
		for (i = 0; i < self.members.size; i++)
		{
			if (!isalive (self.members[i]))
				continue;	
		
			self.members[i] aiUpdateCombat(timeSlice);
			self.members[i] aiUpdateSuppressed(timeSlice);
		}
		
		wait (timeSlice);
	}
}

aiUpdateCombat(timeSlice)
{
	if (isdefined (self.lastEnemySightPos))
	{
		if (self.combatTime < 0)
			self.combatTime = timeSlice;
		else
			self.combatTime += timeSlice;

		self.lastEnemySightTime = gettime();
		return;
	}
	else if (self issuppressed())
	{
		self.combatTime += timeSlice;
		return;
	}

	if (self.combatTime > 0)
		self.combatTime = (0 - timeSlice);
	else
		self.combatTime -= timeSlice;
}

aiUpdateSuppressed(timeSlice)
{
	if (self.suppressed)
	{
		if (self.suppressedTime < 0)
			self.suppressedTime = timeSlice;
		else
			self.suppressedTime += timeSlice;
			
		return;
	}
	
	if (self.suppressedTime > 0)
		self.suppressedTime = (0 - timeSlice);
	else
		self.suppressedTime -= timeSlice;
}

initState (state, activateRatio)
{
	self.squadStates[state] = spawnstruct();
	self.squadStates[state].activateRatio = activateRatio;
	self.squadStates[state].isActive = false;
	self.squadStates[state].numActive = 0;
}

resetState (state)
{
	self.squadStates[state].isActive = false;
	self.squadStates[state].numActive = 0;
}

queryMemberAnimState (member)
{
	self.squadStates[member.anim_state].numActive++;
	if (self.squadStates[member.anim_state].numActive > (self.squadStates[member.anim_state].activateRatio * self.members.size))
		self.squadStates[member.anim_state].isActive = true;
}

queryMemberState (member, state)
{
	switch (state)
	{
	case "suppressed":
		if (member.suppressedTime > 1.0)
			self.squadStates[state].numActive++;
		break;
	case "combat":
		if (member.combatTime > 0.0)
			self.squadStates[state].numActive++;
		break;
	case "attacking":
		if (gettime() < member.lastShootTime + 2000)
			self.squadStates[state].numActive++;
		break;
	case "cover":
		if (!member animscripts\battlechatter::isExposed())
			self.squadStates[state].numActive++;
		break;
	}
	if (self.squadStates[state].numActive > (self.squadStates[state].activateRatio * self.members.size))
		self.squadStates[state].isActive = true;
}
