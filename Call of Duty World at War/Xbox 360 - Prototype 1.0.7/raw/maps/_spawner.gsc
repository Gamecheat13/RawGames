#include maps\_utility;
#include common_scripts\utility;

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
	precachemodel("grenade_bag");
	precachemodel("com_trashbag");
	//****************************************************************************
	//   connect auto AI spawners
	//****************************************************************************

	// create default threatbiasgroups;
	createthreatbiasgroup("allies");
	createthreatbiasgroup("axis");

	level.player setthreatbiasgroup("allies");
	//level.player thread xp_init();

/*
	spawners = getSpawnerArray();
	for ( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[i];
		if ( !isDefined( spawner.targetname ) )
			continue;
			
		triggers = getEntArray( spawner.targetname, "target" );
		for ( j = 0; j < triggers.size; j++ )
		{
			trigger = triggers[j];
			
			if ( ( isdefined( trigger.targetname ) ) && ( trigger.targetname == "flood_spawner" ) )
				continue;
			
			switch ( trigger.classname )
			{
			case "trigger_multiple":
			case "trigger_once":
			case "trigger_use":
			case "trigger_damage":
			case "trigger_radius":
			case "trigger_lookat":
				if ( spawner.count )
					trigger thread doAutoSpawn(spawner);
				break;
			}
		}
	}
*/

	//****************************************************************************

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
	level.default_goalradius = 2048;
	level.default_goalheight = 80;
	level.portable_mg_gun_tag = "J_Shoulder_RI"; // need to get J_gun back to make it work properly
	level.mg42_hide_distance = 1024;
	
	if (!isdefined (level.maxFriendlies))
		level.maxFriendlies = 11;

	level._max_script_health = 0;
	ai = getaiarray ();
	for (i=0;i<ai.size;i++)
	{
		/*
		if ( isdefined( ai[ i ].script_health ) )
		{
			array_size = 0;
			if ( isdefined( level._ai_health ) )
			if ( isdefined( level._ai_health[ ai[ i ].script_health ] ) )
				array_size = level._ai_health[ ai[ i ].script_health ].size;

			level._ai_health[ ai[ i ].script_health ][ array_size ] = ai[ i ];
			if ( ai[ i ].script_health > level._max_script_health )
				level._max_script_health = ai[ i ].script_health;
		}
		
		if (isdefined (ai[i].script_aigroup))
		{
			aigroup = ai[i].script_aigroup;
			if (!isdefined(level._ai_group[aigroup]))
				aigroup_create(aigroup);
			ai[i] thread aigroup_soldierthink( level._ai_group[aigroup] );
		}
		*/
		
		ai[i] thread spawn_think ();
	}

/*
	if ( isdefined( level._ai_health ) )
	{
		for ( i=0; i<level._max_script_health+1; i++ )
		{
			if ( isdefined( level._ai_health[ i ] ) )
			{
				rnum = randomint( level._ai_health[ i ].size );
				level._ai_health[ i ][ rnum ].drophealth = true;
			}
		}

		for ( i=0; i<ai.size; i++ )
		if ( isdefined( ai[ i ].drophealth ) )
			ai[ i ] thread drophealth();
	}
*/

	spawners = getspawnerarray();
	for (i=0;i<spawners.size;i++)
		spawners[i] thread spawn_prethink();

}

outdoor_think( trigger )
{
	trigger endon( "death" );
	for(;;)
	{
		trigger waittill( "trigger", dude );
		dude thread ignore_triggers(2);

		if ( isdefined( dude.usingShotgun ) )
		{
			dude.usingShotgun = undefined;
			dude thread animscripts\move::shotgunPutaway();
		}
	}	
}

indoor_think( trigger )
{
	trigger endon( "death" );
	for(;;)
	{
		trigger waittill( "trigger", dude );
		dude thread ignore_triggers(2);
		
		if ( !isdefined( dude.usingShotgun ) )
		{
			dude.usingShotgun = true;
			dude thread animscripts\move::shotgunPullout();
		}
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
			return; // manually disconnected
		if (isdefined(spawner.triggerUnlocked))
			return; // manually disconnected
		
		guy = spawner spawn_ai();
			
		if (spawn_failed(guy))
			spawner notify ("spawn_failed");
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

	grenade = spawn("weapon_fraggrenade", origin);
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
	grenade setmodel ("grenade_bag");
	grenade.count = 3;
//	wait (0.2);
//	if (isdefined (grenade))
	grenade.angles = angles;
	return grenade;
}

dronespawn_setstruct(spawner)
{
	//spawn a guy, grab his info. delete him. Poor guy
	struct = spawnstruct();
	guy = spawner stalingradspawn();
	spawner.count ++; //replenish the spawner
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
		// NO AI in the level plz
		self.count = 0;
		return;
	}
	
	prof_begin("spawn_prethink");

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
	
	/*
	// all guns are setup by default now
	// portable mg42 guys
	if (issubstr(self.classname, "mgportable") || issubstr(self.classname, "30cal"))
		thread mg42setup_gun();
	*/
		
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
		//assertEx( isalive( spawn ), "Spawner spawned a dead guy somehow." );
		
		if ( isdefined( level.spawnerCallbackThread ) )
			self thread [[ level.spawnerCallbackThread ]]( spawn );
		
		/*
		if ( !isSentient ( spawn ) || !isalive ( spawn ) )
		{
			prof_end("spawn_prethink");
			continue;
		}
		*/
		
				
//		level thread debug_message ("SPAWNED", spawned.origin);

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
			spawn thread spawn_think( self.targetname );
		else
			spawn thread spawn_think();
	}
}

// Wrapper for spawn_think
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
		// keep them around in developer mode, for debugging
			self.spawn_funcs = self.saved_spawn_functions;
			self.saved_spawn_functions = undefined;
		#/
	}
	

	
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

	/#
	if (getdebugdvar("debug_misstime") == "start")
		self thread maps\_debug::debugMisstime();
		
	thread show_bad_path();
	#/

	if ( !isdefined( self.ai_number ) )
	{
		set_ai_number();
	}
	
	// which eq triggers am I touching?
//	thread setup_ai_eq_triggers();
//	thread ai_array();
	self eqoff();
		

	if ((isdefined (self.script_moveoverride)) && (self.script_moveoverride == 1))
		override = true;
	else
		override = false;

	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "mgpair" )
	{
		// mgpair guys get angry when their fellow buddy dies
		thread maps\_mg_penetration::create_mg_team();
	}
	
	level thread maps\_friendlyfire::friendly_fire_think( self );


	if ( isdefined( self.script_goalvolume ) )
	{
		// wait until frame end so that the AI's goal has a chance to get set
		thread set_goal_volume();
	}
	
	// create threatbiasgroups
	if ( isdefined(self.script_threatbiasgroup) )
	{
//		if ( !threatbiasgroupexists (self.script_threatbiasgroup))
//			createthreatbiasgroup( self.script_threatbiasgroup );
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

	// Set the accuracy for the spawner
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

	if (self.team == "axis" && self.type == "human")
	{
		self thread drop_gear();
		self thread drophealth();
	}


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

	if (isdefined(self.script_fightdist))
		self.pathenemyfightdist = self.script_fightdist;
	
	if (isdefined(self.script_maxdist))
		self.pathenemylookahead = self.script_maxdist;	

	// disable long death like dying pistol behavior
	if (isdefined(self.script_longdeath) && self.script_longdeath == false)
	{
		self.a.disableLongDeath = true;	
		assertEX(self.team != "allies", "Allies can't do long death, so why disable it on the guy at " + self.origin + "?");
	}
	else
	{
		// Make axis have 150 health so they can do dying pain.
		if (self.team == "axis" && !portableMG42guy)
			self.health = 150;
	}

	//player score stuff
	//self thread player_score_think();
	

	// Gives AI grenades
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

	if ( portableMG42guy )
	{
		thread maps\_mgturret::portable_mg_behavior();
		return;
	}

	if (isdefined (self.used_an_mg42)) // This AI was called upon to use an MG42 so he's not going to run to his node.
		return;

	if (override)
	{
		set_goal_radius_based_on_settings();
			
		self setgoalpos(self.origin);
		return;
	}

	assertEx( self.goalradius == 4, "Tried to set goalradius on guy with export " + self.export + " before running spawn_failed on him." );
	set_goal_radius_based_on_settings();


	// The AI will run to a target node and use the node's .radius as his goalradius.
	// If script_seekgoal is set, then he will run to his node with a goalradius of 0, then set his goal radius
	//    to the node's radius.
	if (isdefined(self.target))
		self thread go_to_node();
}

// reset this guy to default spec
scrub_guy()
{
	self eqoff();
//	if ( self.team == "allies" )
//		self setthreatbiasgroup( "allies" );
//	else
	self setthreatbiasgroup( self.team );
	
	
//	if ( isdefined ( self.script_bcdialog ) )
//		self set_battlechatter( self.script_bcdialog );

	// Set the accuracy for the spawner
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
//	self.favoriteenemy = undefined;
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

	// Gives AI grenades
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
			// a non node target, something scripted
			return;
			/*
			// are we targetted a turret?
			turrets = getentArray( self.target, "targetname" );
			if ( turrets.size != 1 )
				return;
				
			turret = turrets[ 0 ];
			if ( turret.classname != "misc_turret" )
				return;
				
			*/
			/*
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
			*/
		}
	}

/*
	if (isdefined (node.target))
	{
		turret = getent (node.target, "targetname");
		if ((isdefined (turret)) && ((turret.classname == "misc_mg42") || (turret.classname == "misc_turret")))
			turret thread flag_turret_for_use (self);
	}
*/


	assertEx( self.goalheight == 80, "Tried to set goalheight on guy with export " + self.export + " before running spawn_failed on the guy." );
	// AI is moving to a goal node
	if (isdefined (node.height))
		self.goalheight = node.height;
	else
		self.goalheight = level.default_goalheight;
	
	self setgoalnode(node);

	if ( node.radius != 0 )
		self.goalradius = node.radius;
	else
		self.goalradius = level.default_goalradius;

/*
	// done with script_goalvolume now
	if ( isdefined( volume ) )
	{
		// AI is moving to a goal volume
		self setgoalvolume( volume );
	}
*/
		
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

		nextNode_array = getnodearray(node.target,"targetname");
		if (nextNode_array.size > 0)
			nextNode = nextNode_array[ randomint(nextNode_array.size)];
		else
			nextNode = undefined;

		if (isdefined(nextNode))
		{
			self waittill ("goal");
			for (;;)
			{
				node script_delay();
				node = nextNode;
				if (node.radius != 0)
					self.goalradius = node.radius;
				self setgoalnode (node);
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
		// use the override from radiant
		self.goalradius = self.script_radius;
		return;
	}

	if ( isDefined( self.script_forcegoal ) )
	{
		if ( isdefined( node ) && isdefined( node.radius ) )
		{
			// use the node's radius
			self.goalradius = node.radius;
			return;
		}
	}

	// otherwise use the script default
	self.goalradius = level.default_goalradius;
}

reached_end_of_node_chain( node )
{
	self setgoalnode(node);
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

// this is called from two places w/ generally identical code... maybe larger scale cleanup is called for.
use_a_turret( turret )
{
	if ( self.team == "axis" && self.health == 150 )
	{
		self.health = 100; // mg42 operators aren't going to do long death
		self.a.disableLongDeath = true;
	}

//	thread maps\_mg_penetration::gunner_think( turret );
		
	self useturret(turret); // dude should be near the mg42
//	turret setmode("auto_ai"); // auto, auto_ai, manual
//	turret settargetentity( level.player );
//	turret setmode( "manual" ); // auto, auto_ai, manual
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
//				turret setmode( "manual_ai" ); // auto, auto_ai, manual
				self thread maps\_mgturret::manual_think( turret );
//				if (isdefined (self.script_mg42auto))
//					println ("AI at origin ", self.origin , " has script_mg42auto");
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
		if (getdvar ("fallback") == "1")
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
	self waittill( "goal" );

	if ( node.radius != 0 )
		self.goalradius = node.radius;
	else
		self.goalradius = level.default_goalradius;
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
	//level.totalfriends = 0;
	if ( !isdefined(level.friendlywave_force_color) )
		level.friendlywave_force_color = [];

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


				else if(!script_delay)
					num = randomint (spawn.size);
				else if(num == spawn.size)
					num = 0;

				if ( level.friendlywave_force_color.size > 0 )
				{
					// find a color spawner of the same color as the dead guy.
					// if none exist use the old random spawner.

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
					// spawn succeeded get rid of used force_color.
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

	self.ignoresuppression = true;

	self waittill ("goal");
	self.goalradius = self.oldradius;
	if (self.goalradius < 32)
		self.goalradius = 400;

//	println ("^3 my goal radius is ", self.goalradius);
	self.ignoresuppression = false;

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

//	self thread maps\_mgturret::mg42_firing(mg42);
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
//	ai.exception_exposed = animscripts\combat::exception_exposed_panzer_guy;
//	ai.exception_stop = animscripts\combat::exception_exposed_panzer_guy;
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



flood_and_secure( instantRespawn )
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
		script_noteworth "instant_respawn" on the trigger will disable the wave respawning
	*/
	
	// Instantrespawn disables wave respawning or waiting for time to pass before respawning
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
				// Non squad AI are not allowed to spawn enemies
				continue;
			}
		}
		
		// Reacquire spawners in case one has died/been deleted and moved up to another
		// because spawners can target other spawners that are used when the first spawner dies.
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
	selection = randomint (2);//add loop to find largest value
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
		// Multiple triggers can trigger a flood and secure spawner, but they need to run
		// their logic just once so we exit out if its already running.
		return;
	}

	self.secureStarted = true;
	self.triggerUnlocked = true; // So we don't run auto targetting behavior
	
	mg42 = issubstr(self.classname, "mgportable") || issubstr(self.classname, "30cal");
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
			spawn = self stalingradSpawn();
		else
			spawn = self doSpawn();
			
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
//			self delete();
			// Do damage instead of delete so he counts as "killed" and we dont have to write 
			// stuff to let the spawner know to stop trying to spawn him.
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
		if (self.script_displaceable != 0) // 0 means explicitly told not to do displace behavior
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
	level.player set_friendly_chain_wrapper(node);
	level notify ("new_escort_trigger"); // stops escorting guy from getting back on escort chain 
	level notify ("new_escort_debug");
	level notify ("start_chain", rejoin); // get the SMG guy back on the friendly chain
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


// flood_spawner

flood_trigger_think( trigger )
{
	assertEX( isDefined( trigger.target ), "flood_spawner without target" );
	
	floodSpawners = getEntArray( trigger.target, "targetname" );
	assertEX( floodSpawners.size, "flood_spawner at with target " + trigger.target + " without any targets" );
	
	array_thread( floodSpawners, ::flood_spawner_init );
	
	trigger waittill ( "trigger" );
	// reget the target array since targets may have been deletes, etc... between initialization and triggering
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
	self endon("death");
	self notify ("stop current floodspawner");
	self endon ("stop current floodspawner");

	// pyramid spawner is a spawner that targets another spawner or spawners
	// First the targetted spawners spawn, then when they die, the reinforcement spawns from
	// the spawner this initial spawner
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

		// soldier was deleted, not killed
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
	
	// first spawn all the guys we target. They decrement our count tho, so we spawn them in a random order in case 
	// our count is just 1 ( default )
	
	spawners = getentarray( self.target, "targetname" );
	/#
		for ( i=0; i < spawners.size; i++ )
			assertEx( issubstr( spawners[i].classname, "actor" ), "Pyramid spawner targets non AI!" );
	#/
	
	// the spawners have to report their death to the head of the pyramid so it can kill itself when they're all gone
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
		
		// the count is local to self, not to the spawners that are targetted
		spawner.count = 1;
		
		soldier = spawner spawn_ai();
		if ( spawn_failed( soldier ) )
		{
//			assertEx( 0, "Initial spawning from spawner at " + self.origin + " failed." );
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
			// cleanup in case any spawners were deleted
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
			
			// find a spawner that has lost its AI
			if ( isalive( spawner.spawn ) )
				continue;
	
			// spawn from self now, we're reinforcement			
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

	// triggers with a script_radius of -1 dont override the goalradius
	// triggers with a script_radius of anything else set the goalradius to that size
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

	// expands the goalradius of the ai after they reach there initial goal.
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
	// wait until regular scripts have a change to set self.script_nohealth on the guy from script, after spawn_failed.
	waittillframeend;
	waittillframeend;

	if ( !isalive( self ) )
		return;
	
	if ( isdefined( self.script_nohealth ) )
		return;
	
	self waittill ("death");
	
	if (!isdefined (self))
		return;
		
	// drop health disabled once again
	if ( 1 )
		return;
		

	// has enough time passed since the last health drop?
	if ( gettime() < level.next_health_drop_time )
		return;
		
	// have enough guys died?
	level.guys_to_die_before_next_health_drop--;
	if ( level.guys_to_die_before_next_health_drop > 0 )
		return;
	
	level.guys_to_die_before_next_health_drop = randomintrange( 2, 5 );
	level.next_health_drop_time = gettime() + 3500; // probably make this a _gameskill thing later
	
	trace = bullettrace(self.origin + (0,0,50), self.origin + (0,0,-220), true, self);
	health = spawn( "script_model", self.origin + (0,0,10) );
	health.origin = trace[ "position" ];
	health setmodel( "com_trashbag" );
	
	trigger = spawn( "trigger_radius", self.origin + (0,0,10), 0, 10, 32 );
	trigger.radius = 10;

	trigger drop_health_trigger_think();	
	
	trigger delete();
	health delete();
	

//	health = spawn("item_health", self.origin + (0,0,10));
//	health.angles = (0, randomint(360), 0);

	/*
	if (isdefined (level._health_queue))
	{
		if (isdefined (level._health_queue[level._health_queue_num]))
			level._health_queue[level._health_queue_num] delete();
	}

	level._health_queue[level._health_queue_num] = health;
 	level._health_queue_num++;
 	if (level._health_queue_num > level._health_queue_max)
	 	level._health_queue_num = 0;
	 */
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
	// get a random target and all the links to that target and spawn them
	spawners = getentarray( trigger.target, "targetname" );
	if ( !spawners.size )
		return;
	spawner = random( spawners );
	
	spawners = [];
	spawners[ spawners.size ] = spawner;
	// grab the other spawners linked to the parent spawner
	if ( isdefined( spawner.script_linkto ) )
	{
		links = strTok( spawner.script_linkto, " " );
		for ( i=0; i < links.size; i++ )
		{
			spawners[ spawners.size ] = getent( links[ i ], "script_linkname" );
		}
	}

	waittillframeend; // _load needs to finish entirely before we can add spawn functions to spawners	
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
	// ai placed in the level run their spawn func before the triggers are initialized
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
//	drone hide();
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
	//for later use to makerealai
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