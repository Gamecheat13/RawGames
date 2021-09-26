/*
^vectorScale (vec, scale)
	Returns the vector that is passed, scaled by the amount specified;

^array_notify (ents, notify)
	Passes a notify to each of the ents in an array.

^array_thread (ents, process, var, excluders)
	Each of the ents in array "ents" runs the thread "process". Optional "var" gets	passed
	with the function. Optional array of entities "excluders" do not run the thread.

^array_levelthread (ents, process, var, excluders);
	Has the level start the thread "process" with each of the ents in the array "ents". Optional "var" gets
	passed with the function. Optional array of entities "excluders" do not run the thread.

^set_forcegoal()
	makes an ai blindly run to his goal

^unset_forcegoal()
	Returns an ai danger awareness to normal.

^error(msg)
	Stops the script and prints the specified message. Basically asserts things are true.

^levelStartSave()
	Saves the begining of level autosave used for restarting the level.

^autosave(num)
	Saves with the specified save number (from _autosave.gsc).

^debug_message (msg, org)
	If cvar debug is 1, prints the message in 3d at the specified origin.

^chain_off (chain)
	Turns off the friendly chain trigger that has "script_chain" of this string. STRING.

^chain_on (chain)
	Turns on the friendly chain trigger that has "script_chain" of this string. STRING.

^living_ai_wait_for_min (touchable, team, num, timer)
	Script stops here until enough "num" of a given "team" are touching "touchable".
	Gives up if the optional timer elapses.

^living_ai_wait (touchable, team, include)
	Script stops here until all ai of "team" are touching "touchable". If health is passed as "include" then the
	script will wait until the health is gone or the player has at least 85% health.

^living_ai_is_here (touchable, team)
	Returns true if ai of the given team is alive here.

^precache (model)
	Precaches a given model.

^add_to_array ( array, ent )
	Adds "ent" to "array". Useful for easily constructing an array of different entities.

^getClosestAI (org, team, excluders)
	Returns the closest ai of "team" to the origin "org". Excludes an array of entities "excluders".

^magic_bullet_shield()
	Usage "Actor thread magic_bullet_shield();".
	Makes the actor get ignored by AI for 5 seconds if he is shot, and have infinite health.

^get_vehicle_group()
	Returns an array of spawners which have the same script_vehiclegroup as self

^array_randomize()
	Note it is used like "array = shuffle_array_members(array);".

^flood_spawn (spawners)
	Tells the spawners that are passed to spawn AI whenever their currently spawned AI die. Like "flood_spawner" trigger.

^vectorMultiply (vec, dif)
	multiply a vector

^Random (array)
	Returns a random entree from an array

^get_friendly_chain_node (chainstring)
	Returns a node targetted by a friendly trigger with this string for its script_friendlychain

^waittill_multiple (string1, string2, string3, string4, string5)
	Causes an entity to wait for multiple notifies to occur before progressing.

^waittill_any (string1, string2, string3, string4, string5)
	Causes an entity to wait for any of a collection of strings to be notified.

^keyHintPrint(message, binding)
	Prints a key press hint message

*/


triggerOff()
{
	if (!isdefined (self.realOrigin))
		self.realOrigin = self.origin;

	if (self.origin == self.realorigin)
		self.origin += (0, 0, -10000);
}

triggerOn()
{
	if (isDefined (self.realOrigin) )
		self.origin = self.realOrigin;
}

levelStartSave()
{
	if ( level.missionfailed )
		return;
		
	if ( level.isSaving )
		return;
		
	level.isSaving = true;
		
	imagename = "levelshots/autosave/autosave_" + level.script + "start";
//	println ("z:         imagename: ", imagename);

	// "levelstart" is recognized by the saveGame command as a special save game
	saveGame("levelstart", &"AUTOSAVE_LEVELSTART", imagename);
	thread spam_death_dvar_removal();
	println ("Saving level start saved game");
	
	level.isSaving = false;
}

spam_death_dvar_removal()
{
	for (i=0;i<4;i++)
	{
    	setcvar("ui_grenade_death","0"); // the grenade death gets disabled at the beginning of each save
    	wait (0.05);
	}
}


levelEndSave()
{
	if ( level.missionfailed )
		return;

	if ( level.isSaving )
		return;

	if ( !isAlive( level.player ) )
		return;
		
	level.isSaving = true;
		
	imagename = "levelshots/autosave/autosave_" + level.script + "start";

	// "levelstart" is recognized by the saveGame command as a special save game
	saveGame("levelend", &"AUTOSAVE_AUTOSAVE", imagename);
	
	level.isSaving = false;
}

autosave(num)
{
	if (gettime() < 3000) // no reason to save so early in the level given that the game automatically autosaves
		return; 
	savedescription =  maps\_autosave::getnames(num);
	imagename = "levelshots/autosave/autosave_" + level.script + num;

	level thread maps\_autosave::tryAutoSave(num, savedescription, imagename);
	
//	/#level thread tempAutoSaveTry();#/
}

tempAutoSaveTry()
{
	level notify ("temp autosave try");
	level endon ("temp autosave try");

	while (1)
	{
		wait (2.0);
		if (maps\_autosave::autoSaveCheck())
		{
			wait (3.0);
			if (maps\_autosave::autoSaveCheck())
				println ("autosave success: passed all checks");
			else
				println ("autosave invalid: 3 second rule");
		}
	}
}

autoSaveByName(name)
{
	if (!isdefined (level.curAutoSave))
		level.curAutoSave = 1;
		
	saveDescription =  maps\_autosave::getDescriptionByName(name);
	imageName = "levelshots/autosave/autosave_" + level.script + level.curAutoSave;

	result = level maps\_autosave::tryAutoSave(level.curAutoSave, savedescription, imagename);
	if (isdefined (result) && result)
		level.curAutoSave++;
}

error(msg)
{
	println ("^c*ERROR* ", msg);
	maps\_spawner::waitframe();

/#
	if (getdebugcvar ("debug") != "1")
		assertmsg("This is a forced error - attach the log file");
#/
}

set_forcegoal()
{
	//safety check just incase set_forcegoal is called multiple times before unset_forcegoal
	if(!isdefined(self.set_forcedgoal))
	{
		self.oldfightdist = self.pathenemyfightdist;
		self.oldmaxdist = self.pathenemylookahead;
		self.oldmaxsightdistsqrd = self.maxsightdistsqrd;
	//	self.oldgrenadeawareness = self.grenadeawareness;
	}
	else if(self.set_forcedgoal == false)
	{
		self.oldfightdist = self.pathenemyfightdist;
		self.oldmaxdist = self.pathenemylookahead;
		self.oldmaxsightdistsqrd = self.maxsightdistsqrd;
	//	self.oldgrenadeawareness = self.grenadeawareness;
	}
	self.pathenemyfightdist = 8;
	self.pathenemylookahead = 8;
	self.maxsightdistsqrd = 1;
//	self.grenadeawareness = 0;
	self.set_forcedgoal = true;
}

unset_forcegoal()
{
	if(!isdefined(self.set_forcedgoal))
		return;
	self.pathenemyfightdist = self.oldfightdist;
	self.pathenemylookahead = self.oldmaxdist;
	self.maxsightdistsqrd = self.oldmaxsightdistsqrd;
	//self.grenadeawareness = self.oldgrenadeawareness;	
	self.set_forcedgoal = false;
}

forceGoal( state )
{
	if ( state )
	{
		if ( isDefined( self.overrideGoal ) )
			return;
		
		self.overrideGoal = true;
		self.old.pathenemyfightdist = self.pathenemyfightdist;
		self.old.pathenemylookahead = self.pathenemylookahead;
		self.old.maxsightdistsqrd = self.maxsightdistsqrd;
		self.old.pacifist = self.pacifist;
	}
	else
	{
		if ( !isDefined( self.overrideGoal ) )
			return;

		self.overrideGoal = undefined;
		self.pathenemyfightdist = self.old.pathenemyfightdist;
		self.pathenemylookahead = self.old.pathenemylookahead;
		self.maxsightdistsqrd = self.old.maxsightdistsqrd;
		self.pacifist = self.old.pacifist;
	}
}

array_levelthread (ents, process, var, excluders)
{
	exclude = [];
	for (i=0;i<ents.size;i++)
		exclude[i] = false;

	if (isdefined (excluders))
	{
		for (i=0;i<ents.size;i++)
		for (p=0;p<excluders.size;p++)
		if (ents[i] == excluders[p])
			exclude[i] = true;
	}

	for (i=0;i<ents.size;i++)
	{
		if (!exclude[i])
		{
			if (isdefined (var))
				level thread [[process]](ents[i], var);
			else
				level thread [[process]](ents[i]);
		}
	}
}

array_thread (ents, process, var, excluders)
{
	exclude = [];
	for (i=0;i<ents.size;i++)
		exclude[i] = false;

	if (isdefined (excluders))
	{
		for (i=0;i<ents.size;i++)
		for (p=0;p<excluders.size;p++)
		if (ents[i] == excluders[p])
			exclude[i] = true;
	}

	for (i=0;i<ents.size;i++)
	{
		if (!exclude[i])
		{
			if (isdefined (var))
				ents[i] thread [[process]](var);
			else
				ents[i] thread [[process]]();
		}
	}
}

array_add ( array, ent )
{
	array[array.size] = ent;
	return array;
}

array_removeDead (array)
{
	newArray = [];
	for(i = 0; i < array.size; i++)
	{
		if (!isalive(array[i]))
			continue;
		newArray[newArray.size] = array[i];
	}

	return newArray;
}

array_removeUndefined (array)
{
	newArray = [];
	for(i = 0; i < array.size; i++)
	{
		if (!isdefined(array[i]))
			continue;
		newArray[newArray.size] = array[i];
	}

	return newArray;
}

array_remove (ents, remover)
{
	newents = [];
	for(i = 0; i < ents.size; i++)
	{
		if(ents[i] != remover)
			newents[newents.size] = ents[i];
	}

	return newents;
}

array_notify (ents, notifier)
{
	for (i=0;i<ents.size;i++)
		ents[i] notify (notifier);
}

vectorScale (vec, scale)
{
	vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
	return vec;
}

debug_message (msg, org, duration)
{
	if (!isdefined (duration))
		duration = 5;
		
	for (i=0;i<duration*20;i++)
	{
		print3d ((org + (0, 0, 45)), msg, (0.48,9.4,0.76), 0.85);
		wait (0.05);
	}
}

debug_message_clear (msg, org, duration, extraEndon)
{
	if (isdefined (extraEndon))
	{
		level notify (msg + extraEndon);
		level endon (msg + extraEndon);
	}
	else
	{
		level notify (msg);
		level endon (msg);
	}
	
	if (!isdefined (duration))
		duration = 5;
		
	for (i=0;i<duration*20;i++)
	{
		print3d ((org + (0, 0, 45)), msg, (0.48,9.4,0.76), 0.85);
		wait (0.05);
	}
}

chain_off (chain)
{
	trigs = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigs.size;i++)
	if ((isdefined (trigs[i].script_chain)) && (trigs[i].script_chain == chain))
	{
		if (isdefined (trigs[i].oldorigin))
			trigs[i].origin = trigs[i].oldorigin;
		else
			trigs[i].oldorigin = trigs[i].origin;

		trigs[i].origin = trigs[i].origin + (0,0,-5000);
	}
}

chain_on (chain)
{
	trigs = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigs.size;i++)
	if ((isdefined (trigs[i].script_chain)) && (trigs[i].script_chain == chain))
	{
		if (isdefined (trigs[i].oldorigin))
			trigs[i].origin = trigs[i].oldorigin;
	}
}

// Script stops here until the requisite AI of a given team are here
//	Gives up if the optional timer elapses
living_ai_wait_for_min (touchable, team, num, timer)
{
	if (isdefined (timer))
	{
		timer = gettime() + timer;
		while (gettime() < timer)
		{
			total = 0;
			ai = getaiarray (team);
			if (ai.size >= num)
			{
				for (i=0;i<ai.size;i++)
				{
					if ((ai[i] istouching (touchable)) && (isalive (ai[i])))
						total++;
				}
			}

			if (total >= num)
				break;
			else
				wait (1);
		}
		return;
	}

	while (1)
	{
		total = 0;
		ai = getaiarray (team);
		if (ai.size >= num)
		{
			for (i=0;i<ai.size;i++)
			{
				if ((ai[i] istouching (touchable)) && (isalive (ai[i])))
					total++;
			}
		}

		if (total >= num)
			break;
		else
			wait (1);
	}
}


death_wait_notify (ent)
{
	ent waittill ("death");
	self.ai_size--;
	println ("^5 ai died.. ", self.ai_size, " left");
	if (self.ai_size <= 0)
		self notify ("dead_autosave");
}

living_ai_wait (touchable, team, include)	// Script stops here until all the AI of a given team are dead
{
	while (1)
	{
		ents = [];
		ai = getaiarray (team);
		for (i=0;i<ai.size;i++)
		{
			if (ai[i] istouching (touchable))
				ents[ents.size] = ai[i];
		}

		if (ents.size <= 0)
			break;
			
		tracker = spawnstruct();
		tracker.ai_size = ents.size;

		for (i=0;i<ents.size;i++)
			tracker thread death_wait_notify(ents[i]);

		tracker waittill ("dead_autosave");
		if (!isdefined (include))
			continue;
	}
	
	if (!isdefined (include))
		return;
					
	while (1)
	{
		breaker = true;
		for (i=0;i<include.size;i++)
		{
			if (!isdefined (include[i]))
				continue;

			if (isdefined (include[i].model))
			{
				current_health = (level.player.health * 100) / level.player.maxhealth;
				if (current_health > 40)
					breaker = true;
				else
					breaker = false;
			}
			else
				breaker = false;
		}

		if (breaker)
			break;

		wait (1);
	}
}

living_ai_is_here (touchable, team) // Returns true if ai of the given team is alive here
{
	if (!isdefined (touchable))
	{
		println ("called living_ai_is_here without a legit touchable");
		return;
	}

	ai = getaiarray (team);
	ents = [];
	for (i=0;i<ai.size;i++)
	{
		if ((ai[i] istouching (touchable)) && (isalive (ai[i])))
			ents[ents.size] = ai[i];
	}

	for (i=0;i<ents.size;i++)
	{
		if (isalive (ents[i]))
			return true;
	}

	return false;
}

precache (model)
{
	ent = spawn ("script_model",(0,0,0));
	ent.origin = level.player getorigin();
	ent setmodel (model);
	ent delete();
}

add_to_array ( array, ent )
{
	if (!isdefined (ent))
		return array;

	if (!isdefined (array))
		array[0] = ent;
	else
		array[array.size] = ent;

	return array;
}

getClosest(org, array, dist)
{
	if (!array.size)
		return undefined;
	if (isdefined(dist))
	{
		ent = undefined;
		for (i=0;i<array.size;i++)
		{
			newdist = distance(array[i].origin, org);
			if (newdist >= dist)
				continue;
			dist = newdist;
			ent = array[i];
		}
		return ent;
	}

	ent = array[0];
	dist = distance(ent.origin, org);
	for (i=1;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getClosestLiving(org, array, dist)
{
	if(!isdefined(dist))
		dist = 9999999;
	if (array.size < 1)
		return;
	ent = undefined;		
	for (i=0;i<array.size;i++)
	{
		if (!isalive(array[i]))
			continue;
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getHighestDot(start, end, array)
{
	if (!array.size)
		return;
	
	ent = undefined;		
	
	angles = vectorToAngles(end - start);
	dotforward = anglesToForward(angles);
	dot = -1;
	for (i=0;i<array.size;i++)
	{
		angles = vectorToAngles(array[i].origin - start);
		forward = anglesToForward(angles);
		
		newdot = vectordot(dotforward, forward);
		if (newdot < dot)
			continue;
		dot = newdot;
		ent = array[i];
	}
	return ent;
}

getClosestIndex(org, array, dist)
{
	if(!isdefined(dist))
		dist = 9999999;
	if (array.size < 1)
		return;
	index = undefined;		
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		index = i;
	}
	return index;
}
getFarthest(org, array)
{
	if (array.size < 1)
		return;
		
	dist = distance(array[0].origin, org);
	ent = array[0];
	for (i=1;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist <= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

getClosestExclude (org, ents, excluders)
{
	if (!isdefined (ents))
		return undefined;

	range = 0;
	if (isdefined (excluders) && excluders.size)
	{
		exclude = [];
		for (i=0;i<ents.size;i++)
			exclude[i] = false;

		for (i=0;i<ents.size;i++)
		for (p=0;p<excluders.size;p++)
		if (ents[i] == excluders[p])
			exclude[i] = true;

		found_unexcluded = false;
		for (i=0;i<ents.size;i++)
		if ((!exclude[i]) && (isdefined (ents[i])))
		{
			found_unexcluded = true;
			range = distance (org, ents[i].origin);
			ent = i;
			i = ents.size + 1;
		}

		if (!found_unexcluded)
			return (undefined);
	}
	else
	{
		for (i=0;i<ents.size;i++)
		if (isdefined (ents[i]))
		{
			range = distance (org, ents[0].origin);
			ent = i;
			i = ents.size + 1;
		}
	}

	ent = undefined;

	for (i=0;i<ents.size;i++)
	if (isdefined (ents[i]))
	{
		exclude = false;
		if (isdefined (excluders))
		{
			for (p=0;p<excluders.size;p++)
			if (ents[i] == excluders[p])
				exclude = true;
		}

		if (!exclude)
		{
			newrange = distance (org, ents[i].origin);
			if (newrange <= range)
			{
				range = newrange;
				ent = i;
			}
		}
	}

	if (isdefined (ent))
		return ents[ent];
	else
		return undefined;
}

getClosestAI (org, team)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getClosest (org, ents);
}

getArrayOfClosest(org, array, excluders, max)
{
	// pass an array of entities to this function and it will return them in the order of closest
	// to the origin you pass, you can also set max to limit how many ents get returned
	if (!isdefined(max))
		max = array.size;
		
	// return the array, reordered from closest to farthest
	dist = [];
	index = [];
	for (i=0;i<array.size;i++)
	{
		excluded = false;
		for (p=0;p<excluders.size;p++)
		{
			if (array[i] != excluders[p])
				continue;
			excluded = true;
			break;
		}
		if (excluded)
			continue;
			
		dist[dist.size] = distance(org, array[i].origin);
		index[index.size] = i;
	}
		
	for (;;)
	{
		change = false;
		for (i=0;i<dist.size-1;i++)
		{
			if (dist[i] <= dist[i+1])
				continue;
			change = true;
			temp = dist[i];
			dist[i] = dist[i+1];
			dist[i+1] = temp;
			temp = index[i];
			index[i] = index[i+1];
			index[i+1] = temp;
		}
		if (!change)
			break;
	}
	
	newArray = [];
	if (max > dist.size)
		max = dist.size;
	for (i=0;i<max;i++)
		newArray[i] = array[index[i]];
	return newArray;
}

getClosestAIExclude (org, team, excluders)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getClosestExclude (org, ents, excluders);
}

stop_magic_bullet_shield(newhealth,anim_nextStandingHitDying)
{
	self endon ("death");
	self waittill ("stop magic bullet shield");
	self.magic_bullet_shield = undefined;
	self.health = newhealth;
	self.anim_nextStandingHitDying = anim_nextStandingHitDying;
}

magic_bullet_shield(health, time, oldhealth, maxhealth_modifier)
{
	self endon ("stop magic bullet shield");
	self endon ("death");
	
	if (!isdefined (maxhealth_modifier))
		maxhealth_modifier = 1;
	
	if (!isdefined (oldhealth))
		oldhealth = self.health;

	self.anim_disableLongDeath = true;

	anim_nextStandingHitDying = self.anim_nextStandingHitDying;		
	self.anim_nextStandingHitDying = false;

	self thread stop_magic_bullet_shield(oldhealth,anim_nextStandingHitDying);
	self.magic_bullet_shield = true;
	if (!isdefined (time))
		time = 5;

	if (!isdefined (health))
		health = 100000000;
		
	assertEx(health >= 5000, "MagicBulletShield shouldnt be set with low health amounts like < 5000");
	
	while (1)
	{
		self.health = health;
		self.maxhealth = (self.health * maxhealth_modifier);
		oldHealth = self.health;
		self waittill ("pain");
		if (oldHealth == self.health ) // the game spams pain notify every frame while a guy is in pain script
			continue;
			
		assertEx(self.health > 1000, "Magic bullet shield guy got impossibly low health");
		self thread ignoreMeTimer(time);
	}
}

ignoreMeTimer(time)
{
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
	{
		if (!isalive(ai[i].enemy))
			continue;
		if (ai[i].enemy != self)
			continue;
		ai[i] notify ("enemy");
	}
	self endon ("death");
	self endon ("pain");
	self.ignoreme = true;
	wait (time);
	self.ignoreme = false;
}

array_randomize(array)
{
    for (i = 0; i < array.size; i++)
    {
        j = randomint(array.size);
        temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
}

exploder_damage ()
{
	if (isdefined(self.script_delay))
		delay = self.script_delay;
	else
		delay = 0;
		
	if (isdefined (self.script_radius))
		radius = self.script_radius;
	else
		radius = 128;

	damage = self.script_damage;
	origin = self.origin;
	
	wait (delay);
	// Range, max damage, min damage
	radiusDamage (origin, radius, damage, damage);
}

exploder (num)
{
	num = int(num);
	ents = level._script_exploders;

	for (i=0;i<ents.size;i++)
	{
		if (!isdefined (ents[i]))
			continue;

		if (ents[i].script_exploder != num)
			continue;

		if (isdefined (ents[i].script_firefx))
			level thread fire_effect(ents[i]);

		if (isdefined (ents[i].script_fxid))
			level thread cannon_effect(ents[i]);
		else
		if (isdefined (ents[i].script_soundalias))
			level thread sound_effect(ents[i]);
			

		if (isdefined (ents[i].script_damage))
			ents[i] thread exploder_damage();

		if (isdefined (ents[i].script_sound))
			ents[i] thread exploder_sound();

		if (isdefined (ents[i].script_earthquake))
		{
			eq = ents[i].script_earthquake;
			earthquake(level.earthquake[eq]["magnitude"],
						level.earthquake[eq]["duration"],
						ents[i].origin,
						level.earthquake[eq]["radius"]);
		}

		if (isdefined(ents[i].targetname))
		{
			if (ents[i].targetname == "exploder")
				ents[i] thread brush_show();
			else
			if ((ents[i].targetname == "exploderchunk") || (ents[i].targetname == "exploderchunk visible"))
				ents[i] thread brush_throw();
			else
			if (!isdefined (ents[i].script_fxid))
				ents[i] thread brush_delete();
		}
//		else
//		if (!isdefined (ents[i].script_fxid))
//			ents[i] thread brush_delete();
	}

	for (i=0;i<ents.size;i++)
	{
		if (!isdefined (ents[i]))
			continue;
		if (ents[i].script_exploder != num)
			continue;
		if (!isdefined(ents[i].targetname) && !isdefined (ents[i].script_fxid) && !isdefined (ents[i].script_soundalias))
			ents[i] thread brush_delete();
	}
}

exploder_sound ()
{
	if(isdefined(self.script_delay))
		wait self.script_delay;
	level thread playSoundinSpace (level.scr_sound[self.script_sound], self.origin);
}

sound_effect ( source )
{
	effect_soundalias ( source );
}

effect_soundalias ( source )
{
	if (!isdefined (source.script_delay))
		source.script_delay = 0;
	
	org = source.origin;
	alias = source.script_soundalias;
	wait (source.script_delay);
	playsoundinspace ( alias, org);
}

cannon_effect ( source )
{
	if (!isdefined (source.script_delay))
		source.script_delay = 0;

	org = undefined;
	if (isdefined (source.target))
		org = (getent (source.target,"targetname")).origin;
	else
	if (isdefined (source.targetPos))
		org = source.targetPos;


	if (isdefined(source.script_repeat))
	{
		if ((isdefined (source.script_delay_min)) && (isdefined (source.script_delay_max)))
		{
			base = source.script_delay_min;
			range = source.script_delay_max - source.script_delay_min;
		}
		else
		{
			base = source.script_delay;
			range = source.script_delay;
		}
			
		wait (source.script_delay);
		for (i=0;i<source.script_repeat;i++)
		{
			level thread maps\_fx::OneShotfx(source.script_fxid, source.origin, 0, org);
			wait (base + randomfloat(range));
		}
		return;
	}

	if ((isdefined (source.script_delay_min)) && (isdefined (source.script_delay_max)))
		source.script_delay = source.script_delay_min + randomfloat (source.script_delay_max - source.script_delay_min);

	level thread maps\_fx::OneShotfx(source.script_fxid, source.origin, source.script_delay, org);

	if (!isdefined (source.script_soundalias))
		return;
	
	org = source.origin;
	alias = source.script_soundalias;
	wait (source.script_delay);
	playsoundinspace ( alias, org);
}


fire_effect ( source )
{
	if (!isdefined (source.script_delay))
		source.script_delay = 0;

	if ((isdefined (source.script_delay_min)) && (isdefined (source.script_delay_max)))
		source.script_delay = source.script_delay_min + randomfloat (source.script_delay_max - source.script_delay_min);

	org = undefined;
	if (isdefined (source.target))
		org = (getent (source.target,"targetname")).origin;
	else
	if (isdefined (source.targetPos))
		org = source.targetPos;


	firefxSound = source.script_firefxsound;
	org1 = source.origin;
	firefx = source.script_firefx;
	ender = source.script_ender;
	if (!isdefined (ender))
		ender = "createfx_effectStopper";
	timeout = source.script_firefxtimeout;
	if (isdefined (source.script_firefxdelay))
		delay = source.script_firefxdelay;
	else
		delay = 0.5;

	wait (source.script_delay);

	if (isdefined (firefxSound))	
		level thread loopfxSound ( firefxSound, org1, ender, timeout );

//	loopfx(				fxId,	fxPos, 	waittime,	fxPos2,	fxStart,	fxStop,	timeout)
	maps\_fx::loopfx(	firefx,	org1,	delay,		org,	undefined,	ender,	timeout);
}

loopfxSoundDelete (ender)
{
	self endon ("death");
	self waittill (ender);
	self delete();
}

loopfxSound ( alias, origin, ender, timeout )
{
	org = spawn ("script_origin",(0,0,0));
	if (isdefined (ender))
	{
		org thread loopfxSoundDelete (ender);
		org endon (ender);
	}
	org.origin = origin;
	org playloopsound (alias);
	if (!isdefined (timeout))
		return;
		
	wait (timeout);
//	org delete();
}

brush_delete()
{
	num = self.script_exploder;
	if (isdefined (self.script_delay))
		wait (self.script_delay);
	else
		wait (.05);

	if (self.spawnflags & 1)
		self connectpaths();

	if (level.createFX_enabled)
	{
		self hide();
		self notsolid();
		level waittill ("createfx ready to go");
		self show();
		self solid();
		return;
	}

	waittillframeend; // so it hides stuff after it shows the new stuff
	self delete();
}

brush_show()
{
	if (isdefined (self.script_delay))
		wait (self.script_delay);
	
	self show();
	self solid();
		
	if (self.spawnflags & 1)
	{
		if (!isdefined(self.script_disconnectpaths))
			self connectpaths();
		else
			self disconnectpaths();
	}

	if (level.createFX_enabled)
	{
		level waittill ("createfx ready to go");
		self hide();
		self notsolid();
	}
}

brush_throw()
{
	if (isdefined (self.script_delay))
		wait (self.script_delay);

	ent = undefined;
	if (isdefined (self.target))
		ent = getent (self.target,"targetname");

	if (!isdefined (ent))
	{
		self delete();
		return;
	}

	self show();

	startorg = self.origin;
	startang = self.angles;
	org = ent.origin;


//	temp_vec = vectornormalize ( org - selforg );
	temp_vec = ( org - self.origin );
//	temp_vec = maps\_utility::vectorScale (temp_vec, 250 + randomint (100));

//	println ("start ", self.origin , " end ", org, " vector ", temp_vec, " player origin ", level.player getorigin());

	x = temp_vec[0];
	y = temp_vec[1];
	z = temp_vec[2];
//	z = 200 + randomint (100);

	self rotateVelocity ((x,y,z), 12);

/*
	if (x > 0)
		self rotateroll((1500 + randomfloat (2500)) * -1, 5,0,0);
	else
		self rotateroll(1500 + randomfloat (2500), 5,0,0);
*/
	self moveGravity ((x, y, z), 12);
	if (level.createFX_enabled)
	{
		level waittill ("createfx ready to go");
		self.origin = startorg;
		self.angles = startang;
		self hide();
		return;
	}
	wait (6);
	self delete();

}

flood_spawn (spawners)
{
	maps\_spawner::spawnerflood_spawn (spawners);
}

vectorMultiply (vec, dif)
{
	vec = (vec[0] * dif, vec[1] * dif, vec[2] * dif);
	return vec;
}

set_ambient (track)
{
	if (!isdefined (level.ambient_reverb))
		level.ambient_reverb = [];
	level.ambient = track;
	if ((isdefined (level.ambient_track)) && (isdefined (level.ambient_track[track])))
	{
		ambientPlay (level.ambient_track[track], 2);
		println ("playing ambient track ", track);
	}
}

waittill_string (msg, ent)
{
	if (msg != "death")
		self endon ("death");
	ent endon ("die");
	self waittill (msg);
	ent notify ("returned", msg);
}

waittill_multiple (string1, string2, string3, string4, string5)
{
	self endon ("death");
	ent = spawnstruct();
	ent.threads = 0;

	if (isdefined (string1))
	{
		self thread waittill_string (string1, ent);
		ent.threads++;
	}
	if (isdefined (string2))
	{
		self thread waittill_string (string2, ent);
		ent.threads++;
	}
	if (isdefined (string3))
	{
		self thread waittill_string (string3, ent);
		ent.threads++;
	}
	if (isdefined (string4))
	{
		self thread waittill_string (string4, ent);
		ent.threads++;
	}
	if (isdefined (string5))
	{
		self thread waittill_string (string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

random (array)
{
	return array [randomint (array.size)];
}

get_friendly_chain_node (chainstring)
{
	chain = undefined;
	trigger = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigger.size;i++)
	{
		if ((isdefined (trigger[i].script_chain)) && (trigger[i].script_chain == chainstring))
		{
			chain = trigger[i];
			break;
		}
	}

	if (!isdefined (chain))
	{
/#
		maps\_utility::error ("Tried to get chain " + chainstring + " which does not exist with script_chain on a trigger.");
#/
		return undefined;
	}

	node = getnode (chain.target,"targetname");
	return node;
}

waittill_any (string1, string2, string3, string4, string5)
{
	if ((!isdefined (string1) || string1 != "death") &&
	    (!isdefined (string2) || string2 != "death") &&
	    (!isdefined (string3) || string3 != "death") &&
	    (!isdefined (string4) || string4 != "death") &&
	    (!isdefined (string5) || string5 != "death"))
		self endon ("death");
		
	ent = spawnstruct();

	if (isdefined (string1))
		self thread waittill_string (string1, ent);

	if (isdefined (string2))
		self thread waittill_string (string2, ent);

	if (isdefined (string3))
		self thread waittill_string (string3, ent);

	if (isdefined (string4))
		self thread waittill_string (string4, ent);

	if (isdefined (string5))
		self thread waittill_string (string5, ent);

	ent waittill ("returned", msg);
	ent notify ("die");
	return msg;
}

shock_ondeath()
{
	precacheShellshock("default");
	self waittill ("death");
	if (getcvar ("r_texturebits") == "16")
		return;
	self shellshock("default", 3);
}

delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}

playSoundOnTag (alias, tag)
{
	if ((isSentient (self)) && (!isalive (self)))
		return;

	org = spawn ("script_origin",(0,0,0));
	org endon ("death");

	thread delete_on_death (org);
	if (isdefined (tag))
		org linkto (self, tag, (0,0,0), (0,0,0));
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}

	org playsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
}


playSoundOnEntity(alias)
{
	playSoundOnTag (alias);
	/*
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	org.origin = self.origin;
	org.angles = self.angles;
	org linkto (self);
	org playloopsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
	*/
}


playLoopSoundOnTag(alias, tag)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (tag))
		org linkto (self, tag, (0,0,0), (0,0,0));
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}

playLoopSoundOnEntity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}

playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias, "sounddone");
	else
		org playsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
}

lookat (ent, timer)
{
	if (!isdefined (timer))
		timer = 10000;

	self animscripts\shared::lookatentity(ent, timer, "alert");
}

save_friendlies()
{
	ai = getaiarray ("allies");
	game_characters = 0;
	for (i=0;i<ai.size;i++)
	{
		if (isdefined (ai[i].script_friendname))
			continue;

//		attachsize =
//		println ("attachSize = ", self getAttachSize());

		game["character" + game_characters] = ai[i] codescripts\character::save();
		game_characters++;
	}

	game["total characters"] = game_characters;
}

load_friendlies()
{
	if (isdefined (game["total characters"]))
	{
		game_characters = game["total characters"];
		println ("Loading Characters: ", game_characters);
	}
	else
	{
		println ("Loading Characters: None!");
		return;
	}

	ai = getaiarray ("allies");
	total_ai = ai.size;
	index_ai = 0;

	spawners = getspawnerteamarray ("allies");
	total_spawners = spawners.size;
	index_spawners = 0;

	while (1)
	{
		if (((total_ai <= 0) && (total_spawners <= 0)) || (game_characters <= 0))
			return;

		if (total_ai > 0)
		{
			if (isdefined (ai[index_ai].script_friendname))
			{
				total_ai--;
				index_ai++;
				continue;
			}

			println ("Loading character.. ", game_characters);
			ai[index_ai] codescripts\character::new();
			ai[index_ai] thread codescripts\character::load(game["character" + (game_characters-1)]);
			total_ai--;
			index_ai++;
			game_characters--;
			continue;
		}

		if (total_spawners > 0)
		{
			if (isdefined (spawners[index_spawners].script_friendname))
			{
				total_spawners--;
				index_spawners++;
				continue;
			}

			println ("Loading character.. ", game_characters);
			info = game["character" + (game_characters-1)];
			precache (info ["model"]);
			precache (info ["model"]);
			spawners[index_spawners] thread spawn_setcharacter (game["character" + (game_characters-1)]);
			total_spawners--;
			index_spawners++;
			game_characters--;
			continue;
		}
	}
}

spawn_failed (spawn)
{
	if (!isalive (spawn))
		return true;
	if (!isdefined (spawn.finished_spawning))
		spawn waittill ("finished spawning");

	if (isalive (spawn))
		return false;

	return true;
}

spawn_setcharacter (data)
{
	codescripts\character::precache(data);

	self waittill ("spawned",spawn);
	if (maps\_utility::spawn_failed(spawn))
		return;

	println ("Size is ", data["attach"].size);
	spawn codescripts\character::new();
	spawn codescripts\character::load(data);
}

keyHintPrint(message, binding)
{
	// Note that this will insert only the first bound key for the action
	iprintlnbold(message, binding["key1"]);
}

flag_wait (msg)
{
	while (!level.flag[msg])
		level waittill (msg);
}

flag_waitopen (msg)
{
	while (level.flag[msg])
		level waittill (msg);
}

flag_init (msg)
{
	level.flag[msg] = false;
}

flag_set (msg)
{
	level.flag[msg] = true;
	level notify (msg);
}

flag_clear (msg)
{
	level.flag[msg] = false;
	level notify (msg);
}

flag (msg)
{
	if (!level.flag[msg])
		return false;

	return true;
}

assignanimtree()
{
	self UseAnimTree(level.scr_animtree[self.animname]);
}

waittill_either_think (ent, msg)
{
	println (ent, "^1 is waiting for ", msg);
	ent waittill (msg);
	println (ent, "^1 got ", msg);
	self notify ("got notify");
}

waittill_either(waiter, msg1, msg2, msg3 )
{
	ent = spawnstruct();
	if (isdefined (msg1))
		ent thread waittill_either_think(waiter, msg1);
	if (isdefined (msg2))
		ent thread waittill_either_think(waiter, msg2);
	if (isdefined (msg3))
		ent thread waittill_either_think(waiter, msg3);
		
	ent waittill ("got notify");
}

trigger_wait (strName, strKey)
{
	eTrigger = getent (strName, strKey);
	if (!isdefined (eTrigger))
	{
		assertmsg ("trigger not found: " + strName + " key: " + strKey);
		return;
	}
	eTrigger waittill ("trigger", eOther);
	level notify (strName, eOther);
	return eOther;
}

setFlagOnTrigger (eTrigger, strFlag)
{
	if (!level.flag[strFlag])
	{
		eTrigger waittill ("trigger", eOther);
		flag_set(strFlag);
		return eOther;
	}
}

is_in_array (aeCollection, eFindee)
{
	for (i = 0; i < aeCollection.size; i++)
	{
		if (aeCollection[i] == eFindee)
			return (true);
	}
	
	return (false);
}

abs (num)
{
	if (num < 0)
		num*= -1;
		
	return num;
}

randomvector(num)
{
	return (randomfloat(num) - num*0.5, randomfloat(num) - num*0.5,randomfloat(num) - num*0.5);
}

linkWaypoint(waypoint)
{
	level.friendly_waypoint_link[level.friendly_waypoint_link.size] = waypoint;
}

unlinkWaypoint(waypoint)
{
	level.friendly_waypoint_unlink[level.friendly_waypoint_unlink.size] = waypoint;
}

waittill_dead(guys, num, timeoutLength)
{

	// verify the living-ness of the ai
	allAlive = true;
	for (i=0;i<guys.size;i++)
	{
		if (isalive(guys[i]))
			continue;
		allAlive = false;
		break;
	}
	assertEx (allAlive, "Waittill_Dead was called with dead or removed AI in the array, meaning it will never pass.");
	if (!allAlive)
	{	
		newArray = [];
		for (i=0;i<guys.size;i++)
		{
			if (isalive(guys[i]))
				newArray[newArray.size] = guys[i];
		}
		guys = newArray;
	}

	ent = spawnStruct();
	if (isdefined (timeoutLength))
	{
		ent endon ("thread timed out");
		ent thread waittill_dead_timeout(timeoutLength);
	}
	
	ent.count = guys.size;
	if (isdefined (num) && num < ent.count)
		ent.count = num;
	array_thread(guys, ::waittill_dead_thread, ent);
	
	while (ent.count > 0)
		ent waittill ("waittill_dead guy died");
}

waittill_dead_thread(ent)
{
	self waittill ("death");
	ent.count--;
	ent notify ("waittill_dead guy died");
}

waittill_dead_timeout(timeoutLength)
{
	wait (timeoutLength);
	self notify ("thread timed out");
}

waittill_aigroupcleared( aigroup )
{
	while( level._ai_group[aigroup].spawnercount || level._ai_group[aigroup].aicount )
		wait ( 2.5 );
}

getAIGroupCount( aigroup )
{
	return ( level._ai_group[aigroup].spawnercount + level._ai_group[aigroup].aicount );
}

getAIGroupAI( aigroup )
{
	aiSet = [];
	for ( index = 0; index < level._ai_group[aigroup].ai.size; index++ )
	{
		if ( !isAlive( level._ai_group[aigroup].ai[index] ) )
			continue;
			
		aiSet[aiSet.size] = level._ai_group[aigroup].ai[index];
	}
	
	return ( aiSet );
}

// Creates an event based on this message if none exists, and sets it to true after the delay.
GatherDelayProc(msg, delay)
{
	if (isdefined (level.gather_delay[msg]))
	{
		if (level.gather_delay[msg])
		{
			wait (0.05);
			if (isalive (self))
				self notify ("gather_delay_finished" + msg + delay);
			return;
		}
		
		level waittill (msg);
		if (isalive (self))
			self notify ("gather_delay_finished" + msg + delay);
		return;
	}
	
	level.gather_delay[msg] = false;
	wait (delay);
	level.gather_delay[msg] = true;
	level notify (msg);
	if (isalive (self))
		self notify ("gather_delay_finished" + msg + delay);
}

GatherDelay(msg, delay)
{
	thread GatherDelayProc(msg, delay);
	self waittill ("gather_delay_finished" + msg + delay);
}

setEnvironment(env)
{
	animscripts\utility::setEnv(env);
}

deathWaiter(notifyString)
{
	self waittill ("death");
	level notify (notifyString);
}

getchar(num)
{
	if (num == 0)
		return "0";
	if (num == 1)
		return "1";
	if (num == 2)
		return "2";
	if (num == 3)
		return "3";
	if (num == 4)
		return "4";
	if (num == 5)
		return "5";
	if (num == 6)
		return "6";
	if (num == 7)
		return "7";
	if (num == 8)
		return "8";
	if (num == 9)
		return "9";
}

waittillEither (msg1, msg2)
{
	self endon (msg1);
	self waittill (msg2);
}

groupMoveChain(ai, goalArray, radius)
{
	groupMoveProc(ai, goalArray, radius);
}

groupMove(ai, goalPos, radius)
{
	goalArray[0] = goalPos;
	groupMoveProc(ai, goalArray, radius);
}

groupMoveProc(ai, goalPos, radius, midPoint)
{
	squad = maps\_groupmove::createGroupMoveSquad (ai);
	squad maps\_groupmove::squadMoveThink(goalPos, radius);
	
	// Group is disbanded or dead so remove this groups reservation of any nodes.
	cover = getnodearray ("cover","targetname");
	for (i=0;i<cover.size;i++)
	{
		if (!isdefined (cover[i].reservedBy))
			continue;
		if (cover[i].reservedBy != squad)
			continue;
		cover[i].reservedBy = undefined;	
	}
}


groupAttackPlayerChain(ai, goalArray)
{
	groupAttackPlayerProc(ai, goalArray);
}

groupAttackPlayer(ai)
{
	groupAttackPlayerProc(ai);
}

groupAttackPlayerProc(ai, goalPos)
{
	squad = maps\_groupmove::createGroupMoveSquad (ai);
	squad maps\_groupmove::attackPlayerGroupMoveThink(goalPos);
}

playerGodon()
{
	thread playerGodon_thread();
}

playerGodon_thread()
{
	level.player endon ("godoff");
	level.player.oldhealth = level.player.health;
	
	for (;;)
	{
		level.player waittill ("damage");
		level.player.health = 10000;
	}	
}

playerGodoff()
{
	level.player notify ("godoff");
	assert(isdefined(level.player.oldhealth));
	level.player.health = level.player.oldhealth;
}


checkForSmokeHint(node)
{
	self endon ("death");
	maps\_hardpoint::checkForSmokeHintProc(node);
}

getlinks_array( array, linkMap )  //don't pass stuff through as an array of struct.linkname[] but only linkMap[]
{
	ents = [];
	for ( j = 0; j < array.size; j++ )
	{
		node = array[j];
		script_linkname = node.script_linkname;
		if ( !isdefined( script_linkname ) )
			continue;
		if ( !isdefined( linkMap[script_linkname] ) )
			continue;
		ents[ents.size] = node;
	}
	return ents;
}

// Adds only things that are new to the array.
// Requires the arrays to be of node with script_linkname defined.
array_merge_links( array1, array2 )
{
	if ( !array1.size )
		return array2;
	if ( !array2.size )
		return array1;

	linkMap = [];

	for ( i = 0; i < array1.size; i++ )
	{
		node = array1[i];
		linkMap[node.script_linkname] = true;
	}

	for ( i = 0; i < array2.size; i++ )
	{
		node = array2[i];
		if ( isdefined( linkMap[node.script_linkname] ) )
			continue;
		linkMap[node.script_linkname] = true;
		array1[array1.size] = node;
	}

	return array1;
}

array_combine(array1,array2)
{
	if(!array1.size)
		return array2;
	for(i=0;i<array2.size;i++)
		array1[array1.size] = array2[i];
	return array1;
}

array_merge(array1,array2) // adds only things that are new to the array
{
	if(array1.size == 0)
		return array2;
	if(array2.size == 0)
		return array1;
	newarray = array1;
	for(i=0;i<array2.size;i++)
	{
		foundmatch = false;
		for(j=0;j<array1.size;j++)
			if(array2[i] == array1[j])
			{
				foundmatch = true;
				break;
			}
		if(foundmatch)
			continue;
		else
			newarray[newarray.size] = array2[i];
	}
	return newarray;
}

flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}

flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;

}

plotPoints(plotpoints,r,g,b,timer)
{
	lastpoint = plotpoints[0];
	for(i=1;i<plotpoints.size;i++)
	{
		thread drawlinefortime(lastpoint,plotpoints[i],r,g,b,timer);
		lastpoint = plotpoints[i];	
	}
}

DrawLineForTime(org1,org2,r,g,b,timer)
{
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
		line (org1,org2, (r,g,b), 1);
		wait .05;		
	}
	
}

drawArrowTime (start, end, color, duration)
{
	level endon ("newpath");
	pts = [];
	angles = vectortoangles(start - end);
	right = anglestoright(angles);
	forward = anglestoforward(angles);

	dist = distance(start, end);
	arrow = [];
	range = 0.1;
	arrow[0] =  start;
	arrow[1] =  start + vectorScale(right, dist*(range)) + vectorScale(forward, dist*-0.1);
	arrow[2] =  end;
	arrow[3] =  start + vectorScale(right, dist*(-1 * range)) + vectorScale(forward, dist*-0.1);

	for (i=0;i<duration * 20; i++)
	{
		for (p=0;p<4;p++)
		{
			nextpoint = p+1;
			if (nextpoint >= 4)
				nextpoint = 0;
			line(arrow[p], arrow[nextpoint], color, 1.0);
		}
		wait (0.05);
	}
}

drawArrow (start, end, color)
{
	level endon ("newpath");
	pts = [];
	angles = vectortoangles(start - end);
	right = anglestoright(angles);
	forward = anglestoforward(angles);

	dist = distance(start, end);
	arrow = [];
	range = 0.05;
	arrow[0] =  start;
	arrow[1] =  start + vectorScale(right, dist*(range)) + vectorScale(forward, dist*-0.2);
	arrow[2] =  end;
	arrow[3] =  start + vectorScale(right, dist*(-1 * range)) + vectorScale(forward, dist*-0.2);

	for (p=0;p<4;p++)
	{
		nextpoint = p+1;
		if (nextpoint >= 4)
			nextpoint = 0;
		line(arrow[p], arrow[nextpoint], color, 1.0);
	}
}

setexceptions(exceptionFunc)
{
	self.exception_exposed = exceptionFunc;
	self.exception_corner = exceptionFunc;
	self.exception_corner_normal = exceptionFunc;
	self.exception_cover_crouch = exceptionFunc;
	self.exception_stop = exceptionFunc;
	self.exception_stop_immediate = exceptionFunc;
	self.exception_move = exceptionFunc;
}


clearEnemyPassthrough()
{
	self notify ("enemy");
	self clearEnemy();
}


battleChatterOff( team )
{
	if ( !isDefined( level.battlechatter ) )
	{
		level.battlechatter = [];
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
	}

	if ( isDefined( team ) )
	{
		level.battlechatter[team] = false;
		soldiers = getAIArray( team );
	}
	else
	{
		level.battlechatter["axis"] = false;
		level.battlechatter["allies"] = false;
		level.battlechatter["neutral"] = false;
		soldiers = getAIArray();
	}

	if (!isDefined(anim.chatInitialized) || !anim.chatInitialized)
		return;

	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index].battlechatter = false;

	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( !isalive( soldiers[index] ) )
			continue;
			
		if ( !soldiers[index].chatInitialized )
			continue;

		if ( !soldiers[index].isSpeaking )
			continue;
			
		//soldiers[index] waittill ( "done speaking" );
		
		while ( isalive( soldiers[index] ) && soldiers[index].isSpeaking )
			wait ( 0.05 );
	}
	
	speakDiff = getTime() - anim.lastTeamSpeakTime["allies"];

	if ( speakDiff < 1500 )
		wait ( speakDiff / 1000 );
		
	if ( isdefined( team ) )
		level notify ( team + " done speaking" );
	else
		level notify ( "done speaking" );
}

battleChatterOn( team )
{
	thread battleChatterOn_Thread( team );
}

battleChatterOn_Thread( team )
{
	if ( !isDefined( level.battlechatter ) )
	{
		level.battlechatter = [];
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
	}

	if (!anim.chatInitialized)
		return;

	// buffer time
	wait ( 1.5 );
	
	if ( isDefined( team ) )
	{
		level.battlechatter[team] = true;
		soldiers = getAIArray( team );
	}
	else
	{
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
		soldiers = getAIArray();
	}

	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index] setBattleChatter(true);
}

setBattleChatter( state )
{
	if (!anim.chatInitialized)
		return;

	if (state)
	{
		if(isdefined(self.script_bcdialog) && !self.script_bcdialog)
			self.battlechatter = false;
		else
			self.battlechatter = true;
	}
	else
	{
		self.battlechatter = false;
		
		if (isdefined(self.isSpeaking) && self.isSpeaking)
			self waittill ("done speaking");
	}
}

//
// This is for scripted sequence guys that the LD has setup to not 
// get interrupted in route.
//

setFriendlyChainWrapper(node)
{
	level.player setFriendlyChain(node);
	level notify ("newFriendlyChain", node.script_noteworthy);
}


// Newvillers objective management
/*
	level.currentObjective = "obj1"; // disables non obj1 friendly chains if you're using newvillers style friendlychains
	objEvent = getObjEvent("center_house"); // a trigger with targetname objective_event and a script_deathchain value
	
	objEvent waittill_objectiveEvent(); // this waits until the AI with the event's script_deathchain are dead,
											then waits for trigger from the player. If it targets a friendly chain then it'll
											make the friendlies go to the chain.
*/

getObjOrigin(msg)
{
	objOrigins = getentarray("objective","targetname");
	for (i=0;i<objOrigins.size;i++)
	{
		if (objOrigins[i].script_noteworthy == msg)
			return objOrigins[i].origin;
	}
}

getObjEvent(msg)
{
	objEvents = getentarray("objective_event","targetname");
	for (i=0;i<objEvents.size;i++)
	{
		if (objEvents[i].script_noteworthy == msg)
			return objEvents[i];
	}
}


waittill_objectiveEvent()
{
	waittill_objectiveEventProc(true);
}

waittill_objectiveEventNoTrigger()
{
	waittill_objectiveEventProc(false);
}

waittill_objectiveEventProc(requireTrigger)
{
	while (level.deathSpawner[self.script_deathChain] > 0)
		level waittill ("spawner_expired" + self.script_deathChain);

	if (requireTrigger)
		self waittill ("trigger");
}

objectiveEventThink()
{
	if (!isdefined (self.target))
		return;

	// Dont want objective events to spawn guys when you touch them.
	ai = getentarray(self.target,"targetname");
	for (i=0;i<ai.size;i++)
		ai[i].triggerUnlocked = true;
}

objSetChainAndEnemies()
{
	objChain = getnode(self.target,"targetname");
	objEnemies = getentarray(self.target,"targetname");
	flood_and_secure_scripted(objEnemies);
//	array_thread (, ::floodBegin);
	level notify ("new_friendly_trigger");
	level.player setFriendlyChainWrapper(objChain);
}

floodBegin()
{
	self notify ("flood_begin");
}

flood_and_secure_scripted(spawners, instantRespawn)
{
	/*
		The "scripted" version acts as if it had been player triggered.
		
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

	if (!isdefined(instantRespawn))
		instantRespawn = false;

	if (!isdefined (level.spawnerWave))
		level.spawnerWave = [];
	array_thread (spawners, maps\_spawner::flood_and_secure_spawner, instantRespawn);

	for (i=0;i<spawners.size;i++)
	{
		spawners[i].playerTriggered = true;
		spawners[i] notify ("flood_begin");
	}
}


nearestGenericAllyLine (anime, delay)
{
	// gets the nearest unnamed or generic named ally and makes him say a line
	if (isdefined (delay))
		wait (delay);
	/*
	excluders = [];
	if (isdefined(level.volsky))
		excluders[excluders.size] = level.volsky;
	if (isdefined(level.crazy))
		excluders[excluders.size] = level.crazy;
	*/

	guy = undefined;
	for(;;)
	{
		ai = getaiarray("allies");
		excluders = [];
		for (i=0;i<ai.size;i++)
		{
			if (!isdefined(ai[i].animname))
				continue;
			if (ai[i].animname == "generic")
				continue;
			excluders[excluders.size] = ai[i];
		}
		guy = getClosestExclude (level.player.origin, ai, excluders);	
		if (isalive(guy))	
			break;
		wait (1);
	}
	
	guy.animname = "generic";
	guy maps\_anim::anim_single_solo (guy, anime);
}

generic_chat()
{
	self waittill ("trigger");
	thread nearestGenericAllyLine (self.script_noteworthy);
	self delete();
}


debugorigin()
{
//	self endon ("killanimscript");
//	self endon (anim.scriptChange);
	self notify ("Debug origin");
	self endon ("Debug origin");
	self endon ("death");
	for (;;)
	{
		forward = anglestoforward (self.angles);
		forwardFar = maps\_utility::vectorScale(forward, 30);
		forwardClose = maps\_utility::vectorScale(forward, 20);
		right = anglestoright (self.angles);
		left = maps\_utility::vectorScale(right, -10);
		right = maps\_utility::vectorScale(right, 10);
		line (self.origin, self.origin + forwardFar, (0.9, 0.7, 0.6), 0.9);
		line (self.origin + forwardFar, self.origin + forwardClose + right, (0.9, 0.7, 0.6), 0.9);
		line (self.origin + forwardFar, self.origin + forwardClose + left, (0.9, 0.7, 0.6), 0.9);
		wait (0.05);
	}
}


getLinks()
{
	return strtok( self.script_linkTo, " " );
}

dialog_add (dialog,delay,playerseek,timeout)
{
	if(!isdefined(delay))
		delay = 0;
	queadd = spawnstruct();
	if(isdefined(playerseek))
		queadd.playerseek = playerseek;
	if(isdefined(timeout))
		queadd.timeout = timeout;
	queadd.dialog = dialog;
	queadd.delay = delay;
	self.dialogque[self.dialogque.size] = queadd;
}

dialog_handle ()
{
	self notify ("newdialoghandle");
	self endon ("newdialoghandle");
	self endon ("death");
	while(1)
	{
		if (self.dialogque.size)
			setBattleChatter(false);
			
		while(self.dialogque.size)
		{
			self.ignoreme = true;
			self.anim_disablePain = true;
			if(self.dialogque[0].delay > 0)
				wait self.dialogque[0].delay;
			self.takedamage = false;
			if(isdefined(self.dialogque[0].boldstring))
				iprintlnbold(self.dialogque[0].boldstring);
			if(isdefined(self.dialogque[0].playerseek))
			{
				if(isdefined(self.dialogque[0].timeout))
					timeout = self.dialogque[0].timeout;
				else
					timeout = undefined;
				player_seek(timeout);
			}
			level maps\_anim::anim_single_solo(self, self.dialogque[0].dialog);
			self.takedamage = true;
			self.dialogque = array_remove(self.dialogque, self.dialogque[0]);
			if(!self.dialogque.size)
			{
				setBattleChatter(true);
				self.anim_disablePain = true;
				self notify ("que finished");
				self.ignoreme = false;
			}
		}
		wait .1;
	}
}

player_seek(timeout)
{
	goalent = spawn("script_origin",level.player.origin);
	goalent linkto (level.player);
	if(isdefined(timeout))
		self thread timeout(timeout);
	self setgoalentity(goalent);
	if(!isdefined(self.oldgoalradius))
		self.oldgoalradius = self.goalradius;
	self.goalradius = 300;
	self waittill_any("goal","timeout");
	if(isdefined(self.oldgoalradius))
	{
		self.goalradius = self.oldgoalradius;
		self.oldgoalradius = undefined;
	}
	goalent delete();
}

timeout(timeout)
{
	self endon ("death");
	wait(timeout);
	self notify ("timeout");
}

// fancy quicker struct array handling, assumes array elements are objects with which an index can be asigned to (IE: can't do 5.struct_array_index) 
// also have to be sure that objects can't be a part of another structarray setup as the index position is asigned to the object


struct_arrayspawn()
{
	struct = spawnstruct();
	struct.array = [];
	struct.lastindex = 0;
	return struct;
}

/*
structarray_add(struct,object)
{
	struct.array[struct.lastindex] = spawnstruct();
	struct.array[struct.lastindex].object = object;
	struct.array[struct.lastindex].struct_array_index = struct.lastindex;
	struct.lastindex++;
}
*/
structarray_add(struct,object)
{
	assert(!isdefined(object.struct_array_index));  //can't have elements of two structarrays on these. can add that later if it's needed
	struct.array[struct.lastindex] = object;
	object.struct_array_index = struct.lastindex;
	struct.lastindex++;
}

structarray_remove(struct,object)
{
	structarray_swaptolast(struct,object);
	struct.array[struct.lastindex-1] = undefined;
	struct.lastindex--;
}

structarray_swaptolast(struct,object)
{
	struct structarray_swap(struct.array[struct.lastindex-1],object);
}

structarray_shuffle(struct,shuffle)
{
	for(i=0;i<shuffle;i++)
		struct structarray_swap(struct.array[i],struct.array[randomint(struct.lastindex)]);
}

structarray_swap(object1,object2)
{
	index1 = object1.struct_array_index;
	index2 = object2.struct_array_index; 
	self.array[index2] = object1;
	self.array[index1] = object2;
	self.array[index1].struct_array_index = index1;
	self.array[index2].struct_array_index = index2;
}

// starts this ambient track
activateAmbient(ambient)
{
	level.ambient = ambient;

	if (level.ambient == "exterior")
		ambient += level.ambient_modifier["exterior"];
	if (level.ambient == "interior")
		ambient += level.ambient_modifier["interior"];
		
	assert(isdefined (level.ambient_track) && isdefined (level.ambient_track[ambient]));
	ambientPlay (level.ambient_track[ambient + level.ambient_modifier["rain"]], 1);
	thread maps\_ambient::ambientEventStart(ambient + level.ambient_modifier["rain"]);
	println ("Ambience becomes: ", ambient + level.ambient_modifier["rain"]);
}

// starts this ambient track
setAmbientAlias(ambient, alias)
{
	// change the meaning of this ambience so that the ambience can change over the course of the level
	level.ambient_modifier[ambient] = alias;
	// if the ambient being aliased is the current ambience then restart it so it gets the new track
	if (level.ambient == ambient)
		activateAmbient(ambient);
}

getUseKey()
{
	if (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" )
	 	return "+usereload";
 	else
 		return "+activate";
}
/*
drawTag(tag)
{
	scale = 30;
	for (;;)
	{
		org = self gettagorigin(tag);
		angles = self gettagangles(tag);
		forward = anglestoforward(angles);
		forward = vectorScale(forward, scale);
		right = anglestoright(angles);
		right = vectorScale(right, scale);
		up = anglestoup(angles);
		up = vectorScale(up, scale);
		
		line (org, org + forward,		(0,0,1));
		line (org, org + up,			(0,1,0));
		line (org, org + right,			(1,0,0));
		wait (0.05);
	}
}
*/

doom()
{
	// send somebody far away then delete them
	self teleport((0,0,-15000));
	self dodamage(self.health + 1, (0,0,0));
}

/*
	move_generic		"Go! Go! Go!"
	move_flank			"Find a way to flank them! Go!"
	move_flankleft		"Take their left flank! Go!"
	move_flankright		"Move in on their left flank! Go!"
	move_follow			"Follow me!"
	move_forward		"Keep moving forward!"
	move_back			"Fall back!"
	
	infantry_generic	"Enemy Infantry!"
	infantry_exposed	"Infatry in the open!"
	infantry_many		"We got a load of german troops out there!"
	infantry_sniper		"Get your heads down! Sniper!"
	infantry_panzer		"Panzerschreck!"
	
	vehicle_halftrack	"Halftrack!"
	vehicle_panther		"Panther heavy tank!"
	vehicle_panzer		"Panzer tank!"
	vehicle_tank		"Look out! Enemy armor!"
	vehicle_truck		"Troop truck!"

	action_smoke		"Get some smoke out there!"

	The following can be appended to any infantry or vehicle dialog line:	
	_left				"On our left!"
	_right				"To the right!"
	_front				"Up front!"
	_rear				"Behind us!"
	_north				"To the north!"
	_south				"South!"
	_east				"To the east!"
	_west				"To the west!"
	_northwest			"To the northwest!"
	_southwest			"To the southwest!"
	_northeast			"To the northeast!"
	_southwest			"To the southeast!"
	_inbound_left		"Incoming
	_inbound_right		"Closing on our right flank!"
	_inbound_front		"Inbound dead ahead!"
	_inbound_rear		"Approaching from the rear!"
	_inbound_north		"Coming in from the north!"
	_inbound_south		"Coming in from the south!"
	_inbound_east		"Approaching from the east!"
	_inbound_west		"Pushing in from the west!"
*/

customBattleChatter( string )
{
	excluders = [];
	excluders[0] = self;
	buddy = getClosestAIExclude( self.origin, self.team, excluders );

	if ( isDefined( buddy ) && distance( buddy.origin, self.origin ) > 384 ) 
		buddy = undefined;

	self animscripts\battlechatter_ai::beginCustomEvent();

	tokens = strTok( string, "_" );

	if ( !tokens.size )
		return;
		
	if ( tokens[0] == "move" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";
			
		self animscripts\battlechatter_ai::addGenericAliasEx( "order", "move", modifier );
			
	}
	else if ( tokens[0] == "infantry" )
	{
		self animscripts\battlechatter_ai::addGenericAliasEx( "threat", "infantry", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "vehicle" )
	{
		self animscripts\battlechatter_ai::addGenericAliasEx( "threat", "vehicle", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "inbound", tokens[3] );
	}
	
	self animscripts\battlechatter_ai::endCustomEvent( 2000 );
}


forceCustomBattleChatter( string, targetAI )
{
	tokens = strTok( string, "_" );
	soundAliases = [];

	if ( !tokens.size )
		return;

	if ( isDefined( targetAI ) && (isDefined( targetAI.bcName) || isDefined( targetAI.bcRank)) )
	{
		if ( isDefined( targetAI.bcName ) )
			nameAlias = self buildBCAlias( "name", targetAI.bcName );
		else
			nameAlias = self buildBCAlias( "rank", targetAI.bcRank );
			
		if ( soundExists( nameAlias ) )
			soundAliases[soundAliases.size] = nameAlias;
	}	
		
	if ( tokens[0] == "move" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";
			
		soundAliases[soundAliases.size] = self buildBCAlias( "order", "move", modifier );
	}
	else if ( tokens[0] == "infantry" )
	{
		soundAliases[soundAliases.size] = self buildBCAlias( "threat", "infantry", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "vehicle" )
	{
		soundAliases[soundAliases.size] = self buildBCAlias( "threat", "vehicle", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "order" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";

		soundAliases[soundAliases.size] = self buildBCAlias( "order", "action", modifier );
	}
	else if ( tokens[0] == "cover" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";

		soundAliases[soundAliases.size] = self buildBCAlias( "order", "cover", modifier );
	}
	
	for ( index = 0; index < soundAliases.size; index++)
	{
		self playSound( soundAliases[index], soundAliases[index], true);
		self waittill( soundAliases[index] );
	}
}


buildBCAlias( action, type, modifier )
{
	if ( isDefined( modifier ) )
		return ( self.countryID + "_" + self.npcID + "_" + action + "_" + type + "_" + modifier );
	else
		return ( self.countryID + "_" + self.npcID + "_" + action + "_" + type );
}

getstopwatch(time,othertime)
{
	watch = newHudElem();
	 if (isdefined( getcvar("xenonGame") ) && getcvar("xenonGame") == "true" )
	{
		watch.x = 68;
		watch.y = 35;
	}
	else
	{
		watch.x = 58;
		watch.y = 95;
	}
	
	watch.alignx = "center";
	watch.aligny = "middle";
	watch.horzAlign = "left";
	watch.vertAlign = "middle";
	if(isdefined(othertime))
		timer = othertime;
	else
		timer = level.explosiveplanttime;
	watch setClock(timer, time, "hudStopwatch", 64, 64); // count down for level.explosiveplanttime of 60 seconds, size is 64x64
	return watch;
}

objectiveIsActive(msg)
{
	active = false;
	// objective must be active for this trigger to hit
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] != msg)
			continue;
		active = true;
		break;
	}
	return (active);
}

objectiveIsInactive(msg)
{
	inactive = false;
	// objective must be active for this trigger to hit
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] != msg)
			continue;
		inactive = true;
		break;
	}
	return (inactive);
}

setObjective_inactive(msg)
{
	// remove the objective from the active list
	array = [];
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] == msg)
			continue;
		array[array.size] = level.active_objective[i];
	}
	level.active_objective = array;
	
	
	// add it to the inactive list
	exists = false;
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] != msg)
			continue;
		exists = true;
	}
	if (!exists)
		level.inactive_objective[level.inactive_objective.size] = msg;
		
	/#
	// assert that each objective is only on one list
	for (i=0;i<level.active_objective.size;i++)
	{
		for (p=0;p<level.inactive_objective.size;p++)
			assertEx(level.active_objective[i] != level.inactive_objective[p], "Objective is both inactive and active");
	}
	#/
}

setObjective_active(msg)
{
	// remove the objective from the inactive list
	array = [];
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] == msg)
			continue;
		array[array.size] = level.inactive_objective[i];
	}
	level.inactive_objective = array;
		
	// add it to the active list
	exists = false;
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] != msg)
			continue;
		exists = true;
	}
	if (!exists)
		level.active_objective[level.active_objective.size] = msg;
		
	/#
	// assert that each objective is only on one list
	for (i=0;i<level.active_objective.size;i++)
	{
		for (p=0;p<level.inactive_objective.size;p++)
			assertEx(level.active_objective[i] != level.inactive_objective[p], "Objective is both inactive and active");
	}
	#/
}


// Mo's hudelement management
//**************************** KEEP THIS ONE IN CASE HUD ELEMS EVER WORK  *******************************//
add_hudelm_interupt(binding, ender, timer)
{
	level.hudelm_unpause_ender = ender;
	level notify("hud_elem_interupt");
	elm_name = newHudElem();
	alignY = binding.alignY;
	elm_name add_hudelm_position_internal(alignY);
	elm_name thread add_hudelem_pulse(timer);
	elm_name.label = binding.text;
	elm_name.debugtext = binding.text;
	if(isdefined(binding.bind))
		elm_name setText(binding.bind);
	
	if(isdefined(ender) || isdefined(timer))
		elm_name thread remove_hudelm_hint(ender, timer);
	
	thread reset_unpause_internal();
	return elm_name;
}

reset_unpause_internal()
{
	level waittill(level.hudelm_unpause_ender);
	level.hudelm_unpause_ender = undefined;
}

add_hudelm_hint(binding, ender, timer, binding1, binding2, binding3, binding4)
{
	level notify("hud_elem_going_up");
	if (flag("player_has_red_flashing_overlay") && isdefined(level.hudelm_unpause_ender))
	{
		level endon("hud_elem_going_up");
		level waittill(level.hudelm_unpause_ender);
	}
	if(!isdefined(binding1))
	{
		background = undefined;
		if(isdefined(level.setHudElmHintBackground) && level.setHudElmHintBackground == true)
			background = newHudElem();
		elm_name = newHudElem();
		elm_name.background = background;
		elm_name add_hudelm_position_internal(binding.alignY);
		elm_name thread add_hudelem_pulse(timer);
		elm_name.label = binding.text;
		elm_name.debugtext = binding.text;
		
		
		if(isdefined(binding.bind))
			elm_name setText(binding.bind);
		if(isdefined(binding.checkagain))
			elm_name thread renew_hudelm_text(binding);
		if(isdefined(ender) || isdefined(timer))
			elm_name thread remove_hudelm_hint(ender, timer);
		
		elm_name thread pause_hudelm_hint_internal(timer);
		return elm_name;
	}	
	else
	{
		iprintlnbold(binding.text, getKeyBinding(binding1)["key1"], getKeyBinding(binding2)["key1"], getKeyBinding(binding3)["key1"], getKeyBinding(binding4)["key1"]);
		return undefined;
	}
}

renew_hudelm_text(binding)
{
	self endon("death");
	self endon("destroying");
	self endon("destroyed");
	while(1)
	{
		if(!isdefined(self))
			return;
		self.label = binding.text;
		wait .05;
	}
}

remove_hudelm_hint(ender, timer)
{
	if(!isdefined(self))
		return;
	self thread remove_hudelm_hint_internal(ender, timer);
}

remove_hudelm_hint_internal(ender, timer)
{
	if(!isdefined(self))
		return;
	self thread remove_hudelm_hint_internal2();
	level endon("hud_elem_going_up");
	
	if(isdefined(ender))
		level waittill(ender);
	if(isdefined(timer))
	{
		self thread wait_hudelm_hint_internal(timer);
		self waittill("wait_hudelm_hint_internal_done");
	}	
	if(!isdefined(self))
		return;
	self notify("destroying");
	self fadeOverTime(.3); 
	self.alpha = 0;
	if(isdefined(self.background))
	{
		self.background fadeOverTime(.3); 
		self.background.alpha = 0;
	}
	wait .3;
	if(!isdefined(self))
		return;
	self notify("destroyed");
	self destroy();
}

wait_hudelm_hint_internal(timer)
{
	level endon("hud_elem_going_up");
	level endon("hud_elem_interupt");
	self thread wait_hudelm_hint_internal2(timer);
	wait timer;
	self notify("stop_wait_interupt");
	self notify("wait_hudelm_hint_internal_done");
}

wait_hudelm_hint_internal2(timer)
{
	level endon("hud_elem_going_up");
	self endon("stop_wait_interupt");
	level waittill("hud_elem_interupt");
	level waittill(level.hudelm_unpause_ender);
	self thread wait_hudelm_hint_internal(timer);
}

pause_hudelm_hint_internal(timer)
{
	level endon("hud_elem_going_up");
	self endon("destroying");
	self endon("destroyed");
	
	if(!isdefined(self.pause))
		level waittill("hud_elem_interupt");
	self.pause = true;
	self.alpha = 0;
	if(isdefined(self.background))
		self.background.alpha = 0;
	level waittill(level.hudelm_unpause_ender);
	if(!isdefined(self))
		return;
	self.alpha = 1;
	if(isdefined(self.background))
		self.background.alpha = .5;
	self thread add_hudelem_pulse(timer);
}
remove_hudelm_hint_internal2()
{
	self endon("destroyed");
	level waittill("hud_elem_going_up");
	//self fadeOverTime(.05);
	if(!isdefined(self))
		return;
	self.alpha = 0;
	if(isdefined(self.background))
		self.background.alpha = 0;
	self destroy();
}


//**************************** KEEP THIS ONE IN CASE HUD ELEMS EVER WORK  *******************************//

add_hudelm_position(star, x_xen, x_pc, y_off)
{
	x = -130;
	y = -43;
	
	if(level.xenon)
	{
		x = -170;	
		y = -45;
	}
	if(isdefined(star))
	{
		if(level.xenon)
			self.x = x + x_xen;
		else
			self.x = x + x_pc;
	
		self.y = y + y_off;
		self.alignX = "center";
		self.alignY = "middle";
	}
	else
	{
		if(level.xenon)
			self.fontScale = 2;
		else
			self.fontScale = 1.6;
			
		self.x = x;
		self.y = y;
		self.alignX = "left";
		self.alignY = "middle";
	}
	self.horzAlign = "center";
	self.vertAlign = "middle";
}

add_hudelm_position_internal(alignY)
{
	if(level.xenon)
		self.fontScale = 2;
	else
		self.fontScale = 1.6;
		
	self.x = 0;//320;
	self.y = -40;// 200;
	self.alignX = "center";
	
	/*if(0)//if we ever get the chance to localize or find a way to dynamically find how many lines in a string
	{
		if(isdefined(alignY))
			self.alignY = alignY;
		else
			self.alignY = "middle";	
	}
	else
	{*/
		self.alignY = "bottom";	
	//}
	
	self.horzAlign = "center";
	self.vertAlign = "middle";
	
	if(!isdefined(self.background))
		return;
	self.background.x = 0;//320;
	self.background.y = -40;//200;
	self.background.alignX = "center";
	self.background.alignY = "middle";
	self.background.horzAlign = "center";
	self.background.vertAlign = "middle";
	if(level.xenon)
		self.background setshader("popmenu_bg", 650, 52);
	else
		self.background setshader("popmenu_bg", 650, 42);
	self.background.alpha = .5;
}

add_hudelem_pulse(timer, noscale)
{
	level endon("hud_elem_going_up");
	level endon("hud_elem_interupt");
	self endon("destroying");
	self endon("destroyed");
	time = .45;

	if(!isdefined(noscale))
	{
		oldscale = self.fontScale;
		self.fontScale*=1.1;
		self thread hudelem_scaleovertime(time, oldscale);
	}
		for(i=0;i<3;i++)
			self add_hudelem_pulse_internal(time);
			
	self.alpha = 1;
	self.color = (1,1,1);
	
	if(isdefined(timer) && timer < 7)
		return;
	while(1)
	{
		wait 3.5;
		for(i=0;i<3;i++)
			self add_hudelem_pulse_internal(time);//, 1.01);
		self.alpha = 1;
		self.color = (1,1,1);
	}
}
add_hudelem_pulse_internal(time)
{
	self endon("destroying");
	self endon("destroyed");
	self.color = (.96,.96,.5);
	self fadeovertime(time);
	self.color = (1,1,1);
	
	wait time + .1;
}

hudelem_scaleovertime(time, size)
{
	self endon("destroying");
	self endon("destroyed");
	
	if(!isdefined(self))
		return;
	range = size - self.fontScale;
	
	num = time / .05; //TIME / SERVER FRAME
	
	frac = range / num; 
	
	
	
	for(i=0;i<num;i++)
	{
		if(!isdefined(self))
			return;
		self.fontScale += frac;
		wait .05;	
	}
}

detectFriendlyFire(numHitsAllowed)
{
	if (isSentient(self))
	{
		assertMsg("You can only call this function on a non-AI");
		return;
	}
	
	self setCanDamage(true);
	if (isdefined(numHitsAllowed))
	{
		for(;;)
		{
			self waittill ("damage", damage, attacker, parm1, parm2, weaponType);
			if (!isdefined(weaponType))
				continue;
			if (!isdefined (attacker))
				continue;
			if (attacker != level.player)
				continue;
			if (issubstr(weaponType, "GRENADE"))
			{
				if(maps\_spawner::killfriends_savecommit_afterGrenade())
					continue;
			}
			numHitsAllowed--;
			if (numHitsAllowed <= 0)
				break;
			else
			{
				if (!issubstr(weaponType, "RIFLE"))
					wait 0.5;
			}
		}
		thread maps\_spawner::killfriends_missionfail();
		return;
	}
	else
	{
		self.team = "allies";
		self.missionfail_trackDeath = true;
		self.health = 350;
		level thread maps\_spawner::killfriends_missionfail_think(self);
	}
}

script_trigger(org1,org2)  // hacks to spawn a box trigger without recompiling the map.
{
	assert(isdefined(org1)&&isdefined(org2));
	trigger = spawnstruct();
	trigger thread script_trigger_thread(org1,org2);
	return trigger;
}

script_trigger_thread(org1,org2)
{
	if(org2[2]<org1[2])
	{
		temp = org2;
		org2 = org1;
		org1 = temp;
	}
	radiusheight = org2[2]-org1[2];
	radiusorg = org1+vectormultiply(flat_origin(org2)-flat_origin(org1),.5);
	radiusradius = distance(radiusorg,org1);
	radiustrig = spawn( "trigger_radius", radiusorg, 0, radiusradius, radiusheight);
//	thread drawlinefortime(org1,org2,1,1,1,10);
//	thread drawlinefortime(radiustrig.origin,level.player.origin,1,0,0,10);
	self.radiustrig = radiustrig;
	while(1)
	{
		radiustrig waittill ("trigger");
		while(level.player istouching(radiustrig))
		{
			if(script_trigger_isbetween(level.player.origin,org1,org2))
				self notify ("trigger",level.player);
			wait .05;
		}
	}
}

script_trigger_isbetween(number,org1,org2)
{
	if
	(
	   is_between(org1[0],org2[0],number[0])
	&&is_between(org1[1],org2[1],number[1])
	&&is_between(org1[2],org2[2],number[2])
	)
	return true;
	else
		return false;
	
}

is_between(num1,num2,number)
{
	if(num2<num1)
	{
		temp = num2;
		num2 = num1;
		num1 = temp;
	}
	if(number>num1 && number<num2)
		return true;
	return false;
}

missionFailedWrapper()
{
	if ( level.missionfailed )
		return;

	level.missionfailed = true;	
	missionfailed();
}


// HUD based hint print system

createHint()
{
	hintStruct = spawnstruct();
	hintStruct.hintTexts = [];
	hintStruct.keyBinds = [];
	
	return ( hintStruct );
}


addHintString( hintString, hintBinding )
{
	assert( isDefined( hintString ) );
	precacheString( hintString );
	
	index = self.hintTexts.size;
	
	self.hintTexts[index] = hintString;
	if ( isDefined( hintBinding ) )
		self.keyBinds[index] = hintBinding;
	else
		self.keyBinds[index] = "unbound";
}


getHintString()
{
	for ( index = 0; index < self.hintTexts.size; index++ )
	{
		if ( !isBound( self.keyBinds[index] ) )
			continue;
			
		return ( self.hintTexts[index] );
	}

	// hack for now...
//	return ( &"MOSCOW_PLATFORM_UNBOUND" );
	return ( self.hintTexts[0] );
}


getHintBinding()
{
	for ( index = 0; index < self.hintTexts.size; index++ )
	{
		if ( !isBound( self.keyBinds[index] ) )
			continue;
			
		return ( self.keyBinds[index] );
	}
	return ( "" );
}


displayHintInterrupt( hintStruct, endNotify, displayTime )
{
	assert( !isDefined( level.hintInterruptElement ) );
	
	if ( isDefined( level.hintElement ) )
		level.hintElement hideHintElem();
	
	hintInterruptElement = createHintElem( hintStruct );
	level.hintElementHidden = true;

	if ( isDefined ( endNotify ) )
		hintInterruptElement thread endHintElemNotify( endNotify );

	if ( isDefined ( displayTime ) )
		hintInterruptElement thread endHintElemTimer( displayTime );
	
	level.hintInterruptElement = hintInterruptElement;
	
	hintInterruptElement waittill ( "death" );
	hintInterruptElement destroy();
	
	if ( isDefined( level.hintElement ) )
		level.hintElement unhideHintElem();
		
	level.hintElementHidden = false;
}


displayHintElem( hintStruct, endNotify, displayTime )
{
	if ( isDefined( level.hintElement ) )
		level.hintElement destroyHintElem( false );

	hintElement = createHintElem( hintStruct );
	if ( isDefined( level.hintElementHidden ) && level.hintElementHidden )
		hintElement.alpha = 0;

	hintElement thread updateHintElemText( hintStruct );
	hintElement thread scaleHintElem( 0.15, 1.25 );
	hintElement thread pulseHintElem( 7.0 );
	
	if ( isDefined ( endNotify ) )
		hintElement thread endHintElemNotify( endNotify );

	if ( isDefined ( displayTime ) )
		hintElement thread endHintElemTimer( displayTime );
	
	// assign a global handle for this hint
	level.hintElement = hintElement;

	hintElement waittill ( "death", fadeOut );

	if ( fadeOut )
		hintElement fadeHintElem( 0.15, 0 );
	
	hintElement destroy();
}


updateHintElemText( hintStruct )
{
	self endon ( "death" );
	
	while( true )
	{
		self.label = hintStruct getHintString();
//		self setText( getKeyBinding( hintStruct getHintBinding() )["key1"] );
		wait ( 0.05 );
	}
}


endHintElemNotify( endNotify )
{
	self endon ( "death" );
	
	level waittill ( endNotify );
	self thread destroyHintElem( false );
}


endHintElemTimer( displayTime )
{
	self endon ( "death" );
	
	wait ( displayTime );
	self thread destroyHintElem( true );
}


createHintElem( hintStruct )
{
	assert( isDefined( hintStruct ) );

	hintElement = newHudElem();
	hintElement.label = hintStruct getHintString();
//	hintElement setText( getKeyBinding( hintStruct getHintBinding() )["key1"] );
	hintElement.x = 320;
	hintElement.y = 200;
	hintElement.alignX = "center";
	hintElement.alignY = "middle";
	
	if(level.xenon)
		hintElement.fontScale = 2;
	else
		hintElement.fontScale = 1.6;

	return ( hintElement );
}


destroyHintElem( fadeOut )
{
	self notify ( "death", fadeOut );
}


hideHintElem()
{
	self.alpha = 0;
	self fadeOverTime( 0.05 );
}


unhideHintElem()
{
	self.alpha = 1;
	self fadeOverTime( 0.05 );
}

// utility functions
isBound( bindingName )
{
	binding = getKeyBinding( bindingName );
	if ( binding["count"] )
		return ( true );
	else
		return ( false );
}


pulseHintElem( pulseTime )
{
	self endon ( "death" );

	if ( !isDefined( pulseTime ) )
		pulseTime = 7000;
	else
		pulseTime = int( pulseTime * 1000 );

	time = 0;
	while ( time < pulseTime )
	{
		for ( index = 0; index < 3; index++ )
		{
			self.color = (0.96,0.96,0.5);
			self fadeOverTime( .45 );
			self.color = (1.0,1.0,1.0);
			wait ( .45 );
		}
		
		wait ( 3.5 );
		time += 4850;
	}
}

scaleHintElem( scaleTime, startScale )
{
	self endon ( "death" );
	
	scaleTime = int( scaleTime * 1000 );
	endScale = self.fontScale;
	startScale = self.fontScale * startScale;
	scaleRange = startScale - endScale;
	
	self.fontScale = startScale;
	
	for ( index = scaleTime; index >= 0; index -= 50 )
	{
		fraction = index / scaleTime;
		
		self.fontScale = endScale + scaleRange * fraction;
		wait ( 0.05 );
	}
}

fadeHintElem( fadeTime, endAlpha )
{
	self.alpha = endAlpha;
	self fadeOverTime( fadeTime );
	wait ( fadeTime );
}

drawTagForever(tag)
{
	self endon ("death");
	for (;;)
	{
		drawTag(tag);
		wait (0.05);
	}
}

drawTag(tag)
{
	org = self GetTagOrigin (tag);
	ang = self GetTagAngles (tag);
	forward = anglestoforward (ang);
	forwardFar = vectorScale(forward, 10);
	forwardClose = vectorScale(forward, 8);
	right = anglestoright (ang);
	leftdraw = vectorScale(right, -2);
	rightdraw = vectorScale(right, 2);
	
	up = anglestoup(ang);
	right = vectorScale(right, 10);
	up = vectorScale(up, 10);
	
	line (org, org + forwardFar, (0.9, 0.2, 0.2), 0.9);
	line (org + forwardFar, org + forwardClose + rightdraw, (0.9, 0.2, 0.2), 0.9);
	line (org + forwardFar, org + forwardClose + leftdraw, (0.9, 0.2, 0.2), 0.9);

	line (org, org + right, (0.2, 0.2, 0.9), 0.9);
	line (org, org + up, (0.2, 0.9, 0.2), 0.9);
}
