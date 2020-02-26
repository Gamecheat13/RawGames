/*
vectorScale (vec, scale)
	Returns the vector that is passed, scaled by the amount specified;

array_notify (ents, notify)
	Passes a notify to each of the ents in an array.

array_thread (ents, process, var, excluders)
	Each of the ents in array "ents" runs the thread "process". Optional "var" gets	passed
	with the function. Optional array of entities "excluders" do not run the thread.

array_levelthread (ents, process, var, excluders);
	Has the level start the thread "process" with each of the ents in the array "ents". Optional "var" gets
	passed with the function. Optional array of entities "excluders" do not run the thread.

cant_shoot()
	Minimizes an ai sight distance.

can_shoot()
	Returns an ai sight distance to normal.

error(msg)
	Stops the script and prints the specified message. Basically asserts things are true.

levelStartSave()
	Saves the begining of level autosave used for restarting the level.

autosave(num)
	Saves with the specified save number (from _autosave.gsc).

debug_message (msg, org)
	If cvar debug is 1, prints the message in 3d at the specified origin.

chain_off (chain)
	Turns off the friendly chain trigger that has "script_chain" of this string. STRING.

chain_on (chain)
	Turns on the friendly chain trigger that has "script_chain" of this string. STRING.

living_ai_wait_for_min (touchable, team, num, timer)
	Script stops here until enough "num" of a given "team" are touching "touchable".
	Gives up if the optional timer elapses.

living_ai_wait (touchable, team, include)
	Script stops here until all ai of "team" are touching "touchable". If health is passed as "include" then the
	script will wait until the health is gone or the player has at least 85% health.

living_ai_is_here (touchable, team)
	Returns true if ai of the given team is alive here.

precache (model)
	Precaches a given model.

add_to_array ( array, ent )
	Adds "ent" to "array". Useful for easily constructing an array of different entities.

getClosestAI (org, team, excluders)
	Returns the closest ai of "team" to the origin "org". Excludes an array of entities "excluders".

magic_bullet_shield()
	Usage "Actor thread magic_bullet_shield();".
	Makes the actor get ignored by AI for 5 seconds if he is shot, and have infinite health.

get_vehicle_group()
	Returns an array of spawners which have the same script_vehiclegroup as self

array_randomize()
	Note it is used like "array = shuffle_array_members(array);".

flood_spawn (spawners)
	Tells the spawners that are passed to spawn AI whenever their currently spawned AI die. Like "flood_spawner" trigger.

vectorMultiply (vec, dif)
	multiply a vector

Random (array)
	Returns a random entree from an array

get_friendly_chain_node (chainstring)
	Returns a node targetted by a friendly trigger with this string for its script_friendlychain

waittill_multiple (string1, string2, string3, string4, string5)
	Causes an entity to wait for multiple notifies to occur before progressing.

waittill_any (string1, string2, string3, string4, string5)
	Causes an entity to wait for any of a collection of strings to be notified.

keyHintPrint(message, binding)
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
	imagename = "levelshots/autosave/autosave_" + level.script + "start";
	println ("z:         imagename: ", imagename);

	// "levelstart" is recognized by the saveGame command as a special save game
	saveGame("levelstart", &"AUTOSAVE_LEVELSTART", imagename);
	println ("Saving level start saved game");
}

autosave(num)
{
	savedescription =  maps\_autosave::getnames(num);

	if ( !(isdefined (savedescription) ) )
	{
		println ("autosave ", num," with no save description in _autosave.gsc!");
		return;
	}

	imagename = "levelshots/autosave/autosave_" + level.script + num;
	println ("z:         imagename: ", imagename);

	maps\_autosave::healthchecksave(num, savedescription, imagename);
	println ("Saving game ", num," with desc ", savedescription);
}

error(msg)
{
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	println ("^c*ERROR* ", msg);
	maps\_spawner::waitframe();
	if (getcvar ("debug") != "1")
	{
		blah = getent ("Time to Stop the Script!", "targetname");
			println (THIS_IS_A_FORCED_ERROR___ATTACH_LOG.origin);
	}
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
	// GENERATES AN ERROR, DON'T FREAKIN TOUCH THIS FUNCTION PLEASE
}

cant_shoot()
{
	self.old_maxsightdistsqrd = self.maxsightdistsqrd;
//	if (self.team == "axis")
//		maps\_utility::error ("AXIS DID CANT SHOOT");
	self.maxsightdistsqrd = 3;
}

can_shoot()
{
	self.maxsightdistsqrd = self.old_maxsightdistsqrd;
}

array_levelthread (ents, process, var, excluders)
{
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

array_remove (ents, remover)
{
	for (i=0;i<ents.size;i++)
	{
		if (ents[i] != remover)
		{
			if (!isdefined (newents))
				newents[0] = ents[i];
			else
				newents[newents.size] = ents[i];
		}
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

debug_message (msg, org)
{
	if (getcvar ("debug") == "1")
	{
		timer = gettime() + 3000;
		while (timer > gettime())
		{
			print3d ((org + (0, 0, 45)), msg, (0.48,9.4,0.76), 0.85);
			maps\_spawner::waitframe();
		}
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

		println ("^5 ai left:", ents.size);
		if (ents.size <= 0)
			break;
			
		tracker = spawnstruct();
		tracker.ai_size = ents.size;

		for (i=0;i<ents.size;i++)
			tracker thread death_wait_notify(ents[i]);

		tracker waittill ("dead_autosave");
		if (!isdefined (include))
			continue;
			
		while (1)
		{
			breaker = true;
			for (i=0;i<include.size;i++)
			{
				if (!isdefined (include[i]))
					continue;

//				if ((isdefined (include[i].model)) && (include[i].model == "xmodel/healthpack"))
				if (isdefined (include[i].model))
				{
					current_health = (level.player.health * 100) / level.player.maxhealth;
//					println ("^5 current health " , current_health);
					if (current_health > 85)
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
}

living_ai_is_here (touchable, team) // Returns true if ai of the given team is alive here
{
	if (!isdefined (touchable))
	{
		println ("called living_ai_is_here without a legit touchable");
		return;
	}

	ai = getaiarray (team);
	for (i=0;i<ai.size;i++)
	{
		if ((ai[i] istouching (touchable)) && (isalive (ai[i])))
		{
			if (!isdefined (ents))
				ents[0] = ai[i];
			else
				ents[ents.size] = ai[i];
		}
	}

	if (isdefined (ents))
	{
		for (i=0;i<ents.size;i++)
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

subtract_from_array ( array, ent )
{
	if (!isdefined (array))
		return undefined;

	if (!isdefined (ent))
		return array;

	for (i=0;i<array.size;i++)
	{
		if (array[i] != ent)
		{
			if (!isdefined (newarray))
				newarray[0] = array[i];
			else
				newarray[newarray.size] = array[i];
		}
	}

	if (!isdefined (newarray))
		newarray = getentarray ("emptyarray","classname");

	return newarray;
}

getClosest (org, ents, excluders)
{
	if (!isdefined (ents))
		return undefined;

	if (isdefined (excluders))
	{

		for (i=0;i<ents.size;i++)
			exclude[i] = false;

		for (i=0;i<ents.size;i++)
		for (p=0;p<excluders.size;p++)
		if (ents[i] == excluders[p])
			exclude[i] = true;

		found_unexcluded = false;
		for (i=0;i<ents.size;i++)
		if ((!exclude[i]) && (isalive (ents[i])))
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
			if (newrange < range)
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

getClosestAI (org, team, excluders)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getClosest (org, ents, excluders);
}

stop_magic_bullet_shield(newhealth)
{
	self endon ("death");
	self waittill ("stop magic bullet shield");
	self.magic_bullet_shield = undefined;
	self.health = newhealth;
}

magic_bullet_shield(health,time, oldhealth)
{
	self endon ("stop magic bullet shield");
	self endon ("death");

	if (!isdefined (oldhealth))
		oldhealth = self.health;

	self thread stop_magic_bullet_shield(oldhealth);
	self.magic_bullet_shield = true;
	if (!isdefined (time))
		time = 5;

	if (!isdefined (health))
		health = 100000000;

	while (1)
	{
		self.health = health;
		self waittill ("pain");
//		self waittill ("stoppainFace");
		self.ignoreme = true;
		wait (time);
		self.ignoreme = false;
	}
}

get_vehicle_group()
{
	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	{
		if ( (isdefined (spawners[i].script_vehiclegroup) )
		&& (spawners[i].script_vehiclegroup == self.script_vehiclegroup) )
			vehiclegroup = maps\_utility::add_to_array ( vehiclegroup, spawners[i] );
	}
	return vehiclegroup;
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
	if (isdefined (self.script_radius))
		radius = self.script_radius;
	else
		radius = 128;

	// Range, max damage, min damage
	radiusDamage (self.origin, radius, self.script_damage, self.script_damage);
}

exploder (num)
{
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
		else
		if (!isdefined (ents[i].script_fxid))
			ents[i] thread brush_delete();
	}
}

exploder_sound ()
{
	if(isdefined(self.script_delay))
		wait self.script_delay;
	level thread playSoundinSpace (level.scr_sound[self.script_sound], self.origin);
}

cannon_effect ( source )
{
	if (!isdefined (source.script_delay))
		source.script_delay = 0;

	if ((isdefined (source.script_delay_min)) && (isdefined (source.script_delay_max)))
		source.script_delay = source.script_delay_min + randomfloat (source.script_delay_max - source.script_delay_min);

	if (isdefined (source.target))
		org = (getent (source.target,"targetname")).origin;

	level thread maps\_fx::OneShotfx(source.script_fxid, source.origin, source.script_delay, org);
}

fire_effect ( source )
{
	if (!isdefined (source.script_delay))
		source.script_delay = 0;

	if ((isdefined (source.script_delay_min)) && (isdefined (source.script_delay_max)))
		source.script_delay = source.script_delay_min + randomfloat (source.script_delay_max - source.script_delay_min);

	if (isdefined (source.target))
		org = (getent (source.target,"targetname")).origin;

	org1 = source.origin;
	firefx = source.script_firefx;
	ender = source.script_ender;
	timeout = source.script_firefxtimeout;
	if (isdefined (source.script_firefxdelay))
		delay = source.script_firefxdelay;
	else
		delay = 0.5;

	wait (source.script_delay);

//	loopfx(				fxId,	fxPos, 	waittime,	fxPos2,	fxStart,	fxStop,	timeout)
	maps\_fx::loopfx(	firefx,	org1,	delay,		org,	undefined,	ender,	timeout);
}

brush_delete()
{
	if (isdefined (self.script_delay))
		wait (self.script_delay);

	if (self.spawnflags & 1)
		self connectpaths();

	self delete();
}

brush_show()
{
	if (isdefined (self.script_delay))
		wait (self.script_delay);

	self show();
	self solid();
	if (self.spawnflags & 1)
		self connectpaths();
}

brush_throw()
{
	if (isdefined (self.script_delay))
		wait (self.script_delay);

	if (isdefined (self.target))
		ent = getent (self.target,"targetname");

	if (!isdefined (ent))
	{
		self delete();
		return;
	}

	self show();

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
	wait (6);
	self delete();

}

flood_spawn (spawners)
{
	maps\_spawner::flood_spawn (spawners);
}

vectorMultiply (vec, dif)
{
	vec = (vec[0] * dif, vec[1] * dif, vec[2] * dif);
	return vec;
}

set_ambient (track)
{
	level.ambient = track;
	if ((isdefined (level.ambient_track)) && (isdefined (level.ambient_track[track])))
	{
		ambientPlay (level.ambient_track[track], 2);
		println ("playing ambient track ", track);
	}
}

waittill_string (msg, ent)
{
	self endon ("death");
	ent endon ("die");
	self waittill (msg);
	ent notify ("returned");
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
		maps\_utility::error ("Tried to get chain " + chainstring + " which does not exist with script_chain on a trigger.");
		return undefined;
	}

	node = getnode (chain.target,"targetname");
	return node;
}

waittill_any (string1, string2, string3, string4, string5)
{
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

	ent waittill ("returned");
	ent notify ("die");
}

shock_ondeath()
{
	precacheShellshock("death");
	self waittill ("death");
	self shellshock("death", 3000);
}

delete_on_death (ent)
{
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

playSoundinSpace (alias, origin)
{
	org = spawn ("script_origin",(0,0,1));
	org.origin = origin;
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

		game["character" + game_characters] = ai[i] character\_utility::save();
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

	spawners = getspawnerarray ("allies");
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
			ai[index_ai] character\_utility::new();
			ai[index_ai] thread character\_utility::load(game["character" + (game_characters-1)]);
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
	character\_utility::precache(data);

	self waittill ("spawned",spawn);
	if (maps\_utility::spawn_failed(spawn))
		return;

	println ("Size is ", data["attach"].size);
	spawn character\_utility::new();
	spawn character\_utility::load(data);
}

keyHintPrint(message, binding)
{
	// Note that this will insert only the first bound key for the action
	iprintlnbold(message, binding["key1"]);
}
