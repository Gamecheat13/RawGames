#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	level.friendlyDogModel = "german_shepherd";
	level.enemyDogModel = "german_shepherd_black";

	precacheModel(level.friendlyDogModel);
	precacheModel(level.enemyDogModel);
	precacheItem("dog_bite_mp");
	precacheShellshock("dog_bite");

	level.maxDogsAttackingPerPlayer = 2;
	level.spawnTimeWaitMin = 2;
	level.spawnTimeWaitMax = 5;
		
	level.no_dogs = false;
		
	init_node_arrays();
	
	if ( !isdefined( level.pathnodes ) || level.pathnodes.size == 0 )
		level.no_dogs = true;

	regenTime = 5;
	level.dogHealth_RegularRegenDelay = regenTime * 1000;
	level.dogHealthRegenDisabled = (level.dogHealth_RegularRegenDelay <= 0);

	dog_dvar_update();
	thread dog_dvar_updater();
	thread dog_usage_init();
	
	thread init_all_preexisting_dogs();

//	create_dogs();
}

pick_random_nodes( from, count )
{
	to = [];
	
	if ( from.size < count )
	{
		to = from;
	}
	else
	{
		for ( i = 0; i < count; i++ )
		{
			to[i] = from[randomInt(from.size)];
		}
	}
	
	return to;
}

init_node_arrays()
{
	nodes = getallnodes();

	level.pathnodes = [];
	
	for ( i = 0; i < nodes.size; i++ )
	{
		// anything with a scriptworthy is automatically a non-patrol node
		if ( isdefined(nodes[i].script_noteworthy) /* || nodes[i].script_noteworthy != "" */)
			continue;
			
		if ( isdefined(nodes[i].targetname) && nodes[i].targetname == "traverse" )
			continue;
			
		level.pathnodes[level.pathnodes.size] = nodes[i]; 
	} 

	level.dogspawnnodes = [];
	level.dogspawnnodes = getnodearray( "spawn", "script_noteworthy");
	
	if ( level.dogspawnnodes.size == 0 )
	{
/#
		println("DOG PATHING:  Could not find spawn nodes");
#/		
		// pick a random set of spawn nodes so we do not tax the spawn logic to much
		level.dogspawnnodes = pick_random_nodes( level.pathnodes, 20 );
	}
	
	level.dogexitnodes = [];
	level.dogexitnodes = getnodearray( "exit", "script_noteworthy");
	
	if ( level.dogexitnodes.size == 0 )
	{
/#
		println("DOG PATHING:  Could not find exit nodes");
#/
		// pick a random set of spawn nodes so we do not tax the spawn logic to much
		level.dogexitnodes = pick_random_nodes( level.pathnodes, 20 );
	}
}

dog_dvar_update()
{
	level.dog_time = dog_get_dvar_int("scr_dog_time", "60" );
	level.dog_health = dog_get_dvar_int("scr_dog_health", "100" );
	level.dog_count = dog_get_dvar_int("scr_dog_count", "8" );
	level.dog_count_max_at_once = dog_get_dvar_int("scr_dog_max_at_once", "4" );
	
	if ( level.dog_count < level.dog_count_max_at_once )
	{
		level.dog_count_max_at_once = level.dog_count;
	}
		
	level.dog_debug = dog_get_dvar_int("debug_dogs", "0" );
	level.dog_debug_sound = dog_get_dvar_int("debug_dog_sound", "0" );
	level.dog_debug_anims = dog_get_dvar_int("debug_dog_anims", "0" );
	level.dog_debug_anims_ent = dog_get_dvar_int("debug_dog_anims_ent", "0" );
	level.dog_debug_turns = dog_get_dvar_int("debug_dog_turns", "0" );
	level.dog_debug_orient = dog_get_dvar_int("debug_dog_orient", "0" );
	level.dog_debug_usage = dog_get_dvar_int("debug_dog_usage", "1" );
}

dog_dvar_updater()
{
	dogs_in_the_bsp = count_preexisting_dogs();
	while(1)
	{
		dog_dvar_update();
		
		// 16 is max allowed by engine
		if ( level.dog_count + dogs_in_the_bsp > 16 )
		{
			level.dog_count = 16 - dogs_in_the_bsp;
		}
		wait (1);
	}
}

count_preexisting_dogs()
{
		dogs = getentarray( "actor_enemy_dog", "classname" );
		
	 	alive_count = 0;
	 	for ( i = 0; i < dogs.size; i ++ )
	 	{
	 		if ( !isdefined(dogs[i]) )
	 			continue;
	 			
	 		if ( !isai(dogs[i]) )
	 			continue;
	 			
	 		alive_count++;
	 	}	
	 	
	 	return alive_count;
}

init_all_preexisting_dogs()
{
	array_thread( getentarray( "actor_enemy_dog", "classname" ), ::preexisting_init_dog );
}

preexisting_init_dog()
{
	self init_dog();
}

dog_set_model()
{
//	if ( self.aiteam == "allies" )
//	{
//		self setModel("german_shepherd_white");
////		self setModel("german_shepherd");
//	}
//	else
//	{
//		// axis or free
//		self setModel("german_shepherd_black");
//	}
	self setModel(level.friendlyDogModel);
	self setEnemyModel(level.enemyDogModel);
}

init_dog()
{
	if ( !isai(self) )
		return;

	// assign teams for AI that are already in the map
//	if ( level.teambased )
	{
		self.aiteam = "axis";
	}
//	else
//	{
//		self.aiteam = "free";		
//	}
	
	self.animTree = "dog.atr";
	self.type = "dog";
	self.accuracy = 0.2;
	self.health = level.dog_health;
	self.maxhealth = level.dog_health;  // this currently does not hook to code maxhealth
	self.aiweapon = "dog_bite_mp";
	self.secondaryweapon = "";
	self.sidearm = "";
	//self.grenadeWeapon = "";
	self.grenadeAmmo = 0;
	self.goalradius = 128;
//	self.goalheight = 120;
	self.noDodgeMove = true;
	self.ignoreSuppression = true;
	self.suppressionThreshold = 1;
	self.disableArrivals = false;
	self.pathEnemyFightDist = 512;

	self.meleeAttackDist = 102; 

//	self setEngagementMinDist( 256.000000, 0.000000 );
//	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self dog_set_model();

	self thread dogHealthRegen();
	
	self thread selfDefenseChallenge();
}

get_spawn_node( team )
{
	if ( !level.teambased )
		return dog_pick_node_away_from_enemy(level.dogspawnnodes, team);
		 
	return dog_pick_node_near_team(level.dogspawnnodes, team);
}

dog_watch_for_owner_team_change(owner)
{
	self endon("death");
	owner endon("disconnect");
	
	while(1)
	{
		owner waittill("joined_team");
		
		if ( owner.pers["team"] != self.aiteam )
		{
			self clearentityowner();
			self notify("clear_owner");
			return;
		}
	}
}

dog_set_owner( owner, team )
{
/#
	// no owner so he attacks the person who called him in
	if ( level.dog_debug )
		return;
#/

	if ( !isdefined( owner ) )
		return;
		
	// if the owner switches teams while dogs are still spawning
	// do not set the owner 
	if ( level.teambased && isplayer(owner) && owner.pers["team"] != team )
		return;
		
	self setentityowner(owner);
	
	self.requiredDeathCount = owner.deathCount;
	
	self thread dog_watch_for_owner_team_change(owner);
	
	self endon("death");
	owner waittill("disconnect");
	
	self clearentityowner();
}

dog_create_spawn_influencer()
{
	self maps\mp\gametypes\_spawning::create_dog_influencers();
}

dog_manager_spawn_dog( owner, team, spawn_node, index )
{
	dog = level.dog_spawner spawnactor();
	
	dog forceteleport(spawn_node.origin, spawn_node.angles);
	dog setgoalnode( spawn_node );
	dog.spawnnode = spawn_node;
	dog show();
	
	dog init_dog();
	dog dog_set_team(team);	
	dog dog_set_model();
	dog dog_create_spawn_influencer();
	dog thread dog_set_owner(owner, team);

	dog thread dog_usage(index);
	dog thread dog_owner_kills();
	dog thread dog_clean_up();
	dog thread dog_notify_level_on_death();
	dog dog_thread_behavior_function();
	
		
	return dog;
}

get_debug_team( team )
{	
/#
	if ( level.teambased )
	{
		otherteam = getotherteam(team);
		if ( level.dog_debug )
			return otherteam;
	}
#/

	if ( !level.teambased )
		return "free";
		
	return team;
}

dog_manager_spawn_dogs( team, enemyTeam )
{
	// this can hit if the round ends as the dogs are getting called in
	level endon("dogs done");
	level endon("dogs leaving");
	self endon("disconnect");
	
	if ( level.no_dogs )
		return;
		
	team = get_debug_team(team);
	
	level.dog_spawner = getent("dog_spawner","targetname" );
	
	if ( !isdefined( level.dog_spawner ) )
		return;
	
	level.dogs = [];

	level thread dog_manager_game_ended();
	level thread dog_manager_dog_alive_tracker();

	thread dog_usage_monitor();
	for ( i = 0; i < level.dog_count_max_at_once; i++ )
	{
		node = self get_spawn_node( team );

		level.dogs[i] = dog_manager_spawn_dog( self, team, node, i );
		
		wait ( randomfloat( level.spawnTimeWaitMin, level.spawnTimeWaitMax ) );
	}
	
	level thread dog_manager_dog_time_limit();

	level thread dog_manager_spawn_more_dogs_on_death( self, level.dog_count - level.dog_count_max_at_once, team );
}
 
dog_manager_spawn_more_dogs_on_death( owner, count, team )
{
	level endon("dogs done");
	level endon("dogs leaving");

	while( count > 0 )
	{
		level waittill("dog died");
	
		// wait a bit before sending in the next dog
		wait ( randomfloat( level.spawnTimeWaitMin, level.spawnTimeWaitMax ) );
		
		node = get_spawn_node( team );
		level.dogs[level.dogs.size] = dog_manager_spawn_dog( owner, team, node, level.dogs.size );
		count -= 1;
	} 
	
/#
	iprintln("All dogs spawned");
#/
	level notify("all dogs spawned");
}

dog_manager_dog_time_limit()
{
	level endon("dogs done");
	level endon("dogs leaving");
	wait( level.dog_time );

/#
	dog_debug_print( "time limit hit notify dogs leaving" );
#/	
	// this will shut this thread down
	level notify("dogs leaving");
}

dog_cleanup_wait( wait_for, notify_name )
{
	self endon( notify_name );
	self waittill( wait_for );
	self notify( notify_name, wait_for ); 
}

dog_cleanup_waiter()
{
	self thread dog_cleanup_wait( "all dogs spawned", "start_tracker");
	self thread dog_cleanup_wait( "dogs leaving", "start_tracker" );

	self waittill( "start_tracker", wait_for );
/#
	self dog_debug_print("starting dog_manager_dog_alive_tracker reason " + wait_for );
#/
}

dog_manager_dog_alive_tracker()
{
	level dog_cleanup_waiter();
	
	while (1)
	{
	 	alive_count = 0;
	 	for ( i = 0; i < level.dogs.size; i ++ )
	 	{
	 		if ( !isdefined(level.dogs[i]) )
	 			continue;
	 			
	 		if ( !isalive(level.dogs[i]) )
	 			continue;
	 			
	 		alive_count++;
	 	}	
	 	
	 	if ( alive_count == 0 )
	 	{
 			wait(1);
	 		dog_manager_delete_dogs();
	 		level notify("dogs done");
	 		return;
		}	 	
		
		wait (1);
	}
}

dog_manager_delete_dogs()
{
		for ( i = 0; i < level.dogs.size; i ++ )
	 	{
	 		if ( !isdefined(level.dogs[i]) )
	 			continue;
	 			
	 		level.dogs[i] delete();
		} 	

		level.dogs = undefined;
}

dog_manager_game_ended()
{
	level waittill("game_ended");
	make_all_dogs_leave();
}

make_all_dogs_leave()
{
/#
	dog_debug_print( "make_all_dogs_leave notify dogs leaving" );
#/	
	level notify("dogs leaving");
}

dog_set_team( team )
{
	self.aiteam = team;
}

dog_clean_up()
{
	self endon("death");
	self endon("leaving");
	level waittill("dogs leaving");
	
	thread dog_leave();
}

dog_notify_level_on_death()
{
	self endon("leaving");
	self waittill("death");
	
	// do not access self past this point as its not valid
	
	level notify("dog died");
}

dog_thread_behavior_function()
{
		self thread dog_patrol_when_no_enemy();
//		self thread dog_attack_when_enemy();
}

dog_leave()
{
	self notify("leaving");

	self thread dog_leave_failsafe();
	
	// have them run to an exit node
	self clearentitytarget();
	self.ignoreall = true;
	self.goalradius = 30;
	self setgoalnode( self dog_get_exit_node() );
	
	self waittill("goal");
	self delete();
}

dog_leave_failsafe()
{
	self endon("death");

	start_origin = self.origin;
	
	wait(2);
	
	if ( distance( start_origin, self.origin ) < 10 )
	{
/#
		println( "DOG DELETE FAILSAFE:  Dog appears to be stuck at " + self.origin );
#/
		self delete();
		return;
	}	
	
	wait(20);
/#
	println( "DOG DELETE FAILSAFE:  Dog has not gotten to it's delete point after 20 seconds.  Currently at " + self.origin );
#/
	self delete();
}


dog_patrol_when_no_enemy()
{
	self endon("death");
	self endon("leaving");
	
	while(1)
	{
		if ( !isdefined(self.enemy) )
		{
			self dog_debug_print( "no enemy starting patrol" );
			self thread dog_patrol();	
		}

		self waittill("enemy");	
	}	
}

dog_patrol_wait( wait_for, notify_name )
{
	self endon("attacking");
	dog_wait( wait_for, notify_name );
}

dog_wait( wait_for, notify_name )
{
	self endon("death");
	self endon("leaving");
	self endon( notify_name );

	self waittill( wait_for );
	self notify( notify_name, wait_for ); 
}

dog_patrol_path_waiter()
{
	self thread dog_patrol_wait( "bad_path", "next_patrol_point");
	self thread dog_patrol_wait( "goal", "next_patrol_point" );

	self waittill( "next_patrol_point", wait_for );
/#
	self dog_debug_print("ending patrol wait recieved " + wait_for );
#/
}

dog_patrol()
{
	self endon("death");
	self endon("enemy");
	self endon("leaving");
	self endon("attacking");
	self notify("on patrol");
	
	self dog_patrol_debug();
	
	while(1)
	{
		node = level.pathnodes[randomInt(level.pathnodes.size)];
		
		// ignore all nodes with a script_noteworthy on them
		if ( !isdefined( node.script_noteworthy ) )
		{
/#
			self dog_debug_print("patroling to node at " + node.origin );
#/
			self setgoalnode( node );
			self dog_patrol_path_waiter();
		}
	}	
}

dog_wait_print( wait_for )
{
/#
	self endon("kill dog_wait_prints");

	self waittill( wait_for );
	self notify("kill dog_wait_prints");
	self dog_debug_print( "PATROL ENDING " + wait_for );
#/
}

dog_patrol_debug()
{
	self thread dog_wait_print("death");
	self thread dog_wait_print("enemy");
	self thread dog_wait_print("leaving");
	self thread dog_wait_print("attacking");
}

//dog_attack_path_waiter( attack_ent )
//{
//	self thread dog_wait( "bad_path", "next_enemy");
////	self thread dog_wait( "goal", "next_enemy" );
//	self thread dog_wait( "enemy", "next_enemy" );
//	attack_ent thread dog_wait( "death", "next_enemy" );
//
//	self waittill( "next_enemy", wait_for );
///#
//	self dog_debug_print("ending attack wait recieved " + wait_for );
//#/
//}
//
//dog_attack_when_enemy()
//{
//	self endon("death");
//	self endon("leaving");
//	
//	while(1)
//	{
//		if ( !isdefined(self.enemy) )
//		{
//			attack_ent = self dog_attack_find_enemy();
//			if ( isdefined( attack_ent ) )
//			{
///#
//				self dog_debug_print("attacking enemy " + attack_ent getentnum() );
//#/
//				self dog_attack_enemy( attack_ent );
//				self dog_attack_path_waiter( attack_ent );
///#
//				self dog_debug_print("done attacking enemy " + attack_ent getentnum() );
//#/
//			}
//		}
//		wait(1);
//	}	
//}
//
//dog_attack_enemy( player )
//{
//	self setenemy( player );
//	self notify("attacking");
//}
//
//dog_attack_find_enemy()
//{
//	team = self.aiteam;
//	otherteam = getotherteam( team );
//	
//	if ( !isdefined(level.alivePlayers) )
//		return;
//	
//	players = level.alivePlayers[otherteam];
//	
//	if ( !isdefined(players) )
//		return;
//	
//	self dog_calc_player_enemy_count(players);
//	
//	players = get_array_of_closest( self.origin, players );
//	for ( i = 0; i < players.size; i++ )
//	{
//		if ( players[i].dogsCurrentlyAttacking >= level.maxDogsAttackingPerPlayer )
//			continue;
//			
//		if ( !isalive(players[i] ) )
//			continue;
//		if ( !(self istargetable(players[i])) )
//			continue;
//			
//		return players[i];
//	}
//}
//
//dog_calc_player_enemy_count( players )
//{
//	for ( i = 0; i < level.players.size; i++ )
//	{
//		level.players[i].dogsCurrentlyAttacking = 0;
//	}
//	
//	// need this for the test level dog
//	if ( !isdefined(level.dogs) )
//		return;
//		
//	for ( i = 0; i < level.dogs.size; i++ )
//	{
//		dog = level.dogs[i];
//		enemy = dog.enemy;
//		
//		if ( !isalive( dog ) )
//			continue;
//			
//		if ( !isdefined( enemy ) )
//			continue;
//		
//		enemy.dogsCurrentlyAttacking++;
//	}
//}

dog_get_dvar_int( dvar, def )
{
	return int( dog_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
dog_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

dog_usage_init()
{
	level.dog_usage = [];
	
	for ( index = 0; index < level.dog_count; index++ )
	{
		level.dog_usage[index] = spawnStruct();
		level.dog_usage[index].spawn_time = 0;
		level.dog_usage[index].death_time = 0;
		level.dog_usage[index].kills = 0;
		level.dog_usage[index].died = false;
	}
}

dog_usage_monitor()
{
	start_time = GetTime();
	
	level waittill("dogs done");

	index = 0;
	total_kills = 0;
	last_alive = 0;
	all_dead = true;
	alive_count = 0;
	never_spawned_count = 0;
	total_count = 0;
	
	for ( index = 0; index < level.dog_count; index++ )
	{
		total_count++;
		
		if ( level.dog_usage[index].spawn_time == 0 )
		{
			never_spawned_count++;
			continue;
		}
		else if ( !level.dog_usage[index].died )
		{
			alive_count++;
			all_dead = false;
		}		
		
		seconds = (level.dog_usage[index].death_time - level.dog_usage[index].spawn_time) / 1000;
		if ( seconds > last_alive )
		{
			last_alive = seconds;
		}		
		
		total_kills += level.dog_usage[index].kills;
	}	
	
/#
	seconds = (GetTime() - start_time) / 1000;
	msg = "Dogs- Time: " + seconds + " Kills: " + total_kills + " Last: " + last_alive;
	
	// make sure that the dogs have printed everything
	wait (1);
	iprintln( msg );
	println( msg );
#/
}

dog_usage(index)
{
	level.dog_usage[index].spawn_time = GetTime();
	level.dog_usage[index].death_time = 0;
	level.dog_usage[index].kills = 0;
	level.dog_usage[index].died = false;
	
	self thread dog_usage_kills(index);
	self thread dog_usage_time_alive(index);
}

dog_usage_kills(index)
{
	self endon("death");
	
	while(1)
	{
		self waittill("killed", player);
		level.dog_usage[index].kills++;
	}	
}

dog_owner_kills(index)
{
	if ( !isdefined( self.script_owner ) )
		return;
		
	self endon("clear_owner");
	self endon("death");
	self.script_owner endon("disconnect");
	
	while(1)
	{
		self waittill("killed", player);
		self.script_owner notify( "dog_handler" );
	}	
}

dog_usage_time_alive(index)
{
	self endon("leaving");

	self waittill("death");
	level.dog_usage[index].death_time = GetTime();
	level.dog_usage[index].died = true;
	
	seconds = (level.dog_usage[index].death_time - level.dog_usage[index].spawn_time) / 1000 ;
/#
	iprintln( "Dog#" + index + " killed. Alive for: "+ seconds + " seconds. Kills: " + level.dog_usage[index].kills );
	println( "Dog#" + index + " killed. Alive for: "+ seconds + " seconds. Kills: " + level.dog_usage[index].kills );	
#/
}


dogHealthRegen()
{
	self endon("death");
	self endon("end_healthregen");
	
	if ( self.health <= 0 )
	{
		assert( !isalive( self ) );
		return;
	}
	
	maxhealth = self.health;
	oldhealth = maxhealth;
	dog = self;
	health_add = 0;
	
	regenRate = 0.1; // 0.017;
	veryHurt = false;
	
	lastSoundTime_Recover = 0;
	hurtTime = 0;
	newHealth = 0;
	
	for (;;)
	{
		wait (0.05);
		if (dog.health == maxhealth)
		{
			veryHurt = false;
			continue;
		}
					
		if (dog.health <= 0)
			return;

		wasVeryHurt = veryHurt;
		ratio = dog.health / maxHealth;
		if (ratio <= 0.55)
		{
			veryHurt = true;
			if (!wasVeryHurt)
			{
				hurtTime = gettime();
			}
		}
			
		if (dog.health >= oldhealth)
		{
			if (gettime() - hurttime < level.dogHealth_RegularRegenDelay)
				continue;
			
			if ( level.dogHealthRegenDisabled )
				continue;

			if (veryHurt)
			{
				newHealth = ratio;
				if (gettime() > hurtTime + 3000)
					newHealth += regenRate;
			}
			else
				newHealth = 1;
							
			if ( newHealth >= 1.0 )
			{
				newHealth = 1.0;
			}
				
			if (newHealth <= 0)
			{
				// dog is dead
				return;
			}
			
			dog setnormalhealth (newHealth);
			oldhealth = dog.health;
			continue;
		}

		oldhealth = dog.health;
			
		health_add = 0;
		hurtTime = gettime();
	}
}


selfDefenseChallenge()
{
	self waittill ("death", attacker);

	if ( isdefined( attacker ) && isPlayer( attacker ) )
	{
		if (isdefined ( self.script_owner ) && self.script_owner == attacker)
			return;
		if ( level.teambased && isdefined ( self.script_owner ) && self.script_owner.team == attacker.team )
			return;

		attacker notify ("selfdefense_dog");	
	}
		
}

dog_get_exit_node()
{
	return getclosest( self.origin, level.dogexitnodes );
}

dog_debug_print( message )
{
/#
	if ( level.dog_debug )
	{
		if ( isai( self ) )
		{
			println( " " + gettime() + " DOG " + self getentnum() + ": " + message );
		}
		else
		{
			println( " " + gettime() + " DOGS: " + message );
		}
	}
#/
}

// ================================================

getAllOtherPlayers()
{
	aliveplayers = [];

	// Make a list of fully connected, non-spectating, alive players
	for(i = 0; i < level.players.size; i++)
	{
		if ( !isdefined( level.players[i] ) )
			continue;
		player = level.players[i];
		
		if ( player.sessionstate != "playing" || player == self )
			continue;

		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}

dog_pick_node_near_team( nodes, team )
{
	// There are no valid nodes in the map
	if(!isdefined(nodes))
		return undefined;
		
	if ( !level.teambased )
		return dog_pick_node_away_from_enemy(level.dogspawnnodes, team);
		
	//prof_begin("basic_spawnlogic");
	
	initWeights(nodes);
	update_all_nodes( nodes, team );

	//prof_begin(" getteams");
	obj = spawnstruct();
	getAllAlliedAndEnemyPlayers(obj, team);
	//prof_end(" getteams");
	
	numplayers = obj.allies.size + obj.enemies.size;
	
	alliedDistanceWeight = 2;
	dogDistanceWeight = 3;
	
	//prof_begin(" sumdists");
	myTeam = team;
	
	enemyTeam = getOtherTeam( myTeam );
	for (i = 0; i < nodes.size; i++)
	{
		node = nodes[i];

		node.weight = 0;

		if ( node.numPlayersAtLastUpdate > 0 )
		{
			allyDistSum = node.distSum[ myTeam ];
			enemyDistSum = node.distSum[ enemyTeam ];
			
			// high enemy distance is good, high ally distance is bad
			node.weight = (enemyDistSum - alliedDistanceWeight*allyDistSum) / node.numPlayersAtLastUpdate;
		}
		
		if ( node.numDogsAtLastUpdate > 0 )
		{
			dogDistSum = node.distSum[ "dogs" ];
			
			// high ally distance is bad
			node.weight -= (dogDistSum*dogDistSum) / node.numDogsAtLastUpdate;	
		}
	}
	//prof_end(" sumdists");
	
	//prof_end("basic_spawnlogic");

	//prof_begin("complex_spawnlogic");

	avoidSpawnReuse(nodes);
	avoidEnemies(nodes, team, true);
	
	//prof_end("complex_spawnlogic");

	result = dog_pick_node_final(nodes, team, obj.enemies);
	
	return result;
}


dog_pick_node_away_from_enemy(nodes, team)
{
	// There are no valid nodes in the map
	if(!isdefined(nodes))
		return undefined;
	
	initWeights(nodes);
	update_all_nodes( nodes, team );

	aliveplayers = getAllOtherPlayers();
	
	// new logic: we want most players near idealDist units away.
	// players closer than badDist units will be considered negatively
	idealDist = 1600;
	badDist = 1200;
	
	if (aliveplayers.size > 0)
	{
		for (i = 0; i < nodes.size; i++)
		{
			totalDistFromIdeal = 0;
			nearbyBadAmount = 0;
			for (j = 0; j < aliveplayers.size; j++)
			{
				dist = distance(nodes[i].origin, aliveplayers[j].origin);
				
				if (dist < badDist)
					nearbyBadAmount += (badDist - dist) / badDist;
				
				distfromideal = abs(dist - idealDist);
				totalDistFromIdeal += distfromideal;
			}
			avgDistFromIdeal = totalDistFromIdeal / aliveplayers.size;
			
			wellDistancedAmount = (idealDist - avgDistFromIdeal) / idealDist;
			
			// wellDistancedAmount is between -inf and 1, 1 being best (likely around 0 to 1)
			// nearbyBadAmount is between 0 and inf,
			// and it is very important that we get a bad weight if we have a high nearbyBadAmount.
			
			nodes[i].weight = wellDistancedAmount - nearbyBadAmount * 2 + randomfloat(.2);
		}
	}
	
	avoidSpawnReuse(nodes);
	avoidEnemies(nodes, team, true);
	
	return dog_pick_node_final(nodes, team, aliveplayers);
}

dog_pick_node_random( nodes, team )
{
	// There are no valid nodes in the map
	if(!isdefined(nodes))
		return undefined;

	// randomize order
	for(i = 0; i < nodes.size; i++)
	{
		j = randomInt(nodes.size);
		node = nodes[i];
		nodes[i] = nodes[j];
		nodes[j] = node;
	}
	
	return dog_pick_node_final(nodes, team, undefined, false);
}

// selects a node, preferring ones with heigher weights (or toward the beginning of the array if no weights).
// also does final things like setting self.lastnode to the one chosen.
// this takes care of avoiding telefragging, so it doesn't have to be considered by any other function.
dog_pick_node_final( nodes, team, enemies, useweights )
{
	//prof_begin( "dog_pick_node_final" );
	
	bestnode = undefined;
	
	if ( !isdefined( nodes ) || nodes.size == 0 )
		return undefined;
	
	if ( !isdefined( useweights ) )
		useweights = true;
	
	if ( useweights )
	{
		// choose node with best weight
		// (if a tie, choose randomly from the best)
		bestnode = getBestWeightedNode( nodes, team, enemies );
	}
	else
	{
		// (only place we actually get here from is dog_pick_node_random() )
		// no weights. prefer nodes toward beginning of array
		for ( i = 0; i < nodes.size; i++ )
		{
			if ( positionWouldTelefrag( nodes[i].origin ) )
				continue;
			
			bestnode = nodes[i];
			break;
		}
	}
	
	if ( !isdefined( bestnode ) )
	{
		// couldn't find a useable node! all will telefrag.
		if ( useweights )
		{
			// at this point, forget about weights. just take a random one.
			bestnode = nodes[randomint(nodes.size)];
		}
		else
		{
			bestnode = nodes[0];
		}
	}
	
	self finalizeNodeChoice( bestnode );
	
	//prof_end( "dog_pick_node_final" );

	return bestnode;
}

getBestWeightedNode( nodes, team, enemies )
{
	maxSightTracedNodes = 3;
	for ( try = 0; try <= maxSightTracedNodes; try++ )
	{
		bestnodes = [];
		bestweight = undefined;
		bestnode = undefined;
		for ( i = 0; i < nodes.size; i++ )
		{
			if ( !isdefined( bestweight ) || nodes[i].weight > bestweight ) 
			{
				if ( positionWouldTelefrag( nodes[i].origin ) )
					continue;
				
				bestnodes = [];
				bestnodes[0] = nodes[i];
				bestweight = nodes[i].weight;
			}
			else if ( nodes[i].weight == bestweight ) 
			{
				if ( positionWouldTelefrag( nodes[i].origin ) )
					continue;
				
				bestnodes[bestnodes.size] = nodes[i];
			}
		}
		if ( bestnodes.size == 0 )
			return undefined;
		
		// pick randomly from the available nodes with the best weight
		bestnode = bestnodes[randomint( bestnodes.size )];
		
		if ( try == maxSightTracedNodes )
			return bestnode;
		
		if ( isdefined( bestnode.lastSightTraceTime ) && bestnode.lastSightTraceTime == gettime() )
			return bestnode;
		
		if ( !lastMinuteSightTraces( bestnode, team, enemies ) )
			return bestnode;
		
		penalty = getLosPenalty();
		bestnode.weight -= penalty;
		
		bestnode.lastSightTraceTime = gettime();
	}
}

finalizeNodeChoice( node )
{
	time = getTime();
	
	self.lastnode = node;
	self.lastspawntime = time;
	node.lastspawneddog = self;
	node.lastspawntime = time;
}

getLosPenalty()
{
	return 100000;
}

lastMinuteSightTraces( node, dog_team, enemies )
{
	//prof_begin("lastMinuteSightTraces");
	
	team = "all";
	if ( level.teambased )
		team = getOtherTeam( dog_team );
	
	if ( !isdefined( enemies ) )
		return false;
	
	closest = undefined;
	closestDistsq = undefined;
	secondClosest = undefined;
	secondClosestDistsq = undefined;

	for ( i = 0; i < enemies.size; i++ )
	{
		player = node.nearbyPlayers[team][i];
		
		if ( !isdefined( player ) )
			continue;
		if ( player.sessionstate != "playing" )
			continue;
		if ( player == self )
			continue;
		
		distsq = distanceSquared( node.origin, player.origin );
		if ( !isdefined( closest ) || distsq < closestDistsq )
		{
			secondClosest = closest;
			secondClosestDistsq = closestDistsq;
			
			closest = player;
			closestDistSq = distsq;
		}
		else if ( !isdefined( secondClosest ) || distsq < secondClosestDistSq )
		{
			secondClosest = player;
			secondClosestDistSq = distsq;
		}
	}
	
	if ( isdefined( closest ) )
	{
		if ( bullettracepassed( closest.origin  + (0,0,50), node.origin + (0,0,50), false, undefined) )
			return true;
	}
	if ( isdefined( secondClosest ) )
	{
		if ( bullettracepassed( secondClosest.origin + (0,0,50), node.origin + (0,0,50), false, undefined) )
			return true;
	}
	
	return false;
}

update_all_nodes( nodes, team )
{
	for ( i = 0; i < nodes.size; i++ )
	{
		nodeUpdate( nodes[i], team );
	}
}

avoidEnemies(nodes, team,teambased)
{
	lospenalty = getLosPenalty();
	
	otherteam = "axis";
	if ( team == "axis" )
		otherteam = "allies";

	minDistTeam = otherteam;
	
	if ( !teambased )
	{
		minDistTeam = "all";
	}
	
	avoidWeight = getdvarfloat("scr_spawn_enemyavoidweight");
	if ( avoidWeight != 0 )
	{
		nearbyEnemyOuterRange = getdvarfloat("scr_spawn_enemyavoiddist");
		nearbyEnemyOuterRangeSq = nearbyEnemyOuterRange * nearbyEnemyOuterRange;
		nearbyEnemyPenalty = 1500 * avoidWeight; // typical base weights tend to peak around 1500 or so. this is large enough to upset that while only locally dominating it.
		nearbyEnemyMinorPenalty = 800 * avoidWeight; // additional negative weight for distances up to 2 * nearbyEnemyOuterRange
		
		lastAttackerOrigin = (-99999,-99999,-99999);
		lastDeathPos = (-99999,-99999,-99999);
		
		for ( i = 0; i < nodes.size; i++ )
		{
			// penalty for nearby enemies
			mindist = nodes[i].minDist[minDistTeam];
			if ( mindist < nearbyEnemyOuterRange*2 )
			{
				penalty = nearbyEnemyMinorPenalty * (1 - mindist / (nearbyEnemyOuterRange*2));
				if ( mindist < nearbyEnemyOuterRange )
					penalty += nearbyEnemyPenalty * (1 - mindist / nearbyEnemyOuterRange);
				if ( penalty > 0 )
				{
					nodes[i].weight -= penalty;
				}
			}
		}
	}
				
	// DEBUG
	//prof_end(" spawn_sc");
}

nodeUpdate( node, team )
{
		if ( level.teambased )
		{
			node.sights["axis"] = 0;
			node.sights["allies"] = 0;
			
			node.nearbyPlayers["axis"] = [];
			node.nearbyPlayers["allies"] = [];
		}
		else
		{
			node.sights = 0;
			
			node.nearbyPlayers["all"] = [];
		}
		
		node.nearbyDogs = [];
		
		nodedir = node.forward;
		
		debug = false;
		
		node.distSum["all"] = 0;
		node.distSum["allies"] = 0;
		node.distSum["axis"] = 0;
		node.distSum["dogs"] = 0;
		
		node.minDist["all"] = 9999999;
		node.minDist["allies"] = 9999999;
		node.minDist["axis"] = 9999999;
		node.minDist["dogs"] = 9999999;
	
		node.numPlayersAtLastUpdate = 0;
		node.numDogsAtLastUpdate = 0;
		
		for (i = 0; i < level.players.size; i++)
		{
			player = level.players[i];
			
			if ( player.sessionstate != "playing" )
				continue;
			
			diff = player.origin - node.origin;
			diff = (diff[0], diff[1], 0);
			dist = length( diff ); // needs to be actual distance for distSum value
						
			player_team = "all";
			if ( level.teambased )
				player_team = player.pers["team"];

			if ( dist < 1024 )
			{
				node.nearbyPlayers[player_team][node.nearbyPlayers[player_team].size] = player;
			}
			
			if ( dist < node.minDist[player_team] )
				node.minDist[player_team] = dist;
		
			node.distSum[ player_team ] += dist;
			node.numPlayersAtLastUpdate++;
		}
		
		for (i = 0; i < level.dogs.size; i++)
		{
			dog = level.dogs[i];
			
			if ( !isdefined(dog) || !isalive(dog) )
				continue;
			
			diff = dog.origin - node.origin;
			diff = (diff[0], diff[1], 0);
			dist = length( diff ); // needs to be actual distance for distSum value
						
			if ( dist < 1024 )
			{
				node.nearbyDogs[node.nearbyDogs.size] = dog;
			}
			
			if ( dist < node.minDist["dogs"] )
				node.minDist["dogs"] = dist;
		
			node.distSum[ "dogs" ] += dist;
			node.numDogsAtLastUpdate++;
		}
}

initWeights(nodes)
{
	for (i = 0; i < nodes.size; i++)
		nodes[i].weight = 0;
}

getAllAlliedAndEnemyPlayers( obj, team )
{
	if ( level.teambased )
	{
		if ( team == "allies" )
		{
			obj.allies = level.alivePlayers["allies"];
			obj.enemies = level.alivePlayers["axis"];
		}
		else
		{
			assert( team == "axis" );
			obj.allies = level.alivePlayers["axis"];
			obj.enemies = level.alivePlayers["allies"];
		}
	}
	else
	{
		obj.allies = [];
		obj.enemies = level.activePlayers;
	}
}

avoidSpawnReuse(nodes)
{
	time = getTime();
	
	maxtime = 3*1000;
	maxdistSq = 1024 * 1024;

	for (i = 0; i < nodes.size; i++)
	{
		node = nodes[i];
		
		if (!isdefined(node.lastspawntime))
			continue;
			
		timepassed = time - node.lastspawntime;
		if (timepassed < maxtime)
		{
			worsen = 1000 * (1 - timepassed/maxtime);
			node.weight -= worsen;
		}
	}
}

flash_dogs( area )
{
	self endon("disconnect");
	
	if ( isdefined(level.dogs) )
	{
		for (i = 0; i < level.dogs.size; i++)
		{
			dog = level.dogs[i];
			
			if ( !isalive(dog) )
					continue;
			if ( dog istouching(area) )
			{
				do_flash = true;
				if ( isPlayer( self ) )
				{
					if ( level.teamBased && (dog.aiteam == self.pers["team"]) )
					{
						do_flash = false;
					}
					else if ( !level.teambased && isdefined(dog.script_owner) && self == dog.script_owner )
					{
						do_flash = false;
					}
				}
				
				if ( isdefined( dog.lastFlashed ) && dog.lastFlashed + 1500 > gettime()  )
				{	
					do_flash = false;
				}
				
				if ( do_flash )
				{
					dog setFlashBanged( true, 500 );
					dog.lastFlashed = gettime();
				}
			}	
		}	
	}
}