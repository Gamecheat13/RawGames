init_mg42settings()
{
	level.mg42settings["easy"]["convergenceTime"] = 2.5;
	level.mg42settings["easy"]["suppressionTime"] = 3.0;
	level.mg42settings["easy"]["accuracy"] = 0.38;
	level.mg42settings["easy"]["aiSpread"] = 2;
	level.mg42settings["easy"]["playerSpread"] = 0.5;	

	level.mg42settings["medium"]["convergenceTime"] = 1.5;
	level.mg42settings["medium"]["suppressionTime"] = 3.0;
	level.mg42settings["medium"]["accuracy"] = 0.38;
	level.mg42settings["medium"]["aiSpread"] = 2;
	level.mg42settings["medium"]["playerSpread"] = 0.5;	

	level.mg42settings["hard"]["convergenceTime"] = .8;
	level.mg42settings["hard"]["suppressionTime"] = 3.0;
	level.mg42settings["hard"]["accuracy"] = 0.38;
	level.mg42settings["hard"]["aiSpread"] = 2;
	level.mg42settings["hard"]["playerSpread"] = 0.5;	

	level.mg42settings["fu"]["convergenceTime"] = .4;
	level.mg42settings["fu"]["suppressionTime"] = 3.0;
	level.mg42settings["fu"]["accuracy"] = 0.38;
	level.mg42settings["fu"]["aiSpread"] = 2;
	level.mg42settings["fu"]["playerSpread"] = 0.5;	
}


main()
{
	if (getcvar("mg42") == "")
		setcvar("mg42", "off");
//	level.mg42timer = gettime();
	mg42guys = getentarray ("mg42", "targetname");
	for (i=0;i<mg42guys.size;i++)
		mg42guys[i] thread mg42_think();
		
	cover = getentarray ("mg42cover", "targetname");
	for (i=0;i<cover.size;i++)
		cover[i] thread mg42_coverthink("crater");
		
	cover = getentarray ("mg42cover_cow", "targetname");
	for (i=0;i<cover.size;i++)
		cover[i] thread mg42_coverthink("cow");

	level.magic_distance = 24;
}

mg42_coverthink(covertype)
{
//	println (getbrushmodelcenter(self), " with covertype ", covertype);
	while (1)
	{
		level.player_covertrigger = undefined;
		self waittill ("trigger");
		level.player_covertype = covertype;
		while (level.player istouching (self))
		{
			level.player_covertrigger = self;
			wait 1;
		}
	}
}

mg42_trigger()
{
	self waittill ("trigger");
	level notify (self.targetname);
	level.mg42_trigger[self.targetname] = true;
//	println ("trigger at ", self getorigin()," was triggered");
	self delete();
}

mg42_auto(trigger)
{
	trigger waittill ("trigger");
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
	{
		if ((isdefined (ai[i].script_mg42auto)) && (trigger.script_mg42auto == ai[i].script_mg42auto))
		{
			ai[i] notify ("auto_ai");
			println ("^a ai auto on!");
		}
	}

	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	if ((isdefined (spawners[i].script_mg42auto)) && (trigger.script_mg42auto == spawners[i].script_mg42auto))
	{
		spawners[i].ai_mode = "auto_ai";
		println ("^aspawner ", i," set to auto");
	}
		
	maps\_spawner::kill_trigger (trigger);
}

mg42_suppressionFire(targets)
{
	self endon("death");
	self endon("stop_suppressionFire");
	if (!isdefined (self.suppresionFire))
		self.suppresionFire = true;
	
	for (;;)
	{
		while(self.suppresionFire)
		{
			self settargetentity(targets[randomint(targets.size)]);
			wait (2 + randomfloat(2));
		}
		
		self cleartargetentity();
		while(!self.suppresionFire)
			wait 1;
	}
}

manual_think(mg42) // For regular spawned guys that are told to use mg42s manually vs static target
{
	org = self.origin;
	self waittill ("auto_ai");
	mg42 notify ("stopfiring");
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	mg42 settargetentity(level.player);
	/*
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	self useturret(mg42); // dude should be near the mg42
	self.favoriteEnemy = level.player;
//	self doDamage ( 25, self.origin );
	*/
}

burst_fire_settings(setting)
{
	if (setting == "delay")
		return 0.1;
	else
	if (setting == "delay_range")
		return 0.5;
	else
	if (setting == "burst")
		return 0.5;
	else
//	if (setting == "burst_range")
		return 1.5;
}

burst_fire(mg42, manual_target)
{
	if (isdefined (mg42.script_delay_min))
		mg42_delay = mg42.script_delay_min;
	else
		mg42_delay = maps\_mg42::burst_fire_settings ("delay");

	if (isdefined (mg42.script_delay_max)) 
		mg42_delay_range = mg42.script_delay_max - mg42_delay;
	else
		mg42_delay_range = maps\_mg42::burst_fire_settings ("delay_range");

	if (isdefined (mg42.script_burst_min))
		mg42_burst = mg42.script_burst_min;
	else
		mg42_burst = maps\_mg42::burst_fire_settings ("burst");

	if (isdefined (mg42.script_burst_max)) 
		mg42_burst_range = mg42.script_burst_max - mg42_burst;
	else
		mg42_burst_range = maps\_mg42::burst_fire_settings ("burst_range");

	mg42 endon ("stopfiring");
	while (1)
	{	
		mg42 startfiring();

		if (isdefined (manual_target))
			mg42 thread random_spread (manual_target);
			
		wait (mg42_burst + randomfloat(mg42_burst_range));

		mg42 stopfiring();

		wait (mg42_delay + randomfloat(mg42_delay_range));
	}
}

burst_fire_unmanned()
{
	self endon("death");
	if (isdefined (self.script_delay_min))
		mg42_delay = self.script_delay_min;
	else
		mg42_delay = burst_fire_settings ("delay");

	if (isdefined (self.script_delay_max)) 
		mg42_delay_range = self.script_delay_max - mg42_delay;
	else
		mg42_delay_range = burst_fire_settings ("delay_range");

	if (isdefined (self.script_burst_min))
		mg42_burst = self.script_burst_min;
	else
		mg42_burst = burst_fire_settings ("burst");

	if (isdefined (self.script_burst_max)) 
		mg42_burst_range = self.script_burst_max - mg42_burst;
	else
		mg42_burst_range = burst_fire_settings ("burst_range");

	pauseUntilTime = gettime();
	turretState = "start";

	for (;;)
	{
		duration = (pauseUntilTime - gettime()) * 0.001;
		if (self isFiringTurret() && (duration <= 0))
		{
			if (turretState != "fire")
			{
				turretState = "fire";

//				self setAnimKnobRestart(%standMG42gun_fire_foward);

				thread DoShoot();
			}

			duration = mg42_burst + randomfloat(mg42_burst_range);

			//println("fire duration: ", duration);
			thread TurretTimer(duration);

			self waittill("turretstatechange"); // code or script

			duration = mg42_delay + randomfloat(mg42_delay_range);
			//println("stop fire duration: ", duration);

			pauseUntilTime = gettime() + int(duration * 1000);
		}
		else
		{
			if (turretState != "aim")
			{
				turretState = "aim";

//				self setAnimKnobRestart(%standMG42gun_aim_foward);
			}
			
			//println("aim duration: ", duration);
			thread TurretTimer(duration);

			self waittill("turretstatechange"); // code or script
		}
	}
}

DoShoot()
{
	self endon("death");
	self endon("turretstatechange"); // code or script

	for (;;)
	{
		self ShootTurret();
		wait 0.1;
	}
}

TurretTimer(duration)
{
	if (duration <= 0)
		return;

	self endon("turretstatechange"); // code

	//println("start turret timer");

	wait duration;
	if (isdefined(self))
		self notify("turretstatechange");

	//println("end turret timer");
}

random_spread(ent)
{
	self endon("death");

	self notify ("stop random_spread");
	self endon ("stop random_spread");
	
	self endon ("stopfiring");
	self settargetentity(ent);
	
	while (1)
	{
		if (ent == level.player)
			ent.origin = self.manual_target getorigin();
		else
			ent.origin = self.manual_target.origin;

		ent.origin += (20 - randomfloat (40), 20 - randomfloat (40), 20 - randomfloat (60));
		wait (0.2);
	}
}

mg42_firing(mg42)
{
//	return;
	if (!isdefined (self.is_firing))
		self.is_firing = true;
	else
		return;
	
	ent = undefined;
	if (isdefined (mg42.manual_target))
		ent = spawn ("script_origin", (0,0,0));
		
	while (1)
	{
		mg42 waittill ("startfiring");
//		if ((isdefined (self.classname)) && (self.classname == "misc_mg42"))
		if (isdefined (mg42.manual_target))
			self thread burst_fire(mg42, ent);
		mg42 startfiring();
		mg42 waittill ("stopfiring");
		mg42 stopfiring();
	}
}

mg42_think()
{		
	if (!isdefined (self.ai_mode))
		self.ai_mode = "manual_ai";
		
	node = getnode(self.target, "targetname");
	if (!isdefined (node))
	{
		println ("Guy at org ", self.origin," had no node");
		return;
	}
	mg42 = getent(node.target, "targetname");
	mg42.org = node.origin;
	
	if (isdefined (mg42.target))
	{
		if ((!isdefined (level.mg42_trigger)) || (!isdefined (level.mg42_trigger[mg42.target])))
		{
			level.mg42_trigger[mg42.target] = false;
			getent (mg42.target, "targetname") thread mg42_trigger();
		}
		trigger = true;
	}
	else
		trigger = false;

	while (1)
	{		
		if (self.count == 0)
			return;

		mg42_gunner = undefined;			
		while (!isdefined (mg42_gunner))
		{
			mg42_gunner = self dospawn();
			wait (1);
		}
		
//		println ("gunner thinking");

		mg42_gunner thread mg42_gunner_think (mg42, trigger, self.ai_mode);
		mg42_gunner thread mg42_firing(mg42);
		
		mg42_gunner waittill ("death");
//		println ("gunner thought");
		if (isdefined (self.script_delay))
			wait (self.script_delay);
		else
		if ((isdefined (self.script_delay_min)) && (isdefined (self.script_delay_max)))
			wait (self.script_delay_min + randomfloat (self.script_delay_max - self.script_delay_min));
		else
			wait (1);
	}
}

kill_objects (owner, msg, temp1, temp2)
{
	owner waittill (msg);
	if (isdefined (temp1))
		temp1 delete();
		
	if (isdefined (temp2))
		temp2 delete();
}

mg42_gunner_think (mg42, trigger, ai_mode)
{
	self endon ("death");

	if (ai_mode == "manual_ai")
	{
		while (1)
		{
			self thread mg42_gunner_manual_think (mg42, trigger);
			self waittill ("auto_ai");			
			self move_use_turret (mg42, "auto_ai"); // was setmode("auto_ai") and cleartargetentity()
			self waittill ("manual_ai");
		}
	}
	else
	{
		while (1)
		{
			self move_use_turret (mg42, "auto_ai", level.player); // was setmode("auto_ai") and settargetentity(level.player)
			self waittill ("manual_ai");
			self thread mg42_gunner_manual_think (mg42, trigger);
			self waittill ("auto_ai");
		}
	}
}

player_safe()
{
	if (!isdefined (level.player_covertrigger))
		return false;

	if (level.player getstance() == "prone")
		return true;

	if ((level.player_covertype == "cow") && (level.player getstance() == "crouch"))
		return true;

	return false;
}

stance_num ()
{
	if (level.player getstance() == "prone")
		return (0,0,5);
	else
	if (level.player getstance() == "crouch")
		return (0,0,25);
	
	return (0,0,50);
}

mg42_gunner_manual_think(mg42, trigger)
{
	self endon ("death");
	self endon ("auto_ai");

//	maps\_utility::debug_message ("MANUAL", self.origin);
	
	self.pacifist = true;
	self setgoalpos (mg42.org);
	self.goalradius = level.magic_distance;
	self waittill ("goal");

	if (trigger)
	{
		if (!level.mg42_trigger[mg42.target])
			level waittill (mg42.target);
	}
	
	self.pacifist = false;
	
//	mg42 setmode("manual_ai"); // auto, auto_ai, manual
	mg42 setmode("auto_ai"); // auto, auto_ai, manual
	mg42 cleartargetentity();
	targ_org = spawn ("script_origin", (0,0,0));

	tempmodel = spawn ("script_model", (0, 0, 0));
	tempmodel.scale = 3;
	if (getcvar("mg42") != "off")
	tempmodel setmodel ("xmodel/temp");
	tempmodel thread temp_think(mg42, targ_org);
	level thread kill_objects(self, "death", targ_org, tempmodel);
	level thread kill_objects(self, "auto_ai", targ_org, tempmodel);
	
	mg42.player_target = false;
	mg42timer = 0;
	targets = getentarray ("mg42_target","targetname");

	if (targets.size > 0)
	{
		script_targets = true;
		current_org = targets[randomint (targets.size)].origin;
		
		self thread shoot_mg42_script_targets(targets);
		self move_use_turret (mg42);
		self.target_entity = targ_org;
		mg42 setmode("manual_ai"); // auto, auto_ai, manual
		mg42 settargetentity(targ_org);
		mg42 notify ("startfiring");
		 
		mindist = 15;
		wait_time = 0.08; // 2.8 / 20;
		dif = 0.05; // 1 / 20;
//		player_safe_time = gettime() + 5500 + randomfloat (5000);
		targ_org.origin = targets[randomint (targets.size)].origin;

		shoot_timer = 0;
//		while (gettime() < player_safe_time)
			
		while (!isdefined (level.player_covertrigger))
		{
			current_org = targ_org.origin;
			if (distance (current_org, targets[self.gun_targ].origin) > mindist)
			{
				temp_vec = vectornormalize (targets[self.gun_targ].origin - current_org);
				temp_vec = maps\_utility::vectorScale (temp_vec, mindist);
				current_org += temp_vec;
			}
			else
				self notify ("next_target");

			targ_org.origin = current_org;

			wait (0.1);
		}
		
		while (1)
		{
			for (i=0;i<1;i+=dif)
			{
				targ_org.origin = vectorMultiply (current_org, 1.0-i) + 
					vectorMultiply (level.player getorigin() + stance_num(), i);

				if (player_safe())
					i = 2;
								
				wait (wait_time);
			}

			old_org = level.player getorigin();
			while (!player_safe())
			{
				targ_org.origin = level.player getorigin();
				vec_dif = targ_org.origin - old_org;
				targ_org.origin = targ_org.origin + vec_dif + stance_num();
				old_org = level.player getorigin();
				wait (0.1);
			}
	
			if (player_safe())
			{
				shoot_timer = gettime() + 1500 + randomfloat (4000);
				while ((player_safe()) && (isdefined (level.player_covertrigger.target)) && (gettime() < shoot_timer))
				{
					target = getentarray (level.player_covertrigger.target, "targetname");
					target = target[randomint(target.size)];
					targ_org.origin = target.origin + 
						(randomfloat (30) - 15, randomfloat (30) - 15, randomfloat (40) - 60);
						
					wait (0.1);
				}
			}

			self notify ("next_target");
			while (player_safe())
			{
				current_org = targ_org.origin;
				if (distance (current_org, targets[self.gun_targ].origin) > mindist)
				{
					temp_vec = vectornormalize (targets[self.gun_targ].origin - current_org);
					temp_vec = maps\_utility::vectorScale (temp_vec, mindist);
					current_org += temp_vec;
				}
				else
					self notify ("next_target");

				targ_org.origin = current_org;

				wait (0.1);
			}
		}
	}
	else
	{
		while (1)
		{
			// Play is not safe, shoot player.
			self move_use_turret (mg42);
			while (!isdefined (level.player_covertrigger))
			{
				if (!mg42.player_target)
				{
					mg42 settargetentity(level.player);
					mg42.player_target = true;
	//				mg42 settargetentity(tempmodel);
					tempmodel.targent = level.player;
				}
				wait (0.2);
			}
			
			// Player is safe so shoot in front of him.
			mg42 setmode("manual_ai"); // auto, auto_ai, manual
			self move_use_turret (mg42);
			mg42 notify ("startfiring");
			shoot_timer = gettime() + 1500 + randomfloat (4000);
			while (shoot_timer > gettime())
			{
				if (isdefined (level.player_covertrigger))
				{
					target = getentarray (level.player_covertrigger.target, "targetname");
					target = target[randomint(target.size)];
					targ_org.origin = target.origin + 
						(randomfloat (30) - 15, randomfloat (30) - 15, randomfloat (40) - 60);
					mg42 settargetentity(targ_org);
					tempmodel.targent = targ_org;
					wait (randomfloat (1));
				}
				else
					break;
			}
			mg42 notify ("stopfiring");

			// Play is still safe, shoot friendlies.
			self move_use_turret (mg42);
			if (mg42.player_target)
			{
				mg42 setmode("auto_ai"); // auto, auto_ai, manual
				mg42 cleartargetentity();
				mg42.player_target = false;
				tempmodel.targent = tempmodel;
				tempmodel.origin = (0,0,0);
			}

			while (isdefined (level.player_covertrigger))
				wait (0.2);			
			
			wait (.750 + randomfloat (.200));
		}	
	}
}


shoot_mg42_script_targets(targets)
{
	self endon ("death");
	while (1)
	{
		targ_filled = [];
		for (i=0;i<targets.size;i++)
			targ_filled[i] = false;
			
		for (i=0;i<targets.size;i++)
		{
			self.gun_targ = randomint (targets.size);
			self waittill ("next_target");
			while (targ_filled[self.gun_targ])
			{
				self.gun_targ++;
				if (self.gun_targ >= targets.size)
					self.gun_targ = 0;
			}
			
			targ_filled[self.gun_targ] = true;
			
			/*
			dist = distance (targets[gun_targ].origin, mg42.org);
			dist = 1.0 / dist;
			
			for (dif=0;dif<1;dif+=dist)
			{
				targ_org.origin = (targets[last_target].origin * (1.0 - dif)) + (targets[gun_targ].origin * dif);
				wait (0.1);
			}
			last_target = gun_targ;
			*/
		}
	}
}	

	/*
	while (1)
	{
		if (isdefined (level.player_covertrigger))
		{
			mg42 setmode("manual_ai"); // auto, auto_ai, manual
			target = getentarray (level.player_covertrigger.target, "targetname");
			target = target[randomint(target.size)];
			targ_org.origin = target.origin + 
				(randomfloat (10) - 5, randomfloat (10) - 5, randomfloat (10) - 10);
			mg42 settargetentity(targ_org);
			tempmodel.targent = targ_org;
			mg42.player_target = true;
			mg42 notify ("startfiring");
			wait (randomfloat (1));
			mg42 notify ("stopfiring");
		}
		else
		{
			if (mg42.player_target)
			{
				mg42 setmode("auto_ai"); // auto, auto_ai, manual
				mg42 cleartargetentity();
				mg42.player_target = false;
				tempmodel.targent = tempmodel;
				tempmodel.origin = (0,0,0);
			}
			
			wait (0.2);			
		}
	}
	*/
		
	/*	
	
		if (gettime() > mg42timer)
		{
			// MG42 has given the player enough time to reach a safe spot.
			if (isdefined (level.player_covertrigger))
			{
			// Player is safe so shoot in front of him.
				println ("** player is in cover");
				shoot_timer = gettime() + 1500 + randomfloat (1000);
				while (shoot_timer > gettime())
				{
					if (!isalive (self))
						return;
					if (isdefined (level.player_covertrigger))
					{
						target = getentarray (level.player_covertrigger.target, "targetname");
						target = target[randomint(target.size)];
						targ_org.origin = target.origin + 
							(randomfloat (30) - 15, randomfloat (30) - 15, randomfloat (30) - 45);
						mg42 settargetentity(targ_org);
						tempmodel.targent = targ_org;
						wait (randomfloat (1));
					}
					else
						break;
				}
				mg42timer = gettime() + 750 + randomfloat (200);
			}
			else
			{
			// Play is not safe, shoot player.
				println ("** player is NOT in cover");
//				mg42 settargetentity(level.player);
				mg42.player_target = true;
				mg42 settargetentity(tempmodel);
				tempmodel.targent = level.player;
				wait (1);
			}
		}
		else
		{
			// Player is hiding, shoot some friendlies instead.
			if (mg42.player_target)
			{
				println ("** too soon to shoot player");
				mg42 cleartargetentity();
				mg42.player_target = false;
				tempmodel.targent = tempmodel;
				tempmodel.origin = (0,0,0);
			}
		}
				
		wait (1);
			
		println ("time is ", gettime(), " and mg42timer is ", mg42timer);
	}
	*/
	
	/*		
	org = spawn ("script_origin", level.player getorigin());
	while (isalive (self))
	{
		org.origin = level.player getorigin();
		mg42 settargetentity(org);
		
//		println ("MG42 firing at ", org.origin);
		mg42 notify ("startfiring");
		wait 3;
		mg42 notify ("stopfiring");
	}
*/

move_use_turret(mg42, aitype, target)
{
	self setgoalpos (mg42.org);
	self.goalradius = level.magic_distance;
	self waittill ("goal");
	if (isdefined(aitype) && aitype == "auto_ai")
	{
		mg42 setmode("auto_ai");
		if (isdefined(target))
			mg42 settargetentity(target);
		else
			mg42 cleartargetentity();
	}
	self useturret(mg42); // dude should be near the mg42
}

temp_think(mg42, targ)
{
	if (getcvar("mg42") == "off")
		return;

	self.targent = self;
	while (1)
	{
/*	
		if (self.targent == level.player)
			self.origin = level.player getorigin() + (0,0,40);
		else
			self.origin = self.targent.origin;
*/
		self.origin = targ.origin;		
		line (self.origin, mg42.origin, (0.2, 0.5, 0.8), 0.5);			
		wait (0.1);
	}
}

vectorMultiply (vec, dif)
{
	vec = (vec[0] * dif, vec[1] * dif, vec[2] * dif);
	return vec;
}

// This is a thread that runs for each turret managing AI users of the turret
turret_think(node)
{
	turret = getent(node.auto_mg42_target, "targetname");
	mintime = 0.5;
	if (isdefined (turret.script_turret_reuse_min))
		mintime = turret.script_turret_reuse_min;
	maxtime = 2;
	if (isdefined (turret.script_turret_reuse_max))
		mintime = turret.script_turret_reuse_max;
	assert (maxtime >= mintime);
	for(;;)
	{
		turret waittill ("turret_deactivate");
		wait (mintime + randomfloat(maxtime - mintime)); // Wait for a bit before calling the next AI over.
		while( !(isturretactive(turret)) )
		{
			turret_find_user(node, turret);
			wait 1.0;
		}
	}
}

turret_find_user(node, turret)
{
	ai = getaiarray();	
	for(i=0;i<ai.size;i++)
	{
		if ( ai[i] isingoal(node.origin) && ai[i] canuseturret(turret) )
		{
			savekeepclaimed = ai[i].keepClaimedNodeInGoal;
			ai[i].keepClaimedNodeInGoal = false;
			if ( !(ai[i] usecovernode(node)) )
			{
				ai[i].keepClaimedNodeInGoal = savekeepclaimed;
			}
		}
	}
}

setDifficulty()
{
	init_mg42settings();
	
	mg42s = getEntArray( "misc_turret", "classname" );
	
	difficulty = getdifficulty();
	
	for ( index = 0; index < mg42s.size; index++ )
	{
		if ( isdefined( mg42s[index].script_skilloverride ) )
		{
			switch( mg42s[index].script_skilloverride )
			{
				case "easy":
					difficulty = "easy";
					break;
				case "medium":
					difficulty = "medium";
					break;
				case "hard":
					difficulty = "hard";
					break;
				case "fu":
					difficulty = "fu";
					break;
				default:
					continue;
			}
		}
		mg42_setdifficulty (mg42s[index],difficulty);
	}
}

mg42_setdifficulty (mg42,difficulty)
{
		mg42.convergenceTime = level.mg42settings[difficulty]["convergenceTime"];
		mg42.suppressionTime = level.mg42settings[difficulty]["suppressionTime"];
		mg42.accuracy = level.mg42settings[difficulty]["accuracy"];
		mg42.aiSpread = level.mg42settings[difficulty]["aiSpread"];
		mg42.playerSpread = level.mg42settings[difficulty]["playerSpread"];	
}


mg42_target_drones(nonai,team,fakeowner)
{
	if(!isdefined(fakeowner))
		fakeowner = false;
	self endon ("death");
	self.dronefailed = false;
	if(!isdefined(self.script_fireondrones))
		self.script_fireondrones = false;
	if(!isdefined(nonai))
		nonai = false;
	self setmode("manual_ai");
	difficulty = getdifficulty();
	if(!isdefined(level.drones))
		waitfornewdrone = true;
	else
		waitfornewdrone = false;
	while(1)
	{
		if(fakeowner && !isdefined(self.fakeowner))
		{
			self setmode("manual");
			while(!isdefined(self.fakeowner))
				wait .2;
			
		}
		else if(nonai)
			self setmode("auto_nonai");
		else
			self setmode("auto_ai");
		
		if(waitfornewdrone)
			level waittill ("new_drone");

		if(!isdefined(self.oldconvergencetime))
			self.oldconvergencetime = self.convergencetime;
		self.convergencetime = 2;

		if(!nonai)
		{
			turretowner = self getturretowner();
			if(!isalive(turretowner) || turretowner == level.player)
			{
				wait .05;
				continue;
			}
			else
				team = turretowner.team;
		}
		else
		{
			if(fakeowner && !isdefined(self.fakeowner))
			{
				wait .05;
				continue;
			}
			assert(isdefined(team));
			turretowner = undefined;
		}
		if(team == "allies")
			targetteam = "axis";
		else
			targetteam = "allies";

		while(level.drones[targetteam].lastindex)
		{
			//self gettagangles ("tag_flash")
			target = get_bestdrone(targetteam);
			if(!isdefined(self.script_fireondrones) || !self.script_fireondrones)
			{
				wait .2;
				break;
			}
			if(!isdefined(target))
			{
				wait .2;
				break;
			}
			if(nonai)	
				self setmode("manual");
			else
				self setmode("manual_ai");
				
			thread drone_fail(target,3);
			if(!self.dronefailed)
			{
				self settargetentity(target.turrettarget);
				self shootturret();
				self startfiring();
			}
			else
			{
				self.dronefailed = false;
				wait .05;
				continue;
				
			}
			target maps\_utility::waittill_any ("death","drone_mg42_fail");
			waittillframeend;
			if(!nonai && !(isdefined(self getturretowner()) && self getturretowner() == turretowner))
				break;
		}
		self.convergencetime = self.oldconvergencetime;
		self.oldconvergencetime = undefined;
		self cleartargetentity();
		self stopfiring();
		if(level.drones[targetteam].lastindex)
			waitfornewdrone = false;
		else
			waitfornewdrone = true;
	}
}

drone_fail(drone,time)
{
	self endon ("death");
	drone endon ("death");
	timer=gettime()+(time*1000);
	while(timer > gettime())
	{
		turrettarget = self getturrettarget();
//		bullettracepassed(<start>, <end>, <hit characters>, <ignore entity>)
		if(!sighttracepassed(self gettagorigin("tag_flash"),drone.origin+(0,0,40),0,drone))
		{
			self.dronefailed = true;
			wait .2;
			break;
		}
		else if(isdefined(turrettarget) && distance(turrettarget.origin,self.origin)<distance(self.origin,drone.origin))
		{
			self.dronefailed = true;
			wait .1;
			break;	
		}
		wait .1;
	}
//	maps\_utility::structarray_swaptolast(level.drones[drone.team],drone);
	maps\_utility::structarray_shuffle(level.drones[drone.team],1);
	drone notify ("drone_mg42_fail");
}

get_bestdrone(team)
{
	prof_begin("drone_mg42");
//	dotvalue = .88;
//	dist = 9999999;
	if (level.drones[team].lastindex < 1)
		return;
	ent = undefined;
	dotforward = anglestoforward(self.angles);
	for (i=0;i<level.drones[team].lastindex;i++)
	{
		angles = vectortoangles(level.drones[team].array[i].origin - self.origin);
		forward = anglestoforward(angles);
		if(vectordot(dotforward,forward) < .88)
			continue;
//		if(!sighttracepassed(level.drones[team].array[i].origin,self.origin+(0,0,10),0,level.drones[team].array[i]))
//			continue;
//		newdist = distance(level.drones[team].array[i].origin, self.origin);
//		if (newdist >= dist)
//			continue;
//		dist = newdist;
		ent = level.drones[team].array[i];
		break;
	}
	aitarget = self getturrettarget();
	if(isdefined(ent) && isdefined(aitarget) && distance(self.origin,aitarget.origin)<distance(self.origin,ent.origin))
		ent = undefined;  // shoot at ai if they are closer
	prof_end("drone_mg42");
	return ent;
}