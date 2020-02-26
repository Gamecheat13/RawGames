#include maps\_utility;
#include common_scripts\utility;
#using_animtree("generic_human");

init_mgTurretsettings()
{
	level.mgTurretSettings["Civilian"]["convergenceTime"] = 2.5;
	level.mgTurretSettings["Civilian"]["suppressionTime"] = 3.0;
	level.mgTurretSettings["Civilian"]["accuracy"] = 0.38;
	level.mgTurretSettings["Civilian"]["aiSpread"] = 2;
	level.mgTurretSettings["Civilian"]["playerSpread"] = 0.5;	

	level.mgTurretSettings["New Recruit"]["convergenceTime"] = 1.5;
	level.mgTurretSettings["New Recruit"]["suppressionTime"] = 3.0;
	level.mgTurretSettings["New Recruit"]["accuracy"] = 0.38;
	level.mgTurretSettings["New Recruit"]["aiSpread"] = 2;
	level.mgTurretSettings["New Recruit"]["playerSpread"] = 0.5;	

	level.mgTurretSettings["Agent"]["convergenceTime"] = .8;
	level.mgTurretSettings["Agent"]["suppressionTime"] = 3.0;
	level.mgTurretSettings["Agent"]["accuracy"] = 0.38;
	level.mgTurretSettings["Agent"]["aiSpread"] = 2;
	level.mgTurretSettings["Agent"]["playerSpread"] = 0.5;	

	level.mgTurretSettings["Double-Oh"]["convergenceTime"] = .4;
	level.mgTurretSettings["Double-Oh"]["suppressionTime"] = 3.0;
	level.mgTurretSettings["Double-Oh"]["accuracy"] = 0.38;
	level.mgTurretSettings["Double-Oh"]["aiSpread"] = 2;
	level.mgTurretSettings["Double-Oh"]["playerSpread"] = 0.5;	
}

main()
{
	if ( getDvar( "mg42" ) == "" )
		setDvar( "mgTurret", "off" );
		
	level.magic_distance = 24;

	turretInfos = getEntArray( "turretInfo", "targetname" );
	for ( index = 0; index < turretInfos.size; index++ )
		turretInfos[index] delete();
}

portable_mg_behavior()
{
	
	
	
	self detach( "weapon_mg42_carry", "tag_origin" );
	self endon( "death" );

	
	self.goalradius = level.default_goalradius;
	if ( isdefined( self.target ) )
	{
		node = getnode( self.target, "targetname" );
		if ( isdefined( node ) )
		{
			if ( isdefined( node.radius ) )
				self.goalradius = node.radius;
				
			self setgoalnode( node );
		}
	}
	
	while( !isdefined( self.node ) )
	{
		
		wait( 0.05 );
	}

	
	
	
	turret_node = undefined;
	if ( isdefined( self.target ) )
	{
		node = getnode( self.target, "targetname" );
		turret_node = node;
	}
	
	
	if ( !isdefined( turret_node ) )
	{
		turret_node = self.node;
	}

	
	if ( !isdefined( turret_node ) )
	{
		return;
	}
	
	if ( turret_node.type != "Turret" )
		return;
	
	taken_nodes = getTakenNodes();
	taken_nodes[ self.node.origin + "" ] = undefined; 

	
	if ( isdefined( taken_nodes[ turret_node.origin + "" ] ) )
		return;

	turret = turret_node.turret;
	
	if ( isdefined( turret.reserved ) )
	{
		assert( turret.reserved != self );
		return;
	}
		
	reserve_turret( turret );
	
	
	if ( turret.isSetup )
	{
		
		leave_gun_and_run_to_new_spot( turret );
	}
	else
	{
		
		run_to_new_spot_and_setup_gun( turret );
	}
		
	maps\_mg_penetration::gunner_think( turret_node.turret );
}




mg42_trigger()
{
	self waittill ("trigger");
	level notify (self.targetname);
	level.mg42_trigger[self.targetname] = true;

	self delete();
}

mgTurret_auto(trigger)
{
	trigger waittill ("trigger");
	ai = getaiarray("axis");
	for (i=0;i<ai.size;i++)
	{
		if ((isdefined (ai[i].script_mg42auto)) && (trigger.script_mg42auto == ai[i].script_mg42auto))
		{
			ai[i] notify ("auto_ai");
			
		}
	}

	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
	if ((isdefined (spawners[i].script_mg42auto)) && (trigger.script_mg42auto == spawners[i].script_mg42auto))
	{
		spawners[i].ai_mode = "auto_ai";
		
	}
		
	maps\_spawner::kill_trigger( trigger );
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

manual_think(mg42) 
{
	org = self.origin;
	self waittill ("auto_ai");
	mg42 notify ("stopfiring");
	mg42 setmode("auto_ai"); 
	mg42 settargetentity(level.player);
	
}

burst_fire_settings(setting)
{
	if (setting == "delay")
		return 0.2;
	else
	if (setting == "delay_range")
		return 0.5;
	else
	if (setting == "burst")
		return 0.5;
	else

		return 1.5;
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



				thread DoShoot();
			}

			duration = mg42_burst + randomfloat(mg42_burst_range);

			
			thread TurretTimer(duration);

			self waittill("turretstatechange"); 

			duration = mg42_delay + randomfloat(mg42_delay_range);
			

			pauseUntilTime = gettime() + int(duration * 1000);
		}
		else
		{
			if (turretState != "aim")
			{
				turretState = "aim";


			}
			
			
			thread TurretTimer(duration);

			self waittill("turretstatechange"); 
		}
	}
}

DoShoot()
{
	self endon("death");
	self endon("turretstatechange"); 

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

	self endon("turretstatechange"); 

	

	wait duration;
	if (isdefined(self))
		self notify("turretstatechange");

	
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

mg42_firing( mg42 )
{
	self notify( "stop_using_built_in_burst_fire" );
	self endon( "stop_using_built_in_burst_fire" );

	mg42 stopfiring();
	
	while (1)
	{
		mg42 waittill ("startfiring");
		self thread burst_fire( mg42 );
		mg42 startfiring();

		mg42 waittill ("stopfiring");
		mg42 stopfiring();
	}
}


burst_fire( mg42, manual_target )
{
	mg42 endon ("stopfiring");
	self endon( "stop_using_built_in_burst_fire" );


	if (isdefined (mg42.script_delay_min))
		mg42_delay = mg42.script_delay_min;
	else
		mg42_delay = maps\_mgturret::burst_fire_settings ("delay");

	if (isdefined (mg42.script_delay_max)) 
		mg42_delay_range = mg42.script_delay_max - mg42_delay;
	else
		mg42_delay_range = maps\_mgturret::burst_fire_settings ("delay_range");

	if (isdefined (mg42.script_burst_min))
		mg42_burst = mg42.script_burst_min;
	else
		mg42_burst = maps\_mgturret::burst_fire_settings ("burst");

	if (isdefined (mg42.script_burst_max)) 
		mg42_burst_range = mg42.script_burst_max - mg42_burst;
	else
		mg42_burst_range = maps\_mgturret::burst_fire_settings ("burst_range");

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



_spawner_mg42_think ()
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
			ai = maps\_utility::get_closest_ai_exclude (node.origin, undefined, excluders);
		else
			ai = maps\_utility::get_closest_ai (node.origin, undefined);
		excluders = undefined;

		if (isdefined (ai))
		{
			ai notify ("stop_going_to_node");
			ai thread maps\_spawner::go_to_node (node);
			ai waittill ("death");
		}
		else
			self waittill ("get new user");
	}
}

mg42_think()
{		
	if (!isdefined (self.ai_mode))
		self.ai_mode = "manual_ai";
		
	node = getnode(self.target, "targetname");
	if (!isdefined (node))
	{
		
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
		


		mg42_gunner thread mg42_gunner_think (mg42, trigger, self.ai_mode);
		mg42_gunner thread mg42_firing(mg42);
		
		mg42_gunner waittill ("death");

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
			self move_use_turret (mg42, "auto_ai"); 
			self waittill ("manual_ai");
		}
	}
	else
	{
		while (1)
		{
			self move_use_turret (mg42, "auto_ai", level.player); 
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
	

	mg42 setmode("auto_ai"); 
	mg42 cleartargetentity();
	targ_org = spawn ("script_origin", (0,0,0));

	tempmodel = spawn ("script_model", (0, 0, 0));
	tempmodel.scale = 3;
	if (getdvar("mg42") != "off")
	tempmodel setmodel ("temp");
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
		mg42 setmode("manual_ai"); 
		mg42 settargetentity(targ_org);
		mg42 notify ("startfiring");
		 
		mindist = 15;
		wait_time = 0.08; 
		dif = 0.05; 

		targ_org.origin = targets[randomint (targets.size)].origin;

		shoot_timer = 0;

			
		while (!isdefined (level.player_covertrigger))
		{
			current_org = targ_org.origin;
			if (distance (current_org, targets[self.gun_targ].origin) > mindist)
			{
				temp_vec = vectornormalize (targets[self.gun_targ].origin - current_org);
				temp_vec = vectorScale (temp_vec, mindist);
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
				targ_org.origin = vector_multiply (current_org, 1.0-i) + 
					vector_multiply (level.player getorigin() + stance_num(), i);

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
					temp_vec = vectorScale (temp_vec, mindist);
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
			
			self move_use_turret (mg42);
			while (!isdefined (level.player_covertrigger))
			{
				if (!mg42.player_target)
				{
					mg42 settargetentity(level.player);
					mg42.player_target = true;
	
					tempmodel.targent = level.player;
				}
				wait (0.2);
			}
			
			
			mg42 setmode("manual_ai"); 
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

			
			self move_use_turret (mg42);
			if (mg42.player_target)
			{
				mg42 setmode("auto_ai"); 
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
			
		}
	}
}	



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
	self useturret(mg42); 
}

temp_think(mg42, targ)
{
	if (getdvar("mg42") == "off")
		return;

	self.targent = self;
	while (1)
	{
		self.origin = targ.origin;		
		line (self.origin, mg42.origin, (0.2, 0.5, 0.8), 0.5);			
		wait (0.1);
	}
}


turret_think( node )
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
		turret waittill( "turret_deactivate" );
		wait (mintime + randomfloat(maxtime - mintime)); 
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
	init_mgTurretsettings();
	
	mg42s = getEntArray( "misc_turret", "classname" );
	
	difficulty = getdifficulty();
	
	for ( index = 0; index < mg42s.size; index++ )
	{
		if ( isdefined( mg42s[index].script_skilloverride ) )
		{
			switch( mg42s[index].script_skilloverride )
			{
				case "Civilian":
					difficulty = "Civilian";
					break;
				case "New Recruit":
					difficulty = "New Recruit";
					break;
				case "Agent":
					difficulty = "Agent";
					break;
				case "Double-Oh":
					difficulty = "Double-Oh";
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
		mg42.convergenceTime = level.mgTurretSettings[difficulty]["convergenceTime"];
		mg42.suppressionTime = level.mgTurretSettings[difficulty]["suppressionTime"];
		mg42.accuracy = level.mgTurretSettings[difficulty]["accuracy"];
		mg42.aiSpread = level.mgTurretSettings[difficulty]["aiSpread"];
		mg42.playerSpread = level.mgTurretSettings[difficulty]["playerSpread"];	
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
			target waittill_any ("death","drone_mg42_fail");
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
























}

get_bestdrone(team)
{
	prof_begin("drone_mg42");


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






		ent = level.drones[team].array[i];
		break;
	}
	aitarget = self getturrettarget();
	if(isdefined(ent) && isdefined(aitarget) && distance(self.origin,aitarget.origin)<distance(self.origin,ent.origin))
		ent = undefined;  
	prof_end("drone_mg42");
	return ent;
}


saw_mgTurretLink( nodes )
{
	possible_turrets = getEntArray( "misc_turret", "classname" );
	turrets = [];
	for ( i=0; i < possible_turrets.size; i++ )
	{
		if ( isDefined( possible_turrets[ i ].targetname ) )
			continue;
			
		if ( isdefined( possible_turrets[ i ].isvehicleattached ) )
		{
			assertEx( possible_turrets[ i ].isvehicleattached != 0, "Setting must be either true or undefined" );
			continue;
		}

		turrets[ possible_turrets[ i ].origin + "" ] = possible_turrets[ i ];
	}

	
	if ( !turrets.size )
		return;
		
	for ( nodeIndex = 0; nodeIndex < nodes.size; nodeIndex++)
	{
		node = nodes[ nodeIndex ];
		if ( node.type == "Path" )
			continue;
		if ( node.type == "Begin" )
			continue;
		if ( node.type == "End" )
			continue;

	    nodeForward = anglesToForward( ( 0, node.angles[ 1 ], 0 ) );

		keys = getArrayKeys( turrets );
		for ( i=0; i < keys.size; i++ )
		{
			turret = turrets[ keys[ i ] ];
			
			if ( distance( node.origin, turret.origin ) > 50 )
				continue;
		
		    turretForward = anglesToForward( ( 0, turret.angles[ 1 ], 0 ) );
		    
			dot = vectorDot( nodeForward, turretForward );
			if ( dot < 0.9 )
				continue;
	
			node.turretInfo = spawn( "script_origin", turret.origin );
			node.turretInfo.angles = turret.angles;
			node.turretInfo.node = node;


			turrets[ keys[ i ] ] = undefined;
			turret delete();
		}
	}

	keys = getArrayKeys( turrets );
	for ( i=0; i < keys.size; i++ )
	{
		turret = turrets[ keys[ i ] ];
		assertMsg( "ERROR: turret at " + turret.origin + " could not link to any node!" );
	}
}


auto_mgTurretLink( nodes )
{
	
	possible_turrets = getEntArray( "misc_turret", "classname" );
	turrets = [];
	for ( i=0; i < possible_turrets.size; i++ )
	{
		if ( !isDefined( possible_turrets[ i ].targetname ) || tolower( possible_turrets[ i ].targetname ) != "auto_mgturret" )
			continue;
		
		if ( !isdefined( possible_turrets[ i ].export ) )
			continue;
		if ( !isdefined( possible_turrets[ i ].script_dont_link_turret ) )
			turrets[ possible_turrets[ i ].origin + "" ] = possible_turrets[ i ];
	}

	
	if ( !turrets.size )
		return;
		
	for ( nodeIndex = 0; nodeIndex < nodes.size; nodeIndex++)
	{
		node = nodes[ nodeIndex ];
		if ( node.type == "Path" )
			continue;
		if ( node.type == "Begin" )
			continue;
		if ( node.type == "End" )
			continue;



	    nodeForward = anglesToForward( ( 0, node.angles[ 1 ], 0 ) );

		keys = getArrayKeys( turrets );
		for ( i=0; i < keys.size; i++ )
		{
			turret = turrets[ keys[ i ] ];
			if ( distance( node.origin, turret.origin ) > 70 )
				continue;
		
		    turretForward = anglesToForward( ( 0, turret.angles[ 1 ], 0 ) );
		    
			dot = vectorDot( nodeForward, turretForward );
			if ( dot < 0.9 )
				continue;
	
			node.turret = turret;
			turret.node = node;
			turret.isSetup = true;
			assertEx( isdefined( turret.export ), "Turret at " + turret.origin + " does not have a .export value but is near a cover node. If you do not want them to link, use .script_dont_link_turret." );

			
			
			turrets[ keys[ i ] ] = undefined;
		}
		

	}
	
	/#
	
	keys = getArrayKeys( turrets );
	if ( keys.size )
	{
		
		
		for ( i=0; i < keys.size; i++ )
		{
			println( keys[ i ] );
		}
		assertEx( 0, "Turrets failed to be linked to node_turrets, see list above." );
	}
	#/
	
		

	
	nodes = undefined;
}


save_turret_sharing_info()
{
	
	self.shared_turrets = [];
	self.shared_turrets[ "connected" ] = [];
	self.shared_turrets[ "ambush" ] = [];
	
	if ( !isdefined( self.export ) )
	{
		assertEx( !isdefined( self.script_turret_share ), "Turret at " + self.origin + " has script_turret_share but has no .export value, so script_turret_share won't have any effect." );
		assertEx( !isdefined( self.script_turret_ambush ), "Turret at " + self.origin + " has script_turret_ambush but has no .export value, so script_turret_ambush won't have any effect." );
		return;
	}
		
	level.shared_portable_turrets[ self.export ] = self;

	if ( isdefined( self.script_turret_share ) )
	{
		
		
		
		strings = strtok( self.script_turret_share, " ");
		
		for ( i=0; i < strings.size; i++ )
		{
			self.shared_turrets[ "connected" ][ strings[ i ] ] = true;
		}
	}

	if ( isdefined( self.script_turret_ambush ) )
	{
		
		
		
		strings = strtok( self.script_turret_ambush, " ");
		
		for ( i=0; i < strings.size; i++ )
		{
			self.shared_turrets[ "ambush" ][ strings[ i ] ] = true;
		}
	}
}



restoreDefaultPitch()
{
	self notify( "gun_placed_again" );
	self endon( "gun_placed_again" );
	self waittill ("restore_default_drop_pitch");
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
	turret.origin = self gettagorigin ( level.portable_mg_gun_tag );
	turret.angles = self gettagangles ( level.portable_mg_gun_tag );
	turret setmodel (self.turretModel);
	forward = anglestoforward(self.angles);
	forward = vectorScale (forward, 100);
	turret moveGravity (forward, 0.5);
	self detach(self.turretModel,  level.portable_mg_gun_tag );
	self.turretmodel = undefined;
	wait (0.7);
	turret delete();
}


turretDeathDetacher()
{
	self endon ("kill_turret_detach_thread");
	self endon ("dropped_gun");
	self waittill ("death");
	if (!isdefined(self))
		return; 
	dropTurret();
}

turretDetacher()
{
	self endon ("death");
	self endon ("kill_turret_detach_thread");
	
	self waittill ("dropped_gun");
	self detach(self.turretModel,  level.portable_mg_gun_tag );
}

restoreDefaults()
{

	self.run_noncombatanim = undefined;
	self.run_combatanim = undefined;
	self set_all_exceptions( animscripts\init::empty );
}

restorePitch()
{
	self waittill( "turret_deactivate" );
	self restoredefaultdroppitch();
}

update_enemy_target_pos_while_running( ent )
{
	self endon( "death" );
	self endon( "end_mg_behavior" );
	self endon( "stop_updating_enemy_target_pos" );

	for ( ;; )
	{
		self waittill( "saw_enemy" );		
		ent.origin = self.last_enemy_sighting_position;
	}
}

move_target_pos_to_new_turrets_visibility( ent, new_spot )
{
	
	
	
	
	
	
	
	
	
	
	self endon( "death" );
	self endon( "end_mg_behavior" );
	self endon( "stop_updating_enemy_target_pos" );

	old_turret_pos = self.turret.origin + ( 0, 0, 16 ); 
	dest_pos = new_spot.origin + ( 0, 0, 16 );
	
	for ( ;; )
	{
		wait ( 0.05 ); 








		
		
		angles = vectortoangles( old_turret_pos - ent.origin );
		forward = anglestoforward( angles );
		forward = vectorscale( forward, 8 );
		
		ent.origin = ent.origin + forward;
	}
}

record_bread_crumbs_for_ambush( ent )
{
	self endon( "death" );
	self endon( "end_mg_behavior" );
	self endon( "stop_updating_enemy_target_pos" );
	
	ent.bread_crumbs = [];
	for ( ;; )
	{

		ent.bread_crumbs[ ent.bread_crumbs.size ] = self.origin + ( 0, 0, 50 );
		wait( 0.35 );	
	}
}

aim_turret_at_ambush_point_or_visible_enemy( turret, ent )
{
	if ( !isalive( self.current_enemy ) && self canSee( self.current_enemy ) )
	{
		
		ent.origin = self.last_enemy_sighting_position;
		return;
	}
	
	
	forward = anglestoforward( turret.angles );
	
	
	
	
	for ( i = ent.bread_crumbs.size - 3; i >= 0; i-- )
	{
		
		crumb = ent.bread_crumbs[ i ];
		normal = vectorNormalize( crumb - turret.origin );
		dot = vectorDot( forward, normal );
		if ( dot < 0.75 )
			continue;

		ent.origin = crumb;
			
		





		

		break;
	}
}

find_a_new_turret_spot( ent )
{
	
	array = get_portable_mg_spot( ent );
	new_spot = array[ "spot" ];
	connection_type = array[ "type" ];
	
	if ( !isdefined( new_spot ) )
		return;

	reserve_turret( new_spot );
		
	
	thread update_enemy_target_pos_while_running( ent );
	thread move_target_pos_to_new_turrets_visibility( ent, new_spot );
	
	if ( connection_type == "ambush" )
	{
		thread record_bread_crumbs_for_ambush( ent );
	}

	if ( new_spot.isSetup )
	{
		leave_gun_and_run_to_new_spot( new_spot );
	}
	else
	{
		pickup_gun( new_spot );
		run_to_new_spot_and_setup_gun( new_spot );
	}
		
	self notify( "stop_updating_enemy_target_pos" );

	if ( connection_type == "ambush" )
	{
		aim_turret_at_ambush_point_or_visible_enemy( new_spot, ent );
	}


	
	new_spot setTargetEntity( ent );
}

snap_lock_turret_onto_target( turret )
{
	
	turret setmode( "manual" );
	wait( 0.5 );
	turret setmode( "manual_ai" );
}

leave_gun_and_run_to_new_spot( spot )
{
	assert( spot.reserved == self );
	
	

	self stopuseturret();
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );

	
	setup_anim = get_turret_setup_anim( spot );
	org = getStartOrigin ( spot.origin, spot.angles, setup_anim );
	self setruntopos( org );
	assertEx( distance( org, self.goalpos ) < self.goalradius, "Tried to set the run pos outside the goalradius" );
	
	self waittill( "runto_arrived" );
	
	use_the_turret( spot );
}

pickup_gun( spot )
{
	
	
	
	self stopuseturret();
	self.turret hide_turret();
}

get_turret_setup_anim( turret )
{
	spot_types = [];
	spot_types[ "saw_bipod_stand" ] =			level.mg_animmg[ "bipod_stand_setup" ];
	spot_types[ "saw_bipod_crouch" ] =			level.mg_animmg[ "bipod_crouch_setup" ];
	spot_types[ "saw_bipod_prone" ] =			level.mg_animmg[ "bipod_prone_setup" ];

	return spot_types[ turret.weaponinfo ];
}

run_to_new_spot_and_setup_gun( spot )
{
	assert( spot.reserved == self );
	
	oldhealth = self.health;
	spot endon( "turret_deactivate" );
	
	self.mg42 = spot; 
	self endon( "death" );
	self endon( "dropped_gun" );

	setup_anim = get_turret_setup_anim( spot );
	
	self.turretModel = "weapon_mg42_carry";
	
	
	self notify( "kill_get_gun_back_on_killanimscript_thread" );
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
	if (self.team == "axis")
		self.health = 1;






	
	self attach(self.turretModel, level.portable_mg_gun_tag);
	thread turretDeathDetacher();

	
	org = getStartOrigin ( spot.origin, spot.angles, setup_anim );
	self setruntopos( org );
	assertEx( distance( org, self.goalpos ) < self.goalradius, "Tried to set the run pos outside the goalradius" );
	
	wait (0.05); 

	clear_exception( "move" );
	set_exception( "cover_crouch", ::hold_indefintely );
	
	while ( distance( self.origin, org ) > 16 )
	{
		self setruntopos( org );
		wait ( 0.05 );
	}

		
	self notify ("kill_turret_detach_thread");
	
	if (self.team == "axis")
		self.health = oldhealth;

	
	if ( soundexists( "weapon_setup" ) )
		thread play_sound_in_space( "weapon_setup" );
		
	self animscripted( "setup_done", spot.origin, spot.angles, setup_anim );
	
	restoreDefaults(); 
	
	self waittillmatch( "setup_done", "end" );
	spot notify( "restore_default_drop_pitch" );
	spot show_turret();
	
	self animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );

	use_the_turret( spot );
	self detach( self.turretModel, level.portable_mg_gun_tag );
	self set_all_exceptions( animscripts\init::empty );

	self notify( "bcs_portable_turret_setup" );
}

move_to_run_pos()
{
	self setruntopos( self.runpos );
}

hold_indefintely()
{
	self endon( "killanimscript" );
	self waittill( "death" );
}

using_a_turret()
{
	if ( !isdefined( self.turret ) )
		return false;
		
	return self.turret.owner == self;
}
	

turret_user_moves()
{
	
	if ( !using_a_turret() )
	{
		clear_exception( "move" );
		return;
	}

	array = find_connected_turrets( "connected" );
	new_spots = array[ "spots" ];
	
	if ( !new_spots.size )
	{
		
		
		clear_exception( "move" );
		return;
	}
	
	
	turret_node = self.node;

	
	
	if ( !isdefined( turret_node ) || !is_in_array( new_spots, turret_node ) )
	{
		taken_nodes = getTakenNodes();
		for ( i=0; i < new_spots.size; i++ )
		{
			turret_node = random( new_spots );
	
			
			
			if ( isdefined( taken_nodes[ turret_node.origin + "" ] ) )
				return;
		}
	}
	
	turret = turret_node.turret;
	
	if ( isdefined( turret.reserved ) )
	{
		assert( turret.reserved != self );
		return;
	}
		
	reserve_turret( turret );
	
	
	if ( turret.isSetup )
	{
		
		leave_gun_and_run_to_new_spot( turret );
	}
	else
	{
		
		run_to_new_spot_and_setup_gun( turret );
	}
		
	maps\_mg_penetration::gunner_think( turret_node.turret );
}

use_the_turret( spot )
{
	turretWasUsed = self useturret( spot );

	if ( turretWasUsed )
	{	
		set_exception( "move", ::turret_user_moves ); 

		self.turret = spot;
		self thread mg42_firing( spot ); 
		spot setmode( "manual_ai" );
		spot thread restorePitch();
		self.turret = spot;
		spot.owner = self;



		return true;
	}
	else
	{
		spot restoredefaultdroppitch();
		return false;
	}

}

get_portable_mg_spot( ent )
{
	find_spot_funcs = [];
	find_spot_funcs[ find_spot_funcs.size ] = ::find_different_way_to_attack_last_seen_position;
	find_spot_funcs[ find_spot_funcs.size ] = ::find_good_ambush_spot;

	find_spot_funcs = array_randomize( find_spot_funcs );
	
	for ( i=0; i < find_spot_funcs.size; i++ )
	{
		array = [[ find_spot_funcs[ i ] ]]( ent );
		
		if ( !isdefined( array[ "spots" ] ) )
			continue;
		
		array[ "spot" ] = random( array[ "spots" ] );
		return array;
	}
}

getTakenNodes()
{
	
	array = [];
	ai = getaiarray();
	
	for ( i=0; i < ai.size; i++ )
	{
		if ( !isdefined( ai[ i ].node ) )
			continue;
		
		array[ ai[ i ].node.origin + "" ] = true;
	}
	
	return array;
}

find_connected_turrets( connection_type )
{
	spots = level.shared_portable_turrets;	
	usable_spots = [];
	
	spot_exports = getArrayKeys( spots );
	
	taken_nodes = getTakenNodes();
	taken_nodes[ self.node.origin + "" ] = undefined;
	
	
	for ( i=0; i < spot_exports.size; i++ )
	{
		export = spot_exports[ i ];
		if ( spots[ export ] == self.turret )
			continue;
			
		
		keys = getArrayKeys( self.turret.shared_turrets[ connection_type ] );	
		for ( p=0; p < keys.size; p++ )
		{
			
			
			
			if ( spots[ export ].export + "" != keys[ p ] )
				continue;
				
			
			if ( isdefined( spots[ export ].reserved ) )
				continue;
				
			
			if ( isdefined( taken_nodes[ spots[ export ].node.origin + "" ] ) )
				continue;
				
			
			if ( distance( self.goalpos, spots[ export ].origin ) > self.goalradius )
				continue;
				
			
			usable_spots[ usable_spots.size ] = spots[ export ];
		}
	}

	array = [];
	
	array[ "type" ] = connection_type;
	array[ "spots" ] = usable_spots;
	return array;	
}

find_good_ambush_spot( ent )
{
	return find_connected_turrets( "ambush" );
}

find_different_way_to_attack_last_seen_position( ent )
{
	array = find_connected_turrets( "connected" );
	usable_spots = array[ "spots" ];
	
	if ( !usable_spots.size )
		return;

	good_spot = [];
	
	
	for ( i=0; i < usable_spots.size; i++ )
	{
			
		if ( !within_fov( usable_spots[ i ].origin, usable_spots[ i ].angles, ent.origin, 0.75 ) )
			continue;
		
		
			


	
		good_spot[ good_spot.size ] = usable_spots[ i ];
	}
	
	array[ "spots" ] = good_spot;
	return array;
}

portable_mg_spot()
{
	save_turret_sharing_info();	
	
	turret_preplaced = 1;
	self.isSetup = true;
	assert( !isdefined( self.reserved ) );
	self.reserved = undefined;
	if(isdefined(self.isvehicleattached))
		return;	
	if ( self.spawnflags & turret_preplaced )
		return;
		
	
	hide_turret();
	
}


hide_turret()
{
	assert( self.isSetup );
	self notify( "stop_checking_for_flanking" );
	self.isSetup = false;
	self hide();
	self.solid = false;
	self maketurretunusable();
	self setdefaultdroppitch(0);
	self thread restoreDefaultPitch();
}

show_turret()
{
	self show();
	self.solid = true;
	self maketurretusable();
	assert( !self.isSetup );
	self.isSetup = true;
	thread stop_mg_behavior_if_flanked();
}

stop_mg_behavior_if_flanked()
{
	self endon( "stop_checking_for_flanking" );
	
	self waittill( "turret_deactivate" );
	if ( isalive( self.owner ) )
		self.owner notify( "end_mg_behavior" );
}

turret_is_mine( turret )
{
	owner = turret getTurretOwner();
	if ( !isdefined( owner ) )
		return false;
	
	return owner == self;
}

end_turret_reservation( turret )
{
	waittill_turret_is_released( turret );
	turret.reserved = undefined;
}

waittill_turret_is_released( turret )
{
	turret endon( "turret_deactivate" );
	self endon( "death" );
	self waittill( "end_mg_behavior" );
}
	
reserve_turret( turret )
{
	turret.reserved = self;
	thread end_turret_reservation( turret );
}
