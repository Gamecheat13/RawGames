#include maps\_utility;
#include common_scripts\utility;















main()
{
	
	
	
	
	

	
	createthreatbiasgroup("allies");
	createthreatbiasgroup("axis");

	level.player setthreatbiasgroup("allies");
	

	

	

	level._nextcoverprint = 0;
	level._ai_group = [];
	level.current_spawn_num = 0;
	level.killedaxis = 0;
	level.ffpoints = 0;
	level.missionfailed = false;
	level.gather_delay = [];
	level.smoke_thrown = [];
	level.smoke_thrower = [];

	level.next_health_drop_time = 0;
	level.guys_to_die_before_next_health_drop = randomintrange( 1, 4 );
	level.default_goalradius = 24;
	level.default_goalheight = 80;
	level.portable_mg_gun_tag = "R_UpperArm"; 
	level.mg42_hide_distance = 1024;

	if (!isdefined (level.maxFriendlies))
		level.maxFriendlies = 11;

	level._max_script_health = 0;
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		

		

		ai[i] thread spawn_think ();
		ai[i] thread handleQKRumble ();
	}

	

	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
		spawners[i] thread spawn_prethink();

}

handleQKRumble( )
{
	self thread handleQKGroundhit();
	for (;;)
	{
		self waittillmatch( "anim_notetrack", "qk_rumble");
		level.player PlayRumbleOnEntity("qk_hit");
	}
}

handleQKGroundhit( )
{
	for (;;)
	{
		self waittillmatch( "anim_notetrack", "qk_groundhit");
		level.player PlayRumbleOnEntity("melee_attack_miss");
	}
}


outdoor_think( trigger )
{
	trigger endon( "death" );
	for(;;)
	{
		trigger waittill( "trigger", guy );
		guy thread ignore_triggers( 0.15 );

		guy disable_cqbwalk();
		guy.wantShotgun = false;
	}		
}

indoor_think( trigger )
{
	trigger endon( "death" );
	for(;;)
	{
		trigger waittill( "trigger", guy );
		guy thread ignore_triggers( 0.15 );

		guy enable_cqbwalk();
		guy.wantShotgun = true;
	}		
}

doAutoSpawn(spawner)
{
	spawner endon("death");
	self endon("death");

	for (;;)
	{
		self waittill("trigger");
		if (!spawner.count)
			return;
		if (self.target != spawner.targetname)
			return; 
		if (isdefined(spawner.triggerUnlocked))
			return; 

		guy = spawner spawn_ai();

		spawn_failed(guy);			
		
		
		if (isdefined(self.Wait) && (self.Wait > 0))
			wait(self.Wait);
	}
}

trigger_spawner( trigger )
{
	assertEx( isdefined( trigger.target ), "Triggers with flag TRIGGER_SPAWN must target at least one spawner" );

	trigger endon( "death" );
	trigger waittill( "trigger" );
	spawners = getentarray( trigger.target, "targetname" );

	for ( i=0; i < spawners.size; i++ )
	{
		if (isdefined(spawners[ i ].script_forcespawn))
			spawned = spawners[ i ] stalingradSpawn();
		else
			spawned = spawners[ i ] doSpawn();
	}
}

flood_spawner_scripted( spawners )
{
	assertEX( isDefined( spawners ) && spawners.size, "Script tried to flood spawn without any spawners" );

	maps\_utility::array_thread( spawners, ::flood_spawner_init );
	maps\_utility::array_thread( spawners, ::flood_spawner_think );
}


reincrement_count_if_deleted( spawner )
{
	spawner endon ( "death" );

	self waittill ( "death" );
	if ( !isDefined( self ) )
		spawner.count++;
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


kill_spawner( trigger )
{
	killspawner = trigger.script_killspawner;

	trigger waittill ("trigger");

	spawners = getspawnerarray();
	for ( i = 0 ; i < spawners.size ; i++ )
	{
		if ( ( isdefined ( spawners[ i ].script_killspawner ) ) && ( killspawner == spawners[ i ].script_killspawner ) )
		{
			spawners[ i ] delete();
		}
	}

	kill_trigger ( trigger );
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
	
}




spawn_grenade(origin, team)
{
	
	if (!isdefined(level.grenade_cache) || !isdefined(level.grenade_cache[team]))
	{
		level.grenade_cache_index[team] = 0;
		level.grenade_cache[team] = [];
	}

	index = level.grenade_cache_index[team];
	grenade = level.grenade_cache[team][index];
	if (isdefined(grenade))
		grenade delete();

	
	return undefined;

	grenade = spawn("weapon_fraggrenade", origin);

	level.grenade_cache[team][index] = grenade;

	level.grenade_cache_index[team] = (index + 1) % 16;

	return grenade;
}

waittillDeathOrPainDeath()
{
	self endon ("death");
	self waittill ("pain_death"); 
}

drop_gear()
{
	team = self.team;
	waittillDeathOrPainDeath();

	if (!isdefined (self))
		return;

	if (self.grenadeAmmo <= 0)
		return;

	level.nextGrenadeDrop--;
	if (level.nextGrenadeDrop > 0)
		return;

	level.nextGrenadeDrop = 2 + randomint(2);
	max = 25;
	min = 12;
	

}



dronespawn_setstruct(spawner)
{
	
	struct = spawnstruct();
	guy = spawner stalingradspawn();
	spawner.count ++; 
	size = guy getattachsize();
	struct.attachedmodels = [];
	for(i=0;i<size;i++)
	{
		struct.attachedmodels[i] = guy getattachmodelname(i);
		struct.attachedtags[i] = guy getattachtagname(i);
	}
	struct.model = guy.model;
	guy delete();
	return struct;
}

spawn_prethink()
{
	assert (self != level);
	if (getdvar ("noai") != "off")
	{
		
		self.count = 0;
		return;
	}

	prof_begin("spawn_prethink");

	
	self.active = false;
	if (IsDefined(self.script_flag_true))
	{
		self thread flag_spawn();
	}
	

	if (isdefined (self.script_drone)&& !isdefined(level.dronestruct[self.classname]))
		level.dronestruct[self.classname] = dronespawn_setstruct(self);

	if (isdefined (self.script_aigroup))
	{
		aigroup = self.script_aigroup;
		if (!isdefined(level._ai_group[aigroup]))
			aigroup_create(aigroup);			
		self thread aigroup_spawnerthink( level._ai_group[aigroup] );
	}

	if (isdefined (self.script_delete))
	{
		array_size = 0;
		if (isdefined (level._ai_delete))
			if (isdefined (level._ai_delete[self.script_delete]))
				array_size = level._ai_delete[self.script_delete].size;

		level._ai_delete[self.script_delete][array_size] = self;
	}

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

	

	if ( !isdefined( self.spawn_functions ) )
	{
		self.spawn_functions = [];
	}

	for( ;; )
	{
		prof_begin("spawn_prethink");

		self waittill ("spawned", spawn);

		if ( !isalive( spawn ) )
			continue;
		

		if ( isdefined( level.spawnerCallbackThread ) )
			self thread [[ level.spawnerCallbackThread ]]( spawn );

		


		

		if ( isdefined( self.script_delete ) )
		{
			for (i=0;i<level._ai_delete[self.script_delete].size;i++)
			{
				if (level._ai_delete[self.script_delete][i] != self)
					level._ai_delete[self.script_delete][i] delete();
			}
		}

		spawn.spawn_funcs = self.spawn_functions;

		if ( isdefined ( self.targetname ) )
		{
			spawn thread spawn_think( self.targetname );
			spawn thread handleQKRumble();
		}
		else
		{
			spawn thread spawn_think();
			spawn thread handleQKRumble();
		}
	}
}




flag_spawn()
{
	self endon("death");

	
	tokens = maps\_load::create_flags_and_return_tokens(self.script_flag_true);
	maps\_load::wait_for_flag(tokens);

	if (!self.active)
	{
		if (IsDefined(self.targetname))
		{
			self.targetname = self.targetname + "_active";	
		}

		self.active = true;
		self thread maps\_spawner::flood_spawner_think();
	}
}


spawn_think (targetname)
{
	assert (self != level);
	spawn_think_action (targetname);
	assert (isalive(self));

	if ( isdefined( self.spawn_funcs ) )
	{
		for ( i=0; i < self.spawn_funcs.size; i++ )
		{
			func = self.spawn_funcs[ i ];
			if ( isdefined( func[ "param3" ] ) )
				thread [[ func[ "function" ] ]]( func[ "param1" ], func[ "param2" ], func[ "param3" ] );
			else
				if ( isdefined( func[ "param2" ] ) )
					thread [[ func[ "function" ] ]]( func[ "param1" ], func[ "param2" ] );
				else
					if ( isdefined( func[ "param1" ] ) )
						thread [[ func[ "function" ] ]]( func[ "param1" ] );
					else
						thread [[ func[ "function" ] ]]();
		}

		/#
			self.saved_spawn_functions = self.spawn_funcs;
#/

		self.spawn_funcs = undefined;

		/#
			
			self.spawn_funcs = self.saved_spawn_functions;
		self.saved_spawn_functions = undefined;
#/
	}



	self.finished_spawning = true;
	self notify ("finished spawning");
	assert (isdefined(self.team));
	if (self.team == "allies" && !isdefined (self.script_nofriendlywave))
		self thread friendlydeath_thread();

	
	
	if( self.team == "neutral" )
	{
		self thread maps\_aicivilian::cower();
		self thread maps\_aicivilian::bump();
	}
}


spawn_think_action (targetname)
{
	self thread tanksquish();

	/#
		if (getdebugdvar("debug_misstime") == "start")
			self thread maps\_debug::debugMisstime();

	thread show_bad_path();
#/

	if ( !isdefined( self.ai_number ) )
	{
		set_ai_number();
	}

	
	
	
	self eqoff();
	self maps\_aiPerceptionIndicator::add_ai();;


	if ((isdefined (self.script_moveoverride)) && (self.script_moveoverride == 1))
		override = true;
	else
		override = false;

	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "mgpair" )
	{
		
		thread maps\_mg_penetration::create_mg_team();
	}

	level thread maps\_friendlyfire::friendly_fire_think( self );


	if ( isdefined( self.script_goalvolume ) )
	{
		
		thread set_goal_volume();
	}

	
	if ( isdefined(self.script_threatbiasgroup) )
	{
		
		
		self setthreatbiasgroup( self.script_threatbiasgroup );
	}
	else if (self.team == "allies")
		self setthreatbiasgroup( "allies" );
	else
		self setthreatbiasgroup( "axis" );

	assertEx( self.pathEnemyLookAhead == 0 && self.pathEnemyFightDist == 0, "Tried to change pathenemyFightDist or pathenemyLookAhead on an AI before running spawn_failed on guy with export " + self.export );
	set_default_pathenemy_settings();

	portableMG42guy = issubstr(self.classname, "mgportable") || issubstr(self.classname, "30cal");

	maps\_gameskill::grenadeAwareness();

	if (isdefined (self.script_bcdialog))
		self set_battlechatter(self.script_bcdialog);

	
	if (isdefined(self.script_accuracy))
	{
		self.baseAccuracy = self.script_accuracy;
	}

	self.walkdist = 16;

	if (isdefined(self.script_ignoreme))
		self.ignoreme = true;

	if (isdefined(self.script_sightrange))
		self.maxSightDistSqrd = self.script_sightrange;

	if (self.team != "axis")
	{
		self thread use_for_ammo();

		
		if (isdefined(self.script_followmin))
		{
			self.followmin = self.script_followmin;
		}

		
		if (isdefined(self.script_followmax))
		{
			self.followmax = self.script_followmax;
		}


		
		
		level thread friendly_waittill_death (self);
	}

	if (self.team == "axis" && self.type == "human")
	{
		self thread drop_gear();
		self thread drophealth();
	}


	
	if (isdefined(self.script_favoriteenemy))
	{
		
		if (self.script_favoriteenemy == "player")
		{
			self.favoriteenemy = level.player;
			level.player.targetname = "player";
			
		}
	}

	if (isdefined(self.script_fightdist))
		self.pathenemyfightdist = self.script_fightdist;

	if (isdefined(self.script_maxdist))
		self.pathenemylookahead = self.script_maxdist;	

	
	if (isdefined(self.script_longdeath) && self.script_longdeath == false)
	{
		self.a.disableLongDeath = true;	
		assertEX(self.team != "allies", "Allies can't do long death, so why disable it on the guy at " + self.origin + "?");
	}
	else
	{
		
		
		
		
		
	}

	
	

	
	
	
	
	level thread actor_death( self );

	
	if (isdefined(self.script_grenades))
	{
		self.grenadeAmmo = self.script_grenades;
	}
	else
		self.grenadeAmmo = 3;


	if (isdefined(self.script_flashbangs))
	{
		self.grenadeWeapon = "flash_grenade";
		self.grenadeAmmo = self.script_flashbangs;
	}


	if (isdefined(self.dontdropweapon))
	{
		self.dropweapon = !self.dontdropweapon;
	}

	
	if (isdefined(self.script_pacifist))
	{
		self.pacifist = true;
	}

	
	if ( isdefined(self.script_alert) )
	{
		self LockAlertState( self.script_alert );
	}

	if ( isdefined(self.script_alertmin) )
	{
		self SetAlertStateMin( self.script_alertmin );
	}

	if ( isdefined(self.script_alertmax) )
	{
		self SetAlertStateMax( self.script_alertmax );
	}

	if ( isdefined(self.script_ignoredistraction) )
	{
		self SetIgnoreDistraction( self.script_ignoredistraction );
	}

	level thread zone_alert(self);

	if ( isdefined(self.script_enablesense) )
	{
		self SetEnableSense( self.script_enablesense );
	}

	if ( isdefined(self.script_aibrain) )
	{
		self SetMachine( "brain", self.script_aibrain );
	}

	if ( isdefined(self.script_perfectsense) )
	{
		self SetPerfectSense( self.script_perfectsense );
	}

	
	if ( isdefined(self.script_tetherradius) )
	{
		self SetTetherRadius( self.script_tetherradius );
	}

	if ( isdefined(self.script_engagerule) )
	{
		self SetEngageRule( self.script_engagerule );
	}

	
	if ( isdefined(self.script_propagationdelay) )
	{
		self SetPropagationDelay( self.script_propagationdelay );
	}	

	
	if ( isdefined(self.script_combatrole) )
	{
		self SetCombatRole( self.script_combatrole );
	}
	else
	{
		
		if ( isdefined(self.gdt_combatrole) && self.gdt_combatrole != "" )
		{
			self SetCombatRole( self.gdt_combatrole );
		}
	}

	
	if ( isdefined(self.script_combatrolelocked) )
	{
		self SetCombatRoleLocked( self.script_combatrolelocked );
	}

	
	if ( isdefined(self.script_staggerpainenable) )
	{
		self  SetStaggerPainEnable( self.script_staggerpainenable );		
	}

	
	if ( isdefined(self.script_flashbangpainenable) )
	{
		self  SetFlashBangPainEnable( self.script_flashbangpainenable );		
	}

	
	if ( isdefined(self.script_invalidatenodeatdeath) )
	{
		self  SetInvalidateNodeAtDeath( self.script_invalidatenodeatdeath );		
	}

	
	if ( isdefined(self.script_speed) )
	{
		self SetScriptSpeed( self.script_speed );
	}

	
	if ( isdefined(self.script_enabletraversal) )
	{		 
		self enabletraversal( self.script_enabletraversal );
	}

	
	if ( isdefined(self.script_enablegrenades) )
	{
		self SetCtxParam("Weapon", "EnableGrenades", self.script_enablegrenades);
	}

	
	if (isdefined(self.script_startinghealth))
	{
		self.health = self.script_startinghealth;
	}

	
	if (isdefined(self.script_playerseek))
	{
		self setgoalentity (level.player);
		return;
	}

	
	if (isdefined(self.script_patroller))
	{
		self thread maps\_patrol::patrol();
		return;
	}

	
	if (isdefined(self.script_delayed_playerseek))
	{
		if (!isdefined (self.script_radius))
			self.goalradius = 800;

		self setgoalentity (level.player);

		level thread delayed_player_seek_think(self);

		return;
	}

	if ( portableMG42guy )
	{
		thread maps\_mgturret::portable_mg_behavior();
		return;
	}

	if (isdefined (self.used_an_mg42)) 
		return;

	if (override)
	{
		set_goal_radius_based_on_settings();

		self setgoalpos(self.origin);
		return;
	}

	assertEx( self.goalradius == 4, "Tried to set goalradius on guy with export " + self.export + " before running spawn_failed on him." );
	set_goal_radius_based_on_settings();


	
	
	
	if (isdefined(self.target))
		self thread go_to_node();
}


zone_alert(ai)
{
	ai waittill("start_propagation");

	zones = GetEntArray("zone", "targetname");
	this_zone = undefined;
	for (i = 0; i < zones.size; i++)
	{
		if (ai IsTouching(zones[i]))
		{
			this_zone = zones[i];
			break; 
		}
	}

	if (IsDefined(this_zone))
	{
		spawners = GetSpawnerArray();
		for (i = 0; i < spawners.size; i++)
		{
			if (!IsDefined(spawners[i].script_alert))	
			{
				if (spawners[i] IsTouching(this_zone))
				{
					spawners[i].script_alert = "alert_red";
				}
			}
		}
	}
}


scrub_guy()
{
	self eqoff();
	
	
	
	self setthreatbiasgroup( self.team );


	
	

	
	self.baseAccuracy = 1;
	set_default_pathenemy_settings();
	maps\_gameskill::grenadeAwareness();
	self clear_force_color();

	self.interval = 96;
	self.ignoreme = false;
	self.threatbias = 0;
	self.pacifist = false;
	self.pacifistWait = 20;
	self.IgnoreRandomBulletDamage = false;
	self.playerPushable = true;
	self.precombatrunEnabled = true;
	
	self.accuracystationarymod = 1;
	self.allowdeath = false;
	self.anglelerprate = 540;
	self.badplaceawareness = 0.75;
	self.chainfallback = 0;
	self.dontavoidplayer = 0;
	self.drawoncompass = 1;
	self.dropweapon = 1;
	self.goalradius = level.default_goalradius;
	self.goalheight = level.default_goalheight;
	self.ignoresuppression = 0;
	if ( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		stop_magic_bullet_shield();
	}

	self notify( "disable_reinforcement" );
	self.maxsightdistsqrd = 8192*8192;
	self.script_forceGrenade = 0;
	self.walkdist = 16;
	self unmake_hero();
	self.playerPushable = true;
	animscripts\init::set_anim_playback_rate();

	
	if ( isdefined( self.script_grenades ) )
	{
		self.grenadeAmmo = self.script_grenades;
	}
	else
		self.grenadeAmmo = 3;
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

set_goal_volume()
{
	self endon( "death" );
	waittillframeend;
	self setgoalvolume( level.goalVolumes[ self.script_goalvolume ] );
}

go_to_node( node )
{
	if (isdefined (self.used_an_mg42)) 
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

			
			node = node[level.current_spawn_num];
		}
		else
		{
			
			return;
			
			
		}
	}

	


	assertEx( self.goalheight == 80, "Tried to set goalheight on guy with export " + self.export + " before running spawn_failed on the guy." );
	
	if (isdefined (node.height))
		self.goalheight = node.height;
	else
		self.goalheight = level.default_goalheight;

	if ( node.radius != 0 )
		self.goalradius = node.radius;
	else
		self.goalradius = level.default_goalradius;

	
	if (node.type == "Chase")
	{
		self maps\_chase::start_chase_route(node);
		return;
	}
	else
	{
		self set_goal_node(node);
	}
	

	

	

	
	if (node.type == "Patrol")
		return;


	if (isdefined (node.target))
	{
		self endon ("death");

		nextNode_array = getnodearray(node.target,"targetname");
		if (nextNode_array.size > 0)
			nextNode = nextNode_array[ randomint(nextNode_array.size)];
		else
			nextNode = undefined;

		if (isdefined(nextNode))
		{
			self waittill ("goal");
			
			waittillframeend;
			
			for (;;)
			{
				node script_delay();
				node = nextNode;
				if (node.radius != 0)
					self.goalradius = node.radius;
				
				self set_goal_node(node);
				
				self waittill ("goal");
				if (!isdefined (node.target))
				{
					reached_end_of_node_chain( node );
					return;
				}

				nextNode_array = getnodearray(node.target,"targetname");
				if (nextNode_array.size > 0)
					nextNode = nextNode_array[ randomint(nextNode_array.size)];
				else
					nextNode = undefined;

				if (!isdefined(nextNode))
				{
					reached_end_of_node_chain( node );
					break;
				}
			}
		}
		else		
		{
			self waittill ("goal");
			reached_end_of_node_chain( node );
		}
	}
	else
	{
		set_goal_radius_based_on_settings( node );
		self thread reachPathEnd();
	}
}

set_goal_radius_based_on_settings( node )
{
	if ( isdefined( self.script_radius ) )
	{
		
		self.goalradius = self.script_radius;
		return;
	}

	if ( isDefined( self.script_forcegoal ) )
	{
		if ( isdefined( node ) && isdefined( node.radius ) )
		{
			
			self.goalradius = node.radius;
			return;
		}
	}

	
	self.goalradius = level.default_goalradius;
}

reached_end_of_node_chain( node )
{
	
	self set_goal_node(node);
	
	self waittill ("goal");
	set_goal_radius_based_on_settings( node );

	self notify ( "reached_path_end" );

	if ( !isdefined( node.target ) )
		return;
	turrets = getentArray( node.target, "targetname" );
	if ( turrets.size != 1 )
		return;

	turret = turrets[ 0 ];
	if ( turret.classname != "misc_turret" )
		return;

	self.goalradius = 4;
	self setgoalnode( node );
	self waittill( "goal" );
	set_goal_radius_based_on_settings( node );
	self use_a_turret (turret);
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
		self settargetentity( random( targets ) );
		self notify ("startfiring");
		self startFiring();

		wait (2 + randomfloat(1));
	}
}


use_a_turret( turret )
{
	if ( self.team == "axis" && self.health == 150 )
	{
		self.health = 100; 
		self.a.disableLongDeath = true;
	}

	

	self useturret(turret); 
	
	
	
	if ( ( isdefined( turret.target ) ) && ( turret.target != turret.targetname ) )
	{
		ents = getentarray( turret.target,"targetname" );
		targets = [];
		for ( i=0; i < ents.size;i++ )
		{
			if ( ents[ i ].classname == "script_origin" )
				targets[ targets.size ] = ents[ i ];
		}

		if ( isdefined( turret.script_autotarget ) )
		{
			turret thread autoTarget( targets );
		}
		else
			if ( isdefined( turret.script_manualtarget ) )
			{
				turret setmode( "manual_ai" );
				turret thread manualTarget( targets );
			}
			else
				if ( targets.size > 0 )
				{
					if ( targets.size == 1 )
					{
						turret.manual_target = targets[ 0 ];
						turret settargetentity( targets[ 0 ] );
						
						self thread maps\_mgturret::manual_think( turret );
						
						
					}
					else
					{
						turret thread maps\_mgturret::mg42_suppressionFire( targets );
					}
				}		
	}

	self thread maps\_mgturret::mg42_firing( turret );
	turret notify( "startfiring" );
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
			if (getdvar ("fallback") == "1")
				println ("^a First spawned: ", num);
			level notify (("fallback_firstspawn" + num));
			firstspawn = false;
		}

		maps\_spawner::waitframe(); 
		if (maps\_utility::spawn_failed(spawn))
		{
			level notify (("fallbacker_died" + num));
			level.current_fallbackers[num]--;
			continue;
		}

		spawn thread fallback_ai_think (num, node, "is spawner");
	}

	
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
		
	}

	level thread fallback_ai_think_death(self, num);
}

fallback_death(ai, num)
{
	ai waittill ("death");
	level notify (("fallback_reached_goal" + num));
	
}

fallback_goal()
{
	self waittill ("goal");
	self.ignoresuppression = false;

	self notify ("fallback_notify");
	self notify ("stop_coverprint");
}

fallback_ai (num, node)
{
	self notify ("stop_going_to_node");

	self stopuseturret();
	self.ignoresuppression = true;
	self setgoalnode (node);
	if (node.radius != 0)
		self.goalradius = node.radius;

	self endon ("death");
	level thread fallback_death(self, num);
	self thread fallback_goal();

	if (getdvar ("fallback") == "1")
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
	if (getdvar ("fallback") == "1")
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

		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		

		msg = "dead msg";

		fallbackers[i] animscripts\face::SaySpecificDialogue(undefined, msg, 1.0);

		return;
	}
}

fallback_wait (num, group)
{
	level endon (("fallbacker_trigger" + num));
	if (getdvar ("fallback") == "1")
		println ("^a Fallback wait: ", num);
	for (i=0;i<level.spawner_fallbackers[num];i++)
	{
		if (getdvar ("fallback") == "1")
			println ("^a Waiting for spawners to be hit: ", num, " i: ", i);
		level waittill (("fallback_firstspawn" + num));
	}
	if (getdvar ("fallback") == "1")
		println ("^a Waiting for AI to die, fall backers for group ", num, " is ", level.current_fallbackers[num]);

	
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		if (((isdefined (ai[i].script_fallback)) && (ai[i].script_fallback == num)) ||
			((isdefined (ai[i].script_fallback_group)) && (isdefined (group)) && (ai[i].script_fallback_group == group)))
			ai[i] thread fallback_ai_think(num);
	}
	ai = undefined;

	
	

	max_fallbackers = level.current_fallbackers[num];

	deadfallbackers = 0;
	while (level.current_fallbackers[num] > max_fallbackers * 0.5)
	{
		if (getdvar ("fallback") == "1")
			println ("^cwaiting for " + level.current_fallbackers[num] + " to be less than " + (max_fallbackers * 0.5));
		level waittill (("fallbacker_died" + num));
		deadfallbackers++;
	}

	println (deadfallbackers , " fallbackers have died, time to retreat");
	level notify (("fallbacker_trigger" + num));
}

fallback_think(trigger) 
{
	if ((!isdefined (level.fallback)) || (!isdefined (level.fallback[trigger.script_fallback])))
		level thread newfallback_overmind (trigger.script_fallback, trigger.script_fallback_group);

	trigger waittill ("trigger");
	level notify (("fallbacker_trigger" + trigger.script_fallback));
	

	
	kill_trigger (trigger);
}

arrive (node)
{
	self waittill( "goal" );

	if ( node.radius != 0 )
		self.goalradius = node.radius;
	else
		self.goalradius = level.default_goalradius;
}

fallback_coverprint ()
{
	
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
	
	dest = getnode (self.target, "targetname");
	self.coverpoint = dest;

	self setgoalnode(dest);
	if (isdefined (self.script_seekgoal))
		self thread arrive(dest);
	else
	{
		if ( dest.radius != 0 )
			self.goalradius = dest.radius;
		else
			self.goalradius = level.default_goalradius;
	}

	while (1)
	{
		self waittill ("fallback");
		self.interval = 20;
		level thread fallback_death(self);

		if (getdvar ("fallback") == "1")
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
	
	
}

friendly_waittill_death (spawned)
{
	
	

	
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
	if ( !isdefined(level.friendlywave_force_color) )
		level.friendlywave_force_color = [];

	if (!isdefined (level.totalfriends))
		level.totalfriends = 0;
	level.totalfriends++;
	ai waittill ("death");

	force_color = ai get_force_color();
	if ( isdefined( force_color ) )
		level.friendlywave_force_color[level.friendlywave_force_color.size] = force_color;

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
	
	if ( !isdefined(level.friendlywave_force_color) )
		level.friendlywave_force_color = [];

	triggers = getentarray ("friendly_wave", "targetname");
	maps\_utility::array_thread(triggers, ::set_spawncount, 0);

	
	

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


				else if(!script_delay)
					num = randomint (spawn.size);
				else if(num == spawn.size)
					num = 0;

				if ( level.friendlywave_force_color.size > 0 )
				{
					
					

					color_spawner = [];
					index = level.friendlywave_force_color.size - 1;

					for (i=0; i<spawn.size; i++)
					{
						color = spawn[i] get_force_color();

						if ( isdefined(color) && color == level.friendlywave_force_color[index])
							color_spawner[color_spawner.size] = i;
					}
					if (color_spawner.size)
						num = color_spawner[ randomint(color_spawner.size) ];
				}

				spawn[num].count = 1;
				if (isdefined(spawn[num].script_forcespawn))
					spawned = spawn[num] stalingradSpawn();
				else
					spawned = spawn[num] doSpawn();
				spawn[num].count = 0;

				if (spawn_failed(spawned))
				{
					wait (0.2);
					continue;
				}

				if ( level.friendlywave_force_color.size > 0 )
				{
					
					index = level.friendlywave_force_color.size - 1;
					level.friendlywave_force_color[index] = undefined;
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

friendly_mgTurret(trigger)
{
	
	
	
	

	node = getnode (trigger.target,"targetname");

	
	
	


	mg42 = getent (node.target,"targetname");
	mg42 setmode("auto_ai"); 
	mg42 cleartargetentity();


	in_use = false;
	while (1)
	{
		
		trigger waittill ("trigger", other);
		
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
	self notify ("stopped_use_turret"); 
	mg42 notify ("friendly_finished_using_mg42");
}

friendly_mg42_useable (mg42, node)
{
	if (self.useable)
		return false;

	if ((isdefined (self.turret_use_time)) && (gettime() < self.turret_use_time))
	{
		
		return false;
	}

	if (distance (level.player.origin, node.origin) < 100)
	{
		
		return false;
	}

	if (isdefined (self.chainnode))
		if (distance (level.player.origin, self.chainnode.origin) > 1100)
		{
			
			return false;
		}
		return true;
}

friendly_mg42_endtrigger (mg42, guy)
{
	mg42 endon ("friendly_finished_using_mg42");
	self waittill ("trigger");
	println ("^a Told friendly to leave the MG42 now");
	
	

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
	
	level thread friendly_mg42_death_notify(self, mg42);
	
	self.oldradius = self.goalradius;
	self.goalradius = 28;
	self thread noFour();
	self setgoalnode (node);

	self.ignoresuppression = true;

	self waittill ("goal");
	self.goalradius = self.oldradius;
	if (self.goalradius < 32)
		self.goalradius = 400;

	
	self.ignoresuppression = false;

	
	
	self.goalradius = self.oldradius;

	if (distance (level.player.origin, node.origin) < 32)
	{
		mg42 notify ("friendly_finished_using_mg42");
		return;
	}

	self.friendly_mg42 = mg42; 
	self thread friendly_mg42_wait_for_use(mg42);
	self thread friendly_mg42_cleanup (mg42);
	self useturret(mg42); 
	

	if (isdefined (mg42.target))
	{
		stoptrigger = getent (mg42.target,"targetname");
		if (isdefined (stoptrigger))
			stoptrigger thread friendly_mg42_endtrigger(mg42, self);
	}

	while (1)
	{
		if (distance (self.origin, node.origin) < 32)
			self useturret(mg42); 
		else
			break; 

		if (isdefined (self.chainnode))
		{
			if (distance (self.origin, self.chainnode.origin) > 1100)
				break; 
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
	self notify ("stopped_use_turret"); 
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
		
	}
}


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
	
	
	
}

#using_animtree("generic_human");
showStart(origin, angles, anime)
{
	org = getstartorigin(origin,angles,anime);
	for (;;)
	{
		print3d (org, "x", (0.0,0.7,1.0), 1, 0.25);	
		wait (0.05);
	}
}

spawnWaypointFriendlies()
{
	self.count = 1;

	if (isdefined(self.script_forcespawn))
		spawn = self stalingradSpawn();
	else
		spawn = self doSpawn();

	if (spawn_failed(spawn))
		return;
	spawn.friendlyWaypoint = true;
}



waittillDeathOrLeaveSquad()
{
	self endon ("death");
	self waittill ("leaveSquad");
}


friendlySpawnWave()
{
	

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
		
		
		if (activeFriendlySpawn() && getFriendlySpawnTrigger() == self)
			unsetFriendlySpawn();

		self waittill ("friendly_wave_start", startPoint);
		setFriendlySpawn(startPoint, self);


		
		
		if (!isdefined (startPoint.target))
			continue;
		trigger = getent (startPoint.target,"targetname");
		trigger thread spawnWaveStopTrigger(self);
	}
}



flood_and_secure( instantRespawn )
{
	

	
	if (!isdefined(instantRespawn))
		instantRespawn = false;

	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "instant_respawn" ) )
		instantRespawn = true;

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
					
					continue;
				}
		}

		
		
		spawners = getentarray(self.target, "targetname");


		if (isdefined (spawners[0]))
			if (isdefined (spawners[0].script_randomspawn))
				select_random_spawn(spawners);

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

select_random_spawn(spawners)
{
	selection = randomint (2);
	for (i=0;i<spawners.size;i++)
	{
		if (spawners[i].script_randomspawn != selection)
			spawners[i] delete();
	}
}

flood_and_secure_spawner(instantRespawn)
{
	if (isdefined(self.secureStarted))
	{
		
		
		return;
	}

	self.secureStarted = true;
	self.triggerUnlocked = true; 

	mg42 = issubstr(self.classname, "mgportable") || issubstr(self.classname, "30cal");
	if (!mg42)
	{
		
		
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

	
	possibleSpawners = getentarray(target, "targetname");
	spawners = [];	
	for (i=0;i<possibleSpawners.size;i++)
	{
		if (!issubstr(possibleSpawners[i].classname, "actor"))
			continue;

		
		spawners[spawners.size] = possibleSpawners[i];
	}

	ent = spawnstruct();
	org = self.origin;
	flood_and_secure_spawner_think(mg42, ent, spawners.size > 0, instantRespawn);
	if (isalive(ent.ai))
		ent.ai waittill ("death");


	
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

		
		
		possibleSpawners[i].target = newTarget;

		possibleSpawners[i] thread flood_and_secure_spawner(instantRespawn);

		
		
		possibleSpawners[i].playerTriggered = true;
		possibleSpawners[i] notify ("flood_begin"); 
	}
}

flood_and_secure_spawner_think(mg42, ent, oneShot, instantRespawn)
{
	assert(isdefined(instantRespawn));
	self endon ("death");
	count = self.count;
	
	if (!oneShot)
		oneshot = (isdefined (self.script_noteworthy) && self.script_noteworthy == "delete");
	self.count = 2; 

	if (isdefined(self.script_delay))
		delay = self.script_delay;
	else
		delay = 0;

	for (;;)
	{
		self waittill ("flood_begin");
		if (self.playerTriggered)
			break;
		
		
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
			spawn = self stalingradSpawn();
		else
			spawn = self doSpawn();

		if (spawn_failed(spawn))
		{
			playerKill = false;
			if (delay < 2)
				wait (2); 
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
				delay = randomint(4) + 2; 
			else
				delay = 0.5 + randomfloat (0.5);
		}

		if (deleted)
		{
			
			

			waittillRestartOrDistance(dist);
		}
		else
		{
			
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
	
	waittillDeletedOrDeath(spawn);
	level.spawnerWave[name].count--;
	if (!isdefined (self))
		level.spawnerWave[name].total--;

	

	
	
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

	

	return bulletTracePassed(level.player geteye(), ai geteye(), false, undefined);
}

waittillRestartOrDistance(dist)
{
	self endon ("flood_begin");

	dist = dist * 0.75; 

	while (distance(level.player.origin, self.origin) > dist)
		wait (1);
}

flood_and_secure_spawn (spawner, mg42)
{
	if (!mg42)
		self thread flood_and_secure_spawn_goal();
	self waittill ("death", other);

	playerKill = isalive(other) && other == level.player;
	if (!playerkill && isdefined(other) && other.classname == "worldspawn") 
		playerKill = true;
	deleted = !isdefined(self);

	spawner notify ("spawn_died", deleted, playerKill);
}

flood_and_secure_spawn_goal()
{
	self endon ("death");
	node = getnode(self.target,"targetname");
	self setgoalnode(node);

	if (isdefined( self.script_deathChain ) )
		self setgoalvolume( level.deathchain_goalVolume[ self.script_deathChain ] );

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
			
			
			
			self dodamage( (self.health *0.5), (0,0,0) );
			return;
		}
	}

	if ( isDefined( node.target ) )
	{
		turret = getEnt( node.target, "targetname" );
		if ( isDefined (turret) && (turret.classname == "misc_mgturret" || turret.classname == "misc_turret") )
		{
			self setGoalNode( node );
			self.goalradius = 4;
			self waittill ( "goal" );
			if ( !isDefined( self.script_forcegoal ) )
				self.goalradius = level.default_goalradius;
			self maps\_spawner::use_a_turret( turret );
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
			self thread set_battlechatter(false);
			return;
		}
	}

	if (!isdefined (self.script_forcegoal))
	{
		self.goalradius = level.default_goalradius;
		if (self.script_displaceable != 0) 
			self.script_displaceable = 1;
	}
}

furniturePushSound()
{
	org = getent(self.target,"targetname").origin;
	play_sound_in_space ("furniture_slide", org);
	wait (0.9);
	if (isdefined(level.whisper))
		play_sound_in_space (random(level.whisper), org);

}


friendlychain()
{
	
	waittillframeend;
	triggers = getentarray(self.target,"targetname");
	if (!triggers.size)
	{
		
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
	
	triggers = getentarray("friendly_chain_on_death","targetname");
	spawners = getspawnerarray();
	level.deathSpawner = [];
	/#
		
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
		wait (5); 
	}
}

setNewPlayerChain(node, rejoin)
{
	level.player set_friendly_chain_wrapper(node);
	level notify ("new_escort_trigger"); 
	level notify ("new_escort_debug");
	level notify ("start_chain", rejoin); 
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
	volumes = getentarray( "info_volume", "classname" );
	level.deathchain_goalVolume = [];
	level.goalVolumes = [];

	for ( i = 0; i < volumes.size; i++ )
	{
		volume = volumes[ i ];
		if ( isdefined( volume.script_deathChain ) )
		{
			level.deathchain_goalVolume[ volume.script_deathChain ] = volume;
		}
		if ( isdefined( volume.script_goalvolume ) )
		{
			level.goalVolumes[ volume.script_goalVolume ] = volume;
		}
	}
}

debugPrint(msg, endonmsg, color)
{
	
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

aigroup_create( aigroup )
{
	level._ai_group[aigroup] = spawnstruct();
	level._ai_group[aigroup].aicount = 0;
	level._ai_group[aigroup].spawnercount = 0;
	level._ai_group[aigroup].ai = [];
	level._ai_group[aigroup].spawners = [];

	if (!isdefined(level.flag[aigroup + "_cleared"]))	
	{
		flag_init(aigroup + "_cleared");
	}

	if (!isdefined(level.flag[aigroup + "_alert"]))	
	{
		flag_init(aigroup + "_alert");
	}
}

aigroup_spawnerthink( tracker )
{
	self endon ( "death" );

	self.decremented = false;
	tracker.spawnercount++;
	tracker.spawners[tracker.spawners.size] = self;

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

	if ((tracker.aicount == 0) && (tracker.spawnercount == 0))
	{
		flag_set(self.script_aigroup + "_cleared");
	}
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

	self thread aigroup_alert();

	self waittill ( "death" );	
	tracker.aicount--;

	if ((tracker.aicount == 0) && (tracker.spawnercount == 0))
	{
		flag_set(self.script_aigroup + "_cleared");
	}
}


aigroup_alert()
{
	self endon("death");
	if (self GetAlertState() != "alert_red")
	{
		self waittill("start_propagation");
	}

	if (!flag(self.script_aigroup + "_alert"))
	{
		flag_set(self.script_aigroup + "_alert");

		
		if (IsDefined(level._ai_group[self.script_aigroup + "_backup"]))
		{
			for (i = 0; i < level._ai_group[self.script_aigroup + "_backup"].spawners.size; i++)
			{
				spawner = level._ai_group[self.script_aigroup + "_backup"].spawners[i];

				if (IsDefined(spawner) && !spawner.active)
				{
					if ((!IsDefined(spawner.script_alert)) && (!IsDefined(spawner.script_alertmin)) && (!IsDefined(spawner.script_alertmax)))
					{
						spawner.script_alert = "alert_red";	
					}

					spawner thread maps\_spawner::flood_spawner_think();
				}
			}
		}
	}
}




flood_trigger_think( trigger )
{
	assertEX( isDefined( trigger.target ), "flood_spawner without target" );

	floodSpawners = getEntArray( trigger.target, "targetname" );
	assertEX( floodSpawners.size, "flood_spawner at with target " + trigger.target + " without any targets" );

	array_thread( floodSpawners, ::flood_spawner_init );

	trigger waittill ( "trigger" );
	
	floodSpawners = getEntArray( trigger.target, "targetname" );
	array_thread( floodSpawners, ::flood_spawner_think, trigger );
}


flood_spawner_init( spawner )
{
	assertEX( (isDefined( self.spawnflags ) && self.spawnflags & 1), "Spawner at origin" + self.origin + "/" + (self getOrigin()) + " is not a spawner!" );
}

trigger_requires_player( trigger )
{
	if ( !isdefined( trigger ) )
		return false;

	return isDefined( trigger.script_requires_player );
}

flood_spawner_think( trigger )
{
	self.active = true;	
	self endon("death");
	self notify ("stop current floodspawner");
	self endon ("stop current floodspawner");

	
	
	
	if ( is_pyramid_spawner() )
	{
		pyramid_spawn( trigger );
		return;
	}

	requires_player = trigger_requires_player( trigger );

	script_delay();

	while ( self.count > 0 )
	{
		while ( requires_player && !level.player isTouching( trigger ) )
			wait (0.5);


		if ( isDefined( self.script_forcespawn ) )
			soldier = self stalingradSpawn();
		else
			soldier = self doSpawn();

		if ( spawn_failed( soldier ) )
		{
			wait (2);
			continue;
		}

		soldier thread reincrement_count_if_deleted( self );
		soldier thread expand_goalradius( trigger );

		soldier waittill ("death");

		
		if ( !isDefined( soldier ) )
			continue;

		if ( !script_wait() )
			wait (randomFloatRange( 5, 9 ));
	}
}

is_pyramid_spawner()
{
	if ( !isdefined( self.target ) )
		return false;

	ent = getentarray( self.target, "targetname" );
	if ( !ent.size )
		return false;

	return issubstr( ent[0].classname, "actor" );
}


pyramid_death_report( spawner )
{
	spawner.spawn waittill( "death" );
	self notify( "death_report" );
}

pyramid_spawn( trigger )
{

	self endon( "death" );
	requires_player = trigger_requires_player( trigger );

	script_delay();

	if ( requires_player )
	{
		while ( !level.player isTouching( trigger ) )
			wait (0.5);
	}

	
	

	spawners = getentarray( self.target, "targetname" );
	/#
		for ( i=0; i < spawners.size; i++ )
			assertEx( issubstr( spawners[i].classname, "actor" ), "Pyramid spawner targets non AI!" );
#/

	
	self.spawners = 0;
	array_thread( spawners, ::pyramid_spawner_reports_death, self );

	offset = randomint( spawners.size );
	for ( i=0; i < spawners.size; i++ )
	{
		if ( self.count <= 0 )
			return;

		offset++;
		if ( offset >= spawners.size )
			offset = 0;
		spawner = spawners[ offset ];

		
		spawner.count = 1;

		soldier = spawner spawn_ai();
		if ( spawn_failed( soldier ) )
		{
			
			wait (2);
			continue;
		}

		self.count--;
		spawner.spawn = soldier;

		soldier thread reincrement_count_if_deleted( self );
		soldier thread expand_goalradius( trigger );
		thread pyramid_death_report( spawner );
	}

	culmulative_wait = 0.01;
	while ( self.count > 0 )
	{
		self waittill( "death_report" );
		script_wait();
		wait( culmulative_wait );
		culmulative_wait+= 2.5;

		offset = randomint( spawners.size );
		for ( i=0; i < spawners.size; i++ )
		{
			
			spawners = array_removeUndefined( spawners );			

			if ( !spawners.size )
			{
				if ( isdefined( self ) )
					self delete();
				return;
			}

			offset++;
			if ( offset >= spawners.size )
				offset = 0;

			spawner = spawners[ offset ];

			
			if ( isalive( spawner.spawn ) )
				continue;

			
			if ( isdefined( spawner.target ) )
			{
				self.target = spawner.target;
			}
			else
			{
				self.target = undefined;
			}

			soldier = self spawn_ai();
			if ( spawn_failed( soldier ) )
			{
				wait( 2 );
				continue;
			}

			assertEx( isdefined( spawner ), "Theoretically impossible." );
			soldier thread reincrement_count_if_deleted( self );
			soldier thread expand_goalradius( trigger );
			spawner.spawn = soldier;
			thread pyramid_death_report( spawner );

			if ( self.count <= 0 )
				return;
		}
	}
}

pyramid_spawner_reports_death( parent )
{
	parent endon( "death" );
	parent.spawners++;
	self waittill( "death" );
	parent.spawners--;
	if ( !parent.spawners )
		parent delete();
}

expand_goalradius( trigger )
{
	if ( isDefined( self.script_forcegoal ) )
		return;

	
	
	radius = level.default_goalradius;
	if ( isdefined( trigger ) )
	{
		if ( isdefined( trigger.script_radius ) )
		{
			if ( trigger.script_radius == -1 )
				return;
			radius = trigger.script_radius;
		}
	}

	
	self endon("death");
	self waittill ( "goal" );
	self.goalradius = radius;
}


drop_health_timeout_thread()
{
	self endon( "death" );
	wait( 95 );
	self notify( "timeout" );
}

drop_health_trigger_think()
{
	self endon( "timeout" );
	thread drop_health_timeout_thread();
	self waittill( "trigger" );
	change_player_health_packets( 1 );
}

traceShow( org )
{
	for ( ;; )
	{
		line ( org + (0,0,100), org, (0.2, 0.5, 0.8), 0.5);
		wait (0.05);
	}
}

drophealth()
{
	
	waittillframeend;
	waittillframeend;

	if ( !isalive( self ) )
		return;

	if ( isdefined( self.script_nohealth ) )
		return;

	self waittill ("death");

	if (!isdefined (self))
		return;

	
	if ( 1 )
		return;


	
	if ( gettime() < level.next_health_drop_time )
		return;

	
	level.guys_to_die_before_next_health_drop--;
	if ( level.guys_to_die_before_next_health_drop > 0 )
		return;

	level.guys_to_die_before_next_health_drop = randomintrange( 2, 5 );
	level.next_health_drop_time = gettime() + 3500; 

	trace = bullettrace(self.origin + (0,0,50), self.origin + (0,0,-220), true, self);
	health = spawn( "script_model", self.origin + (0,0,10) );
	health.origin = trace[ "position" ];
	

	trigger = spawn( "trigger_radius", self.origin + (0,0,10), 0, 10, 32 );
	trigger.radius = 10;

	trigger drop_health_trigger_think();	

	trigger delete();
	health delete();


	
	

	
}

show_bad_path()
{
	/#
		if ( getdebugdvar( "debug_badpath" ) == "" )
			setdvar( "debug_badpath", "" );

	self endon( "death" );
	for ( ;; )
	{
		self waittill( "bad_path", badPathPos );
		if ( !level.debug_badpath )
			continue;

		for ( p=0; p<10*20; p++ )
		{
			line( self.origin, badPathPos, ( 1, 0.4, 0.1 ), 0, 10*20 );
			wait ( 0.05 );
		}
	}		
#/
}

random_spawn( trigger )
{
	trigger waittill( "trigger" );
	
	spawners = getentarray( trigger.target, "targetname" );
	if ( !spawners.size )
		return;
	spawner = random( spawners );

	spawners = [];
	spawners[ spawners.size ] = spawner;
	
	if ( isdefined( spawner.script_linkto ) )
	{
		links = strTok( spawner.script_linkto, " " );
		for ( i=0; i < links.size; i++ )
		{
			spawners[ spawners.size ] = getent( links[ i ], "script_linkname" );
		}
	}

	waittillframeend; 
	array_thread( spawners, ::add_spawn_function, ::blowout_goalradius_on_pathend );
	array_thread( spawners, ::spawn_ai );
}

blowout_goalradius_on_pathend()
{
	if ( isDefined( self.script_forcegoal ) )
		return;

	self endon( "death" );
	self waittill( "reached_path_end" );
	self.goalradius = level.default_goalradius;
}

spawn_ai()
{
	if ( isdefined( self.script_forcespawn ) )
		return self stalingradSpawn();
	return self doSpawn();
}

objective_event_init( trigger )
{
	flag = trigger get_trigger_flag();
	assertEx( isdefined( flag ), "Objective event at origin " + trigger.origin + " does not have a script_flag. " );
	flag_init( flag );

	assertEx( isdefined( level.deathSpawner[ trigger.script_deathChain ] ), "The objective event trigger for deathchain " + trigger.script_deathchain + " is not associated with any AI." );
	/#
		if ( !isdefined( level.deathSpawner[ trigger.script_deathChain ] ) )
			return;
#/
	while ( level.deathSpawner[ trigger.script_deathChain ] > 0 )
		level waittill( "spawner_expired" + trigger.script_deathChain );

	flag_set( flag );
}

setup_ai_eq_triggers()
{
	self endon( "death" );
	
	waittillframeend; 

	self.is_the_player = self == level.player;
	self.eq_table = [];
	self.eq_touching = [];
	for ( i=0; i < level.eq_trigger_num; i++ )
	{
		self.eq_table[ i ] = false;
	}
}

ai_array()
{
	level.ai_array[ level.ai_number ] = self;
	self waittill( "death" );
	waittillframeend;
	level.ai_array[ level.ai_number ] = undefined;
}


player_score_think()
{
	if (self.team == "allies" )
		return;
	self waittill ("death", attacker);
	if ( (isdefined(attacker)) && (attacker == level.player) )
		level.player thread updatePlayerScore (1 + randomint (3) );
}


updatePlayerScore( amount )
{
	if ( amount == 0 )
		return;

	self notify( "update_xp" );
	self endon( "update_xp" );

	self.rankUpdateTotal += amount;

	self.hud_rankscroreupdate.label = &"SCRIPT_PLUS";

	self.hud_rankscroreupdate setValue(self.rankUpdateTotal);
	self.hud_rankscroreupdate.alpha = 1;
	self.hud_rankscroreupdate thread fontPulse( self );

	wait 1;
	self.hud_rankscroreupdate fadeOverTime( 0.75 );
	self.hud_rankscroreupdate.alpha = 0;

	self.rankUpdateTotal = 0;
}


xp_init()
{
	self.rankUpdateTotal = 0;
	self.hud_rankscroreupdate = newHudElem(self);
	self.hud_rankscroreupdate.horzAlign = "center";
	self.hud_rankscroreupdate.vertAlign = "middle";
	self.hud_rankscroreupdate.alignX = "center";
	self.hud_rankscroreupdate.alignY = "middle";
	self.hud_rankscroreupdate.x = 0;
	self.hud_rankscroreupdate.y = -60;
	self.hud_rankscroreupdate.font = "default";
	self.hud_rankscroreupdate.fontscale = 2;
	self.hud_rankscroreupdate.archived = false;
	self.hud_rankscroreupdate.color = (1,1,1);
	self.hud_rankscroreupdate fontPulseInit();
}

fontPulseInit()
{
	self.baseFontScale = self.fontScale;
	self.maxFontScale = self.fontScale * 2;
	self.inFrames = 3;
	self.outFrames = 5;
}


fontPulse(player)
{
	self notify ( "fontPulse" );
	self endon ( "fontPulse" );

	scaleRange = self.maxFontScale - self.baseFontScale;

	while ( self.fontScale < self.maxFontScale )
	{
		self.fontScale = min( self.maxFontScale, self.fontScale + (scaleRange / self.inFrames) );
		wait 0.05;
	}

	while ( self.fontScale > self.baseFontScale )
	{
		self.fontScale = max( self.baseFontScale, self.fontScale - (scaleRange / self.outFrames) );
		wait 0.05;
	}
}

#using_animtree("generic_human");
spawner_dronespawn(spawner)
{
	assert(isdefined(level.dronestruct[spawner.classname]));
	struct = level.dronestruct[spawner.classname];
	drone = spawn ("script_model",spawner.origin);
	drone setmodel (struct.model);
	
	drone UseAnimTree(#animtree);
	drone makefakeai();
	attachedmodels = struct.attachedmodels;
	attachedtags = struct.attachedtags;
	for(i=0;i<attachedmodels.size;i++)
	{
		drone attach(attachedmodels[i],attachedtags[i]);
	}
	if(isdefined(spawner.script_startingposition))
		drone.script_startingposition = spawner.script_startingposition;
	
	drone.spawner = spawner;

	assert(isdefined(drone));
	if(isdefined(spawner.script_noteworthy) && spawner.script_noteworthy == "drone_delete_on_unload")
		drone.drone_delete_on_unload = true; 
	else 
		drone.drone_delete_on_unload = false;

	return drone;
}

spawner_makerealai(drone)
{
	assertEX(isdefined(drone.spawner),"makerealai called on drone does with no .spawner");
	orgorg = drone.spawner.origin;
	organg = drone.spawner.angles;
	drone.spawner.origin = drone.origin;
	drone.spawner.angles = drone.angles;
	guy = drone.spawner stalingradspawn();
	spawn_failed(guy);
	drone.spawner.origin = orgorg;
	drone.spawner.angles = organg;
	drone delete();
	return guy;
}






actor_death( ent_actor )
{
	
	ent_actor thread maps\_achievements::ach_headshot_watch();

	
	ent_actor thread maps\_achievements::ach_quick_kill_watch();

	
	
}
