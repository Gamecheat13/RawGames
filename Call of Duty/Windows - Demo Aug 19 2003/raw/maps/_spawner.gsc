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
	level.current_spawn_num = 0;

	mg42s = getentarray ("misc_mg42","classname");
	other_mg42s = getentarray ("misc_turret","classname");
	for (i=0;i<other_mg42s.size;i++)
		mg42s = maps\_utility::add_to_array ( mg42s, other_mg42s[i] );

 	maps\_utility::array_thread(mg42s, ::mg42_think);

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

		level thread spawn_think (ai[i]);
	}

	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
		level thread spawn_prethink(spawners[i]);

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

		ai = getaiarray ();
		for (i=0;i<ai.size;i++)
		if ((isdefined (ai[i].used_an_mg42)) ||
		((!isdefined (ai[i].script_mg42)) || (ai[i].script_mg42 != self.script_mg42)))
			excluders = maps\_utility::add_to_array ( excluders, ai[i] );

		ai = maps\_utility::getClosestAI (node.origin, undefined, excluders);
		excluders = undefined;

		if (isdefined (ai))
		{
			ai notify ("stop_going_to_node");
			ai thread go_to_node (node);
			ai waittill ("death");
/*
			self.flagged_for_use = false;
			self thread flag_turret_for_use (ai);
			ai setgoalnode (node);
			ai.oldgoalradius = ai.goalradius;
			ai.goalradius = 4;

			ai waittill ("goal");
			ai use_a_turret (self);
			ai waittill ("death");
*/
		}
		else
			self waittill ("get new user");
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
	spawners = getentarray (trigger.target,"targetname");
	maps\_utility::array_thread(spawners, ::flood_prethink);
	trigger waittill ("trigger");
	for (i=0;i<spawners.size;i++)
		if (isdefined (spawners[i]))
			final_spawners = maps\_utility::add_to_array (final_spawners, spawners[i]);

	if (isdefined (final_spawners))
		maps\_utility::array_thread(final_spawners, ::flood_think, trigger);

	if ((isdefined (trigger)) && (!isdefined (trigger.script_requires_player)))
		kill_trigger (trigger);
}

flood_spawn (spawners)
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
	self.targetname = ("null");
	self.start = true;
	self thread start_tracker();
}

flood_think(trigger)
{
	if (isdefined (self.started_flood_spawner))
		return;

	self.started_flood_spawner = true;

	if ((isdefined (self.spawnflags)) && (!(self.spawnflags & 1)))
		maps\_utility::error ("Spawner at origin " + self.origin + "/" + (self getorigin()) + " is not a spawner");

	count = 0;
	countrate = 1;
	if (isdefined (self.script_additive_delay))
		countrate = self.script_additive_delay;

	if ((isdefined (trigger)) && (isdefined (trigger.script_requires_player)))
		requires_player = true;
	else
		requires_player = false;

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

		// Add steve wait here
		ent = self dospawn();
		if (isdefined (ent))
		{
			ent waittill ("death");
			if (isdefined(ent))
				debug_message ("DIED", ent.origin);
			else
				debug_message ("DELETED");
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
		else
			wait (2);
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
				case 0:	aitype = "allies" ; break;
				case 1:	aitype = "axis" ; break;
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
			case 0:	aitype = "axis" ; break;
			case 1:	aitype = "allies" ; break;
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
//	wait (1);
	if (isdefined (trigger))
	{
		if (isdefined (trigger.targetname))
//			if (trigger.targetname == "friendly_wave")
			if (trigger.targetname != "flood_spawner")
				return;

//			println ("Deleted trigger with targetname ", trigger.targetname);
//		if (isdefined (trigger.target))
//			println ("Deleted trigger with target ", trigger.target);

		trigger delete();
	}
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

kill_spawner(trigger)
{
	killspawner = trigger.script_killspawner;

	trigger waittill ("trigger");
	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	if ((isdefined (spawners[i].script_killspawner)) && (killspawner == spawners[i].script_killspawner))
	{
		level thread debug_message ("DELETED", spawners[i].origin);
		spawners[i] delete();
	}

	kill_trigger (trigger);
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
	return;
	if (isdefined(trigger.target))
	{
		spawners = getentarray(trigger.target, "targetname");
		for (i=0;i<spawners.size;i++)
		if ((spawners[i].team == "axis") || (spawners[i].team == "allies"))
			level thread spawn_prethink(spawners[i]);
	}
}

drophealth()
{
	self waittill ("death");
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

spawner_mg42_notify (num)
{
	mg42s = getentarray ("misc_mg42","classname");
	other_mg42s = getentarray ("misc_turret","classname");
	for (i=0;i<other_mg42s.size;i++)
		mg42s = maps\_utility::add_to_array ( mg42s, other_mg42s[i] );

	for (i=0;i<mg42s.size;i++)
	if ((isdefined(mg42s[i].script_mg42)) && (mg42s[i].script_mg42 == num))
		mg42 = maps\_utility::add_to_array (mg42, mg42s[i]);

	if (!isdefined (mg42))
		return;

	mg42s = undefined;

	while (1)
	{
		self waittill ("spawned");
		for (i=0;i<mg42.size;i++)
		{
			if (!mg42[i].flagged_for_use)
			{
				mg42[i] notify ("get new user");
				break;
			}
		}
	}
}

spawn_prethink(spawner)
{
	if (isdefined (spawner.script_health))
	{
		if (spawner.script_health > level._max_script_health)
			level._max_script_health = spawner.script_health;

		array_size = 0;
		if (isdefined (level._ai_health))
		if (isdefined (level._ai_health[spawner.script_health]))
			array_size = level._ai_health[spawner.script_health].size;

//		println ("spawner is member ", array_size," of script_health ",  spawner.script_health);

		level._ai_health[spawner.script_health][array_size] = spawner;
	}

	if (isdefined (spawner.script_mg42))
		spawner thread spawner_mg42_notify (spawner.script_mg42);

	if (isdefined (spawner.script_delete))
	{
		array_size = 0;
		if (isdefined (level._ai_delete))
		if (isdefined (level._ai_delete[spawner.script_delete]))
			array_size = level._ai_delete[spawner.script_delete].size;

		level._ai_delete[spawner.script_delete][array_size] = spawner;
	}

	while (1)
	{
//		if (spawner.spawnflags & 2)
//			maps\_utility::error ("FORCESPAWN");
		spawner waittill ("spawned", spawned);
		if ((!isSentient (spawned)) || (!isalive (spawned)))
			return;

		level thread debug_message ("SPAWNED", spawned.origin);

		if (isdefined(spawner.script_delete))
		{
			for (i=0;i<level._ai_delete[spawner.script_delete].size;i++)
			{
				if (level._ai_delete[spawner.script_delete][i] != spawner)
					level._ai_delete[spawner.script_delete][i] delete();
			}
		}

		if (isdefined (spawner.targetname))
			level thread spawn_think (spawned, spawner.targetname);
		else
			level thread spawn_think (spawned);
	}
}

// Wrapper for spawn_think
spawn_think (spawned, targetname)
{
	spawn_think_action (spawned, targetname);
	if (isalive (spawned))
	{
		spawned.finished_spawning = true;
		spawned notify ("finished spawning");
	}
}

// Actually do the spawn_think
spawn_think_action (spawned, targetname)
{
	self thread tanksquish();
//	maps\_spawner::waitframe(); // silly way to let the drop health get insured if a spawner is placed to go off at start
	if ((isdefined (spawned.script_moveoverride)) && (spawned.script_moveoverride == 1))
		override = true;
	else
		override = false;

	if ((spawned.team == "allies") && (!isdefined (spawned.script_personality)))
		spawned thread maps\_personality::create();

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
			spawned.targetname = "secondfloor_gren_guy";
			spawned.maxSightDistSqrd = 90000;
		}
	}
	if (isdefined (spawned.used_an_mg42)) // This AI was called upon to use an MG42 so he's not going to run to his node.
		override = true;

	if (!override)
	{
		if ( spawned.team == "allies" )
			spawned.grenadeawareness  = .9;
		if ( spawned.team == "axis" )
		{
			num = randomint(3);
			if (num == 0)
				spawned.grenadeawareness  = 0;
			else
				spawned.grenadeawareness  = .2;
		}

		spawned.suppressionwait = 2;
	}

	if (isdefined (spawned.script_suppression))
		spawned.suppressionwait = spawned.script_suppression;

	// Set the accuracy for the spawner
	if (isdefined(spawned.script_accuracy))
	{
		spawned.accuracy = spawned.script_accuracy;
	}

	if (isdefined(spawned.script_accuracyStationaryMod))
	{
		spawned.accuracyStationaryMod = spawned.script_accuracyStationaryMod;
	}

    // JBW - allied reinforcements are in a hurry
    if ( spawned.team == "allies" )
        spawned . walkdist = 16;


	if (isdefined(spawned.script_ignoreme))
		spawned.ignoreme = true;

	if (isdefined(spawned.drophealth))
		spawned thread drophealth();

	if (isdefined(spawned.script_sightrange))
		spawned.maxSightDistSqrd = spawned.script_sightrange;

	if (!override)
	{
		if (isdefined (spawned.script_radius))
			spawned.goalradius = spawned.script_radius;
		else
			spawned.goalradius = 512;
//			println (spawned.export + "-- 512");
	}

	if (spawned.team != "axis")
	{
		spawned thread use_for_ammo();

		// Set the followmin for friendlies
		if (isdefined(spawned.script_followmin))
		{
			spawned.followmin = spawned.script_followmin;
		}

		// Set the followmax for friendlies
		if (isdefined(spawned.script_followmax))
		{
			spawned.followmax = spawned.script_followmax;
		}


		// Set the on death thread for friendlies
		spawned maps\_names::get_name();
		level thread friendly_waittill_death (spawned);
	}


	// sets the favorite enemy of a spawner
	if (isdefined(spawned.script_favoriteenemy))
	{
	//	println ("favorite enemy is defined");
		if (spawned.script_favoriteenemy == "player")
		{
			spawned.favoriteenemy = level.player;
			level.player.targetname = "player";
	//		println ("setting favoriteenemy = player");
		}
	}


	// Gives AI grenades
	if (isdefined(spawned.script_grenades))
	{
		spawned.grenadeAmmo = spawned.script_grenades;
//		println ("giving someone some grenades.");
	}

	// Puts AI in pacifist mode
	if (isdefined(spawned.script_pacifist))
	{
		spawned.pacifist = true;
//		println ("giving someone some grenades.");
	}

	// Set the health for special cases
	if (isdefined(spawned.script_startinghealth))
	{
		spawned.health = spawned.script_startinghealth;
	}

	// The AI will spawn and attack the player
	if (isdefined(spawned.script_playerseek))
	{
		spawned setgoalentity (level.player);
		return;
	}

	// The AI will spawn and follow a patrol
	if (isdefined(spawned.script_patroller))
	{
		spawned thread maps\_patrol::patrol();
		return;
	}

	// The AI will spawn and use his .radius as a goalradius, and his goalradius will get smaller over time.
	if (isdefined(spawned.script_delayed_playerseek))
	{
		if (!isdefined (spawned.script_radius))
			spawned.goalradius = 800;

		spawned setgoalentity (level.player);

		while (isalive (spawned))
		{
			if (spawned.goalradius > 200)
				spawned.goalradius -= 200;

			wait 6;
		}
		return;
	}


	if (override)
		return;

	// The AI will run to a target node and use the node's .radius as his goalradius.
	// If script_seekgoal is set, then he will run to his node with a goalradius of 0, then set his goal radius
	//    to the node's radius.
	if (isdefined(spawned.target))
		spawned thread go_to_node ();
}


flag_turret_for_use (ai)
{
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
			return;
	}

	if (isdefined (node.target))
	{
		turret = getent (node.target, "targetname");
		if ((isdefined (turret)) && ((turret.classname == "misc_mg42") || (turret.classname == "misc_turret")))
			turret thread flag_turret_for_use (self);
	}

	self setgoalnode(node);
	if (isdefined (self.script_seekgoal))
	{
		self.goalradius = (0);
		self waittill ("goal");
	}

	if (node.radius != 0)
		self.goalradius = (node.radius);
	else
		self.goalradius = (512);

	if (isdefined (node.target))
	{
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
}

use_a_turret (turret)
{
	self useturret(turret); // dude should be near the mg42
	turret setmode("auto_ai"); // auto, auto_ai, manual
	if ((isdefined (turret.target)) &&
	(turret.target != turret.targetname) &&
	(getent (turret.target,"targetname").classname == "script_origin"))
	{
		target = getent (turret.target, "targetname");
		turret.manual_target = target;
		turret settargetentity(target);
		turret setmode("manual_ai"); // auto, auto_ai, manual
		self thread maps\_mg42::manual_think (turret);
		if (isdefined (self.script_mg42auto))
			println ("AI at origin ", self.origin , " has script_mg42auto");
	}

	self thread maps\_mg42::mg42_firing(turret);
	turret notify ("startfiring");

	self useturret(turret); // dude should be near the mg42
}

fallback_spawner_think (num, node)
{
	self waittill ("spawned", spawn);
	if (getcvar ("fallback") == "1")
		println ("^a First spawned: ", num);
	level notify (("fallback_firstspawn" + num));
	// Temp change until bug gets fixed
	if (!isalive (spawn))
		return;
	// Temp change until bug gets fixed

	spawn thread fallback_ai_think (num, node);

	while (self.count > 0)
	{
		self waittill ("spawned", spawn);
		maps\_spawner::waitframe(); // Wait until he does all his usual spawned logic so he will run to his node
		if (isalive (spawn))
			spawn thread fallback_ai_think (num, node);
		else
			level notify (("fallbacker_died" + num));
	}

//	level notify (("fallbacker_died" + num));
}

fallback_ai_think_death(ai, num)
{
	ai waittill ("death");
	level.current_fallbackers[num]--;

	level notify (("fallbacker_died" + num));
}

fallback_ai_think (num, node)
{
	if ((!isdefined (self.fallback)) || (!isdefined (self.fallback[num])))
		self.fallback[num] = true;
	else
		return;

	self.script_fallback = num;
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
	self.bravery = self.oldbravery;

	self notify ("fallback_notify");
	self notify ("stop_coverprint");
}

fallback_ai (num, node)
{
	self notify ("stop_going_to_node");

	self stopuseturret();
	self.oldsuppressionwait = self.suppressionwait;
	self.suppressionwait = 0;
	self.oldbravery = self.bravery;
	self.bravery = 5000;
	self setgoalnode (node);
	if (isdefined (node.radius))
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
	first_half = (int) first_half;

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
		temp = (int) (total * 0.4);

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
			self.oldbravery = self.bravery;
			self.bravery = 500;
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
	return; // Use for ammo is disabled pending further design decisions.

	while (isalive (self))
	{
		self waittill("trigger");

		currentweapon = level.player getCurrentWeapon();
		level.player giveMaxAmmo(currentweapon);
		println ("Giving player ammo for current weapon");
		wait 3;
	}
}

friendly_waittill_death (spawned)
{
	// Disabled globally by Zied, addresses bug 3092, too much text on screen.
	/////////////
	return;
	////////////


	if (isdefined (spawned.script_noDeathMessage))
		return;

	name = spawned.name;

	spawned waittill ("death");
	if ((level.script != "stalingrad") && (level.script != "stalingrad_nolight"))
		println (name, " - KIA");
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

friendly_wave (trigger)
{
	if (!isdefined (level.friendly_wave_active))
		thread friendly_wave_masterthread();

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
	level.totalfriends = 0;

	triggers = getentarray ("friendly_wave", "targetname");
	maps\_utility::array_thread(triggers, ::set_spawncount, 0);

	friends = getaiarray ("allies");
	maps\_utility::array_thread(friends, ::friendlydeath_thread);

	if (!isdefined (level.maxfriendlies))
		level.maxfriendlies = 7;

	names = 1;
	while (1)
	{
		if ((isdefined (level.friendly_wave_trigger)) && (isdefined (level.friendly_wave_trigger.target)))
		{
			spawn = getentarray (level.friendly_wave_trigger.target, "targetname");
			while ((isdefined (level.friendly_wave_trigger)) && (level.totalfriends < level.maxfriendlies))
			{
				num = randomint (spawn.size);

				spawn[num].count = 1;
				spawned = spawn[num] dospawn();
				spawn[num].count = 0;

				if (isdefined (spawned))
				{
					if (isdefined (level.friendlywave_thread))
						level thread [[level.friendlywave_thread]](spawned);
					else
					{
						spawned setgoalentity (level.player);
					}

					spawned maps\_names::get_name();
					spawned thread friendlydeath_thread();
					wait (randomfloat (5));
//					println ("^a total friends ", level.totalfriends);
				}
				else
					break;
			}
		}

		level waittill ("friendly_died");
	}
}

friendly_mg42(trigger)
{
	if (!isdefined (trigger.target))
		maps\_utility::error ("No target for friendly_mg42 trigger, origin:" + trigger getorigin());

	node = getnode (trigger.target,"targetname");

	if (!isdefined (node.target))
		maps\_utility::error ("No mg42 for friendly_mg42 trigger's node, origin: " + node.origin);

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
//	self setHintString ("Press [use] to make your squadmate move off the MG42.");
	self waittill ("trigger");
	println ("^a was used by player, stop using turret");
	self.useable = false;
	self stopuseturret();
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

	if (distance (level.player getorigin(), node.origin) < 100)
	{
//		println ("^a player too close");
		return false;
	}

	if (isdefined (self.chainnode))
	if (distance (level.player getorigin(), self.chainnode.origin) > 1100)
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
	self.oldbravery = self.bravery;

	self.suppressionwait = 0;
	self.bravery = 50000;

	self waittill ("goal");
	self.goalradius = self.oldradius;
	if (self.goalradius < 32)
		self.goalradius = 400;

//	println ("^3 my goal radius is ", self.goalradius);
	self.suppressionwait = self.oldsuppressionwait;
	self.bravery = self.oldbravery;

	// Temporary fix waiting on new code command to see who the player is following.
//	self setgoalentity (level.player);
	self.goalradius = self.oldradius;

	if (distance (level.player getorigin(), node.origin) < 32)
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
	mg42 waittill ("friendly_finished_using_mg42");
	self friendly_mg42_doneUsingTurret();
}

friendly_mg42_doneUsingTurret ()
{
	self endon ("death");
	turret = self.friendly_mg42;
	self.friendly_mg42 = undefined;
	self stopuseturret();
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
	self notify ("tanksquishoff");
	self endon ("tanksquishoff");
	while(1)
	{
		self waittill ("damage",amt,who);
		if(!isalive(self) && isdefined(who) && isdefined(who.vehicletype))
			self playsound ("human_crunch");
	}
}