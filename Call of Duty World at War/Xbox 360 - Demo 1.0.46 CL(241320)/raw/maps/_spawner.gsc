#include maps\_utility; 
#include maps\_anim;
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
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	/#
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _spawner.gsc. Function: main()\n");
	#/
	
	precachemodel("grenade_bag");
//	precachemodel("com_trashbag");
	//****************************************************************************
	//   connect auto AI spawners
	//****************************************************************************

	// create default threatbiasgroups; 
	CreateThreatBiasGroup( "allies" ); 
	CreateThreatBiasGroup( "axis" ); 

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, moved this into the player init.
//	level.player SetThreatBiasGroup( "allies" ); 

	//level.player thread xp_init(); 

/*
	spawners = GetSpawnerArray(); 
	for( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[i]; 
		if( !IsDefined( spawner.targetname ) )
		{
			continue; 
		}
			
		triggers = GetEntArray( spawner.targetname, "target" ); 
		for( j = 0; j < triggers.size; j++ )
		{
			trigger = triggers[j]; 
			
			if( ( IsDefined( trigger.targetname ) ) &&( trigger.targetname == "flood_spawner" ) )
			{
				continue; 
			}
			
			switch( trigger.classname )
			{
			case "trigger_multiple":
			case "trigger_once":
			case "trigger_use":
			case "trigger_damage":
			case "trigger_radius":
			case "trigger_lookat":
				if( spawner.count )
				{
					trigger thread doAutoSpawn( spawner ); 
				}
				break; 
			}
		}
	}
*/

	//****************************************************************************

	level._nextcoverprint = 0; 
	level._ai_group = []; 
	level.killedaxis = 0; 
	level.ffpoints = 0; 
	level.missionfailed = false; 
	level.gather_delay = []; 
	level.smoke_thrown = []; 
	level.deathflags = [];
	level.spawner_number = 0;
	level.go_to_node_arrays = [];

	level.next_health_drop_time = 0; 
	level.guys_to_die_before_next_health_drop = RandomIntRange( 1, 4 ); 
	level.default_goalradius = 2048; 
	level.default_goalheight = 80; 
	level.portable_mg_gun_tag = "J_Shoulder_RI"; // need to get J_gun back to make it work properly
	level.mg42_hide_distance = 1024; 
	
	if( !IsDefined( level.maxFriendlies ) )
	{
		level.maxFriendlies = 11; 
	}

	level._max_script_health = 0; 
	ai = getaispeciesarray ();
	array_thread( ai, ::living_ai_prethink );

		
/*
	if( IsDefined( level._ai_health ) )
	{
		for( i = 0; i < level._max_script_health+1; i++ )
		{
			if( IsDefined( level._ai_health[i] ) )
			{
				rnum = RandomInt( level._ai_health[i].size ); 
				level._ai_health[i][rnum].drophealth = true; 
			}
		}

		for( i = 0; i < ai.size; i++ )
		{
			if( IsDefined( ai[i].drophealth ) )
			{
				ai[i] thread drophealth(); 
			}
		}
	}
*/

	level.ai_classname_in_level = [];

	spawners = GetSpawnerArray(); 
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[i] thread spawn_prethink(); 
	}

	thread process_deathflags();

	array_thread( ai, ::spawn_think );

	level.ai_classname_in_level_keys = getarraykeys( level.ai_classname_in_level );
	for ( i = 0 ; i < level.ai_classname_in_level_keys.size ; i++ )
	{
		if ( !issubstr( tolower( level.ai_classname_in_level_keys[ i ] ), "rpg" ) )
			continue;
		precacheItem( "rpg_player" );
		break;
	}
	level.ai_classname_in_level_keys = undefined;
	
	run_thread_on_noteworthy( "hiding_door_spawner", ::hiding_door_spawner );
	
	/#
	// check to see if the designer has placed at least the minimal number of script_char_groups
//	check_script_char_group_ratio( spawners );
	#/
	
	// CODER_MOD: Bryce (05/08/08): Useful output for debugging replay system
	/#
	if( getdebugdvar( "replay_debug" ) == "1" )
		println("File: _spawner.gsc. Function: main() - COMPLETE\n");
	#/
	
//	level thread flood_spawner_monitor();
	level thread trigger_spawner_monitor();
}

// check to see if the designer has placed at least the minimal number of script_char_groups
check_script_char_group_ratio( spawners )
{
	if ( spawners.size <= 16 )
		return;
		
	total = 0;
	grouped = 0;
	for ( i = 0; i < spawners.size; i++ )
	{
		if ( !spawners[ i ].team != "axis" )
			continue;

		total++;

		if ( !spawners[ i ] has_char_group() )
			continue;
			
		grouped++;
	}

	assertex( grouped / total >= 0.65, "Please group your enemies with script_char_group so that each group gets a unique character mix. This minimizes duplicate characters in close proximity. Or you can specify precise character choice with script_group_index." );
}

has_char_group()
{
	if ( isdefined( self.script_char_group ) )
		return true;
	return isdefined( self.script_char_index );
}

process_deathflags()
{
	keys = getarraykeys( level.deathflags );
	level.deathflags = [];
	for ( i=0; i < keys.size; i++ )
	{
		deathflag = keys[ i ];
		level.deathflags[ deathflag ] = [];
		level.deathflags[ deathflag ][ "spawners" ] = [];
		level.deathflags[ deathflag ][ "ai" ] = [];
		
		if ( !isdefined( level.flag[ deathflag ] ) )
		{
			flag_init( deathflag );
		}
	}
	
}

spawn_guys_until_death_or_no_count()
{
	self endon( "death" );
	self waittill( "count_gone" );
}

deathflag_check_count()
{
	self endon( "death" );
	
	// wait until the end of the frame, so other scripts have a chance to reincrement the spawners count
	waittillframeend;
	if ( self.count > 0 )
		return;

	self notify( "count_gone" );
}

ai_deathflag()
{
	level.deathflags[ self.script_deathflag ][ "ai" ][ self.ai_number ] = self;
	ai_number = self.ai_number;
	deathflag = self.script_deathflag;

	if ( isdefined( self.script_deathflag_longdeath ) )
	{
		self waittillDeathOrPainDeath();
	}
	else
	{
		self waittill( "death" );
	}

	level.deathflags[ deathflag ][ "ai" ][ ai_number ] = undefined;
	update_deathflag( deathflag );
}


spawner_deathflag()
{
	level.deathflags[ self.script_deathflag ] = true;
	
	// wait for the process_deathflags script to run and setup the arrays
	waittillframeend;
	
	if ( !isdefined( self ) || self.count == 0 )
	{
		// the spawner was removed on the first frame
		return;
	}

	// give each spawner a unique id
	self.spawner_number = level.spawner_number;
	level.spawner_number++;

	// keep an array of spawner entities that have this deathflag
	level.deathflags[ self.script_deathflag ][ "spawners" ][ self.spawner_number ] = self;
	deathflag = self.script_deathflag;
	id = self.spawner_number;

	spawn_guys_until_death_or_no_count();
	
	level.deathflags[ deathflag ][ "spawners" ][ id ] = undefined;

	update_deathflag( deathflag );
}

update_deathflag( deathflag )
{
	level notify( "updating_deathflag_" + deathflag );
	level endon( "updating_deathflag_" + deathflag );
	
	// notify and endon and waittill so we only do this a max of once per frame
	// even if multiple spawners or ai are killed in the same frame
	// also gives ai a chance to spawn and be added to the ai deathflag array
	waittillframeend;
	
	spawnerKeys = getarraykeys( level.deathflags[ deathflag ][ "spawners" ] );
	if ( spawnerKeys.size > 0 )
		return;

	aiKeys = getarraykeys( level.deathflags[ deathflag ][ "ai" ] );
	if ( aiKeys.size > 0 )
		return;
		
	// all the spawners and ai are gone
	flag_set( deathflag );
}

outdoor_think( trigger )
{
	assert( ( trigger.spawnflags & 1 ) || ( trigger.spawnflags & 2 ) || ( trigger.spawnflags & 4 ), "trigger_outdoor at " + trigger.origin + " is not set up to trigger AI! Check one of the AI checkboxes on the trigger." );

	trigger endon( "death" );
	for ( ;; )
	{
		trigger waittill( "trigger", guy );
		if ( !isAI( guy ) )
			continue;
		
		guy thread ignore_triggers( 0.15 );
		
		guy disable_cqbwalk();
		guy.wantShotgun = false;
	}	
}

indoor_think( trigger )
{
	assert( ( trigger.spawnflags & 1 ) || ( trigger.spawnflags & 2 ) || ( trigger.spawnflags & 4 ), "trigger_indoor at " + trigger.origin + " is not set up to trigger AI! Check one of the AI checkboxes on the trigger." );

	trigger endon( "death" );
	for ( ;; )
	{
		trigger waittill( "trigger", guy );
		if ( !isAI( guy ) )
			continue;
		
		guy thread ignore_triggers( 0.15 );
		
		guy enable_cqbwalk();
		guy.wantShotgun = true;
	}	
}


doAutoSpawn( spawner )
{
	spawner endon( "death" ); 
	self endon( "death" ); 

	for( ;; )
	{
		self waittill( "trigger" ); 
		if( !spawner.count )
		{
			return; 
		}
		if( self.target != spawner.targetname )
		{
			return; // manually disconnected
		}
		if( IsDefined( spawner.triggerUnlocked ) )
		{
			return; // manually disconnected
		}
		
		while(!(self ok_to_trigger_spawn()))
		{
			wait_network_frame();
		}
		
		guy = spawner spawn_ai(); 
			
		if( spawn_failed( guy ) )
		{
			spawner notify( "spawn_failed" ); 
		}
		
		level._numTriggerSpawned ++;
		
		if( IsDefined( self.Wait ) &&( self.Wait > 0 ) )
		{
			wait( self.Wait ); 
		}
	}
}

trigger_spawner_monitor()
{
	println("Trigger spawner monitor running...");
	level._numTriggerSpawned = 0;
	
	while(1)
	{
		wait_network_frame();
		wait_network_frame();
		level._numTriggerSpawned = 0;
	}
}

ok_to_trigger_spawn(forceChoke)
{
	
	if(isdefined(forceChoke))
	{
		choked = forceChoke;
	}
	else
	{
		choked = false;
	}

	if(isdefined(self.script_trigger) && NumRemoteClients())
	{
		trigger = self.script_trigger;

		if(isdefined(trigger.targetname) && (trigger.targetname == "flood_spawner"))
		{
			choked = true;
			
			if(isdefined(trigger.script_choke) && !trigger.script_choke)
			{
				choked = false;
			}
		}
		else if(isdefined(trigger.spawnflags) && (trigger.spawnflags & 32))
		{

			if(isdefined(trigger.script_choke) && trigger.script_choke)
			{
				choked = true;
			}
		}
	}
	
	if(isdefined(self.targetname) && (self.targetname == "drone_axis" || self.targetname == "drone_allies"))
	{
		choked = true;
	}
	
	if(choked && NumRemoteClients())
	{
		if(level._numTriggerSpawned > 2)
		{
			println("Triggerspawn choke.");
			return false;
		}
	}
	return true;
}

trigger_spawner( trigger )
{
	assertEx( isdefined( trigger.target ), "Triggers with flag TRIGGER_SPAWN at " + trigger.origin + " must target at least one spawner." );
	trigger endon( "death" );
	trigger waittill( "trigger" );
	spawners = getentarray( trigger.target, "targetname" );
	
	for(i = 0; i < spawners.size; i ++)
	{
		spawners[i].script_trigger = trigger;
	}
	
/*	choke = false;
	
	if(isdefined(trigger.script_choke) && trigger.script_choke)
	{
		choke = true;
		
		for(i = 0; i < spawners.size; i ++)
		{
			spawners.script_choke = trigger.script_choke;
		}
	} */
	
/*	if(choke && NumRemoteClients())
	{
		spread_array_thread( spawners, ::trigger_spawner_spawns_guys);
	}
	else */
	{
		array_thread( spawners, ::trigger_spawner_spawns_guys );
	}
}

trigger_spawner_spawns_guys()
{
	self endon( "death" );
	self script_delay();

	while(!self ok_to_trigger_spawn())
	{
		wait_network_frame();
	}

	if ( isdefined( self.script_drone ) )
	{
		spawned = dronespawn( self );
		level._numTriggerSpawned ++;
		assertEx( isdefined( level.drone_spawn_func ), "You need to put maps\_drone::init(); in your level script!" );
		spawned thread [[ level.drone_spawn_func ]]();
		return;
	}
	else
	if ( !issubstr( self.classname, "actor" ) )
		return;

	if( isdefined( self.script_noenemyinfo ) && isdefined( self.script_forcespawn ) )
		spawned = self stalingradSpawn( true );
	else if( isdefined( self.script_noenemyinfo ) )
		spawned = self doSpawn( true );
	else if( isdefined( self.script_forcespawn ) )
		spawned = self stalingradSpawn();
	else
		spawned = self doSpawn();
	
	level._numTriggerSpawned ++;
}

flood_spawner_scripted( spawners )
{
	assertex( IsDefined( spawners ) && spawners.size, "Script tried to flood spawn without any spawners" ); 

	array_thread( spawners, ::flood_spawner_init );
	
/*	if(NumRemoteClients())
	{
		spread_array_thread(spawners, ::flood_spawner_think);
	}
	else */
	{
		array_thread( spawners, ::flood_spawner_think );
	}
}


reincrement_count_if_deleted( spawner )
{
	spawner endon( "death" ); 

	self waittill( "death" ); 
	if( !IsDefined( self ) )
	{
		spawner.count++; 
	}
}


delete_start( startnum )
{
	for( p = 0; p < 2; p++ )
	{
		switch( p )
		{
			case 0:
				aitype = "axis"; 
				break; 

			default:
				assert( p == 1 ); 
				aitype = "allies"; 
				break; 
		}

		ai = GetEntArray( aitype, "team" ); 
		for( i = 0; i < ai.size; i++ )
		{
			if( IsDefined( ai[i].script_start ) )
			{
				if( ai[i].script_start == startnum )
				{
					ai[i] thread delete_me();
				}
			}
		}
	}
}


kill_trigger( trigger )
{
	if( !IsDefined( trigger ) )
	{
		return; 
	}
		
	if( ( IsDefined( trigger.targetname ) ) &&( trigger.targetname != "flood_spawner" ) )
	{
		return; 
	}
		
	trigger Delete(); 
}

random_killspawner( trigger )
{
	random_killspawner = trigger.script_random_killspawner;

	trigger waittill ("trigger");
	
	triggered_spawners = [];
	spawners = getspawnerarray();
	for ( i = 0 ; i < spawners.size ; i++ )
	{
		if ( ( isdefined ( spawners[ i ].script_random_killspawner ) ) && ( random_killspawner == spawners[ i ].script_random_killspawner ) )
		{
			triggered_spawners = add_to_array ( triggered_spawners, spawners[ i ] );
		}
	}
	select_random_spawn( triggered_spawners );
}


kill_spawner( trigger )
{
	killspawner = trigger.script_killspawner; 

	trigger waittill( "trigger" ); 
	
	spawners = GetSpawnerArray(); 
	for( i = 0 ; i < spawners.size ; i++ )
	{
		if( ( IsDefined( spawners[i].script_killspawner ) ) &&( killspawner == spawners[i].script_killspawner ) )
		{
			spawners[i] Delete(); 
		}
	}

	kill_trigger( trigger ); 
}


empty_spawner( trigger )
{
	emptyspawner = trigger.script_emptyspawner; 

	trigger waittill( "trigger" ); 
	spawners = GetSpawnerArray(); 
	for( i = 0; i < spawners.size; i++ )
	{
		if( !IsDefined( spawners[i].script_emptyspawner ) )
		{
			continue; 
		}
		if( emptyspawner != spawners[i].script_emptyspawner )
		{
			continue; 
		}

		if( IsDefined( spawners[i].script_flanker ) )
		{
			level notify( "stop_flanker_behavior" + spawners[i].script_flanker ); 
		}
		spawners[i].count = 0; 
		spawners[i] notify( "emptied spawner" ); 
	}
	trigger notify( "deleted spawners" ); 
}


kill_spawnerNum( number )
{
	spawners = GetSpawnerArray(); 
	for( i = 0; i < spawners.size; i++ )
	{
		if( !IsDefined( spawners[i].script_killspawner ) )
		{
			continue; 
		}

		if( number != spawners[i].script_killspawner )
		{
			continue; 
		}

		spawners[i] Delete(); 
	}
}


trigger_Spawn( trigger )
{
/*
	if( IsDefined( trigger.target ) )
	{
		spawners = GetEntArray( trigger.target, "targetname" ); 
		for( i = 0; i < spawners.size; i++ )
		{
			if( ( spawners[i].team == "axis" ) ||( spawners[i].team == "allies" ) )
			{
				level thread spawn_prethink( spawners[i] ); 
			}
		}
	}
*/
}


waittillDeathOrPainDeath()
{
	self endon( "death" ); 
	self waittill( "pain_death" ); // pain that ends in death
}

drop_gear()
{
	team = self.team; 
	waittillDeathOrPainDeath(); 

	if( !IsDefined( self ) )
	{
		return; 
	}

	// CODER_MOD - Austin (7/3/08): added cold dead hands collectible
	if ( maps\_collectibles::has_collectible( "collectible_dead_hands" ) )
	{
		return;
	}

	self.ignoreForFixedNodeSafeCheck = true;

	if( self.grenadeAmmo <= 0 )
	{
		return; 
	}

	if( IsDefined( self.dropweapon ) && !self.dropweapon )
	{
		return;
	}
	
	level.nextGrenadeDrop--; 
	if( level.nextGrenadeDrop > 0 )
	{
		return; 
	}

	level.nextGrenadeDrop = 2 + RandomInt( 2 ); 
	max = 25; 
	min = 12; 
	spawn_grenade_bag( self.origin +( RandomInt( max )-min, RandomInt( max )-min, 2 ) +( 0, 0, 42 ), ( 0, RandomInt( 360 ), 0 ), self.team ); 
	
}

random_tire( start, end )
{
    model = spawn( "script_model", (0,0,0) );
    model.angles = ( 0, randomint( 360 ), 0 );

    dif = randomfloat( 1 );
    model.origin = start * dif + end * ( 1 - dif );
    model setmodel( "com_junktire" );
    vel = randomvector( 15000 );
    vel = ( vel[ 0 ], vel[ 1 ], abs( vel[ 2 ] ) );
    model physicslaunch( model.origin, vel );
    
    wait ( randomintrange ( 8, 12 ) );
    model delete();
}
	
spawn_grenade_bag( origin, angles, team )
{
	// delete oldest grenade
	if( !IsDefined( level.grenade_cache ) || !IsDefined( level.grenade_cache[team] ) )
	{
		level.grenade_cache_index[team] = 0; 
		level.grenade_cache[team] = []; 
	}

	index = level.grenade_cache_index[team]; 
	grenade = level.grenade_cache[team][index]; 
	if( IsDefined( grenade ) )
	{
		grenade Delete(); 
	}

	grenade = Spawn( "weapon_" + self.grenadeWeapon, origin ); 
	level.grenade_cache[team][index] = grenade; 
	level.grenade_cache_index[team] = ( index + 1 ) % 16;

	grenade.angles = angles;
	grenade.count = self.grenadeammo;

	grenade SetModel( "grenade_bag" );
}

// This spawns the AI and then deletes him
dronespawn_setstruct( spawner )
{
	// spawn a guy, grab his info, delete him. Poor guy
	if ( dronespawn_check() )
		return;
		
	guy = spawner stalingradspawn(); // first frame everybody spawns and spawn_failed isn't effective yet
// 	failed = spawn_failed( guy );
// 	assert( !failed );
	spawner.count++ ; // replenish the spawner
	dronespawn_setstruct_from_guy( guy );
	guy delete();
}

dronespawn_check()
{
	//spawn a guy, grab his info. delete him. Poor guy
	if(isdefined(level.dronestruct[self.classname]))
		return true;
	return false;
	
}

// This creates the struct of models from the AI and remembers it
dronespawn_setstruct_from_guy ( guy )
{
	//spawn a guy, grab his info. delete him. Poor guy
	
	if(dronespawn_check())
		return;
	struct = spawnstruct();
	size = guy getattachsize();
	struct.attachedmodels = []; 
	for( i = 0; i < size; i++ )
	{
		struct.attachedmodels[i] = guy GetAttachModelName( i ); 
		struct.attachedtags[i] = guy GetAttachTagName( i ); 
	}
	struct.model = guy.model; 
//	return struct;
	level.dronestruct[guy.classname] = struct;
}

empty()
{
}

spawn_prethink()
{
	assert( self != level ); 

	level.ai_classname_in_level[ self.classname ] = true;
	
	/#
	if (getdvar ("noai") != "off")
	{
		// NO AI in the level plz
		self.count = 0; 
		return; 
	}
	#/
	
	prof_begin( "spawn_prethink" ); 

	if( IsDefined( self.script_drone ) )
	{
        self thread dronespawn_setstruct(self); //threaded because spawn_failed is weird
	}
			
	if( IsDefined( self.script_aigroup ) )
	{
		aigroup = self.script_aigroup; 
		if( !IsDefined( level._ai_group[aigroup] ) )
		{
			aigroup_create( aigroup ); 			
		}
		self thread aigroup_spawnerthink( level._ai_group[aigroup] ); 
	}

	if( IsDefined( self.script_delete ) )
	{
		array_size = 0; 
		if( IsDefined( level._ai_delete ) )
		{
			if( IsDefined( level._ai_delete[self.script_delete] ) )
			{
				array_size = level._ai_delete[self.script_delete].size; 
			}
		}

		level._ai_delete[self.script_delete][array_size] = self; 
	}
	
	if( IsDefined( self.script_health ) )
	{
		if( self.script_health > level._max_script_health )
		{
			level._max_script_health = self.script_health; 
		}

		array_size = 0; 
		if( IsDefined( level._ai_health ) )
		{
			if( IsDefined( level._ai_health[self.script_health] ) )
			{
				array_size = level._ai_health[self.script_health].size; 
			}
		}

		level._ai_health[self.script_health][array_size] = self; 
	}

	
	deathflag_func = ::empty;
	if ( isdefined( self.script_deathflag ) )
	{
		deathflag_func = ::deathflag_check_count;
		// sets this flag when all the spawners or ai with this flag are gone
		thread spawner_deathflag();
	}
	
	if ( isdefined( self.target ) )
	{
		crawl_through_targets_to_init_flags();
	}

	/*
	// all guns are setup by default now
	// portable mg42 guys
	if( IsSubStr( self.classname, "mgportable" ) || IsSubStr( self.classname, "30cal" ) )
	{
		thread mg42setup_gun(); 
	}
	*/
		
	if( !IsDefined( self.spawn_functions ) )
	{
		self.spawn_functions = []; 
	}

	for( ;; )
	{
		prof_begin( "spawn_prethink" ); 

		self waittill( "spawned", spawn ); 

        [[ deathflag_func ]]();
		
		if( !IsAlive( spawn ) )
		{
			continue; 
		}
		//assertex( IsAlive( spawn ), "Spawner spawned a dead guy somehow." ); 
		
		if( IsDefined( level.spawnerCallbackThread ) )
		{
			self thread[[level.spawnerCallbackThread]]( spawn ); 
		}
		
		if( IsDefined( self.script_delete ) )
		{
			for( i = 0; i < level._ai_delete[self.script_delete].size; i++ )
			{
				if( level._ai_delete[self.script_delete][i] != self )
				{
					level._ai_delete[self.script_delete][i] Delete(); 
				}
			}
		}

		spawn.spawn_funcs = self.spawn_functions; 
		
		if( IsDefined( self.targetname ) )
		{
			spawn thread spawn_think( self.targetname ); 
		}
		else
		{
			spawn thread spawn_think(); 
		}
	}
}

// Wrapper for spawn_think
// should change this so run_spawn_functions() can also work on drones
// currently assumes AI
spawn_think( targetname )
{
	assert( self != level ); 
	level.ai_classname_in_level[ self.classname ] = true;
	spawn_think_action( targetname ); 
	assert( IsAlive( self ) ); 

	self endon( "death" );
	thread run_spawn_functions();
	
	self.finished_spawning = true;
	self notify( "finished spawning" );
	assert( isdefined( self.team ) );
	if ( self.team == "allies" && !isdefined( self.script_nofriendlywave ) )
		self thread friendlydeath_thread();
}

run_spawn_functions()
{
	self endon( "death" );
	if ( !isdefined( self.spawn_funcs ) )
		return;
		
	/*
	if ( isdefined( self.script_vehicleride ) )
	{
		// guys that ride in a vehicle down run their spawn funcs until they land.
		self endon( "death" );
		self waittill( "jumpedout" );
	}
	*/
	
	for ( i=0; i < self.spawn_funcs.size; i++ )
	{
		func = self.spawn_funcs[ i ];
		if ( isdefined( func[ "param4" ] ) )
			thread [[ func[ "function" ] ]]( func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ] );
		else
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
	
	for ( i=0; i < level.spawn_funcs[ self.team ].size; i++ )
	{
		func = level.spawn_funcs[ self.team ][ i ];
		if ( isdefined( func[ "param4" ] ) )
			thread [[ func[ "function" ] ]]( func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ] );
		else
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
	
	self.spawn_funcs = undefined;
}

// the functions that run on death for the ai
deathFunctions()
{
	
	self waittill( "death", other );
	for ( i=0; i < self.deathFuncs.size; i++ )
	{
		array = self.deathFuncs[ i ];
		switch( array[ "params" ] )
		{
			case 0:
				[[ array[ "func" ] ]]( other );
			break;
			case 1:
				[[ array[ "func" ] ]]( other, array[ "param1" ] );
			break;
			case 2:
				[[ array[ "func" ] ]]( other, array[ "param1" ], array[ "param2" ] );
			break;
			case 3:
				[[ array[ "func" ] ]]( other, array[ "param1" ], array[ "param2" ], array[ "param3" ] );
			break;
		}
	}
}


living_ai_prethink()
{
	if ( isdefined( self.script_deathflag ) )
	{
		// later this is turned into the real ddeathflag array
		level.deathflags[ self.script_deathflag ] = true;
	}
	
	if ( isdefined( self.target ) )
	{
		crawl_through_targets_to_init_flags();
	}
}

crawl_through_targets_to_init_flags()
{
	// need to initialize flags on the path chain if need be
	array = get_node_funcs_based_on_target();
	if ( isdefined( array ) )
	{
		targets = array[ "node" ];
		get_func = array[ "get_target_func" ];
		for ( i = 0; i < targets.size; i++ )
		{
			crawl_target_and_init_flags( targets[ i ], get_func );	
		}
	}
}

// Actually do the spawn_think
spawn_think_action( targetname )
{
	// handle default ai flags for ent_flag * functions
	self thread maps\_utility::ent_flag_init_ai_standards();
	
	self thread tanksquish();

	// CODER_MOD: Austin (6/24/08): used to track berserker kill streaks
	if ( maps\_collectibles::has_collectible( "collectible_berserker" ) )
	{
		self thread maps\_collectibles_game::berserker_death();
	}
	
	// ai get their values from spawners and theres no need to have this value on ai
	self.spawner_number = undefined;

	/#
//	if( GetDebugDvar( "debug_misstime" ) == "start" )
//	{
//		self thread maps\_debug::debugMisstime(); 
//	}
		
	thread show_bad_path(); 
	#/

	if( !IsDefined( self.ai_number ) )
	{
		set_ai_number(); 
	}

	if ( isdefined( self.script_dontshootwhilemoving ) )
	{
		self.dontshootwhilemoving = true;
	}

	// functions called on death
	if ( !isdefined( self.deathFuncs ) )
	{
		self.deathFuncs = [];
	}
	
	thread deathFunctions();
	
	if ( isdefined( self.script_deathflag ) )
	{
		thread ai_deathflag();
	}

	// MikeD (4/12/2008): Added the ability to set script_animname which will be the animname for the AI
	if( IsDefined( self.script_animname ) )
	{
		self.animname = self.script_animname;
	}

	if ( isdefined( self.script_forceColor ) )
	{
		// send all forcecolor through a centralized function
		set_force_color( self.script_forceColor );

		// MikeD (9/5/2007): All AI spawned will do "replace_on_death" unless told not to.
		if( !IsDefined( self.script_no_respawn ) || self.script_no_respawn < 1 )
		{
			self thread replace_on_death();
		}
	}
	
		if ( isdefined( self.script_fixednode ) )
	{
		// force the fixednode setting on an ai
		self.fixednode = ( self.script_fixednode == 1 );
	}
	else
	{
		// allies use fixednode by default
		self.fixednode = self.team == "allies";
	}

	set_default_covering_fire();

	
	// which eq triggers am I touching?
//	thread setup_ai_eq_triggers(); 
//	thread ai_array(); 
	self EqOff(); 
		

	if( ( IsDefined( self.script_moveoverride ) ) &&( self.script_moveoverride == 1 ) )
	{
		override = true; 
	}
	else
	{
		override = false; 
	}

	if( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "mgpair" )
	{
		// mgpair guys get angry when their fellow buddy dies
		thread maps\_mg_penetration::create_mg_team(); 
	}
	
	level thread maps\_friendlyfire::friendly_fire_think( self ); 


	if( IsDefined( self.script_goalvolume ) )
	{
		// wait until frame end so that the AI's goal has a chance to get set
		thread set_goal_volume(); 
	}
	
	// create threatbiasgroups
	if( IsDefined( self.script_threatbiasgroup ) )
	{
//		if( !ThreatBiasGroupExists( self.script_threatbiasgroup ) )
//			CreateThreatBiasGroup( self.script_threatbiasgroup ); 
		self SetThreatBiasGroup( self.script_threatbiasgroup ); 
	}
	else if( self.team == "allies" )
	{
		self SetThreatBiasGroup( "allies" ); 
	}
	else
	{
		self SetThreatBiasGroup( "axis" ); 
	}
	
	/#	
	if ( self.type == "human" )
		assertEx( self.pathEnemyLookAhead == 0 && self.pathEnemyFightDist == 0, "Tried to change pathenemyFightDist or pathenemyLookAhead on an AI before running spawn_failed on guy with export " + self.export );
#/
	set_default_pathenemy_settings(); 

	self.heavy_machine_gunner = 	IsSubStr( self.classname, "mgportable" ) 	|| 
																IsSubStr( self.classname, "30cal" ) 			||
																IsSubStr( self.classname, "mg42" ) 				|| 
																IsSubStr( self.classname, "dp28" ); 
	
	maps\_gameskill::grenadeAwareness(); 

	if( IsDefined( self.script_bcdialog ) )
	{
		self set_battlechatter( self.script_bcdialog ); 
	}

	// Set the accuracy for the spawner
	if( IsDefined( self.script_accuracy ) )
	{
		self.baseAccuracy = self.script_accuracy; 
	}

	self.walkdist = 16; 

	if( IsDefined( self.script_ignoreme ) )
	{
		assertEx( self.script_ignoreme == true, "Tried to set self.script_ignoreme to false, not allowed. Just set it to undefined." );
		self.ignoreme = true; 
	}

	if ( isdefined( self.script_ignore_suppression ) )
	{
		assertEx( self.script_ignore_suppression == true, "Tried to set self.script_ignore_suppresion to false, not allowed. Just set it to undefined." );
		self.ignoreSuppression = true;
	}

	if ( isdefined( self.script_ignoreall ) )
	{
		assertEx( self.script_ignoreall == true, "Tried to set self.script_ignoreme to false, not allowed. Just set it to undefined." );
		self.ignoreall = true;
		self clearenemy();
	}

	if( IsDefined( self.script_sightrange ) )
	{
		self.maxSightDistSqrd = self.script_sightrange; 
	}
	else if( WeaponClass( self.weapon ) == "gas" )
	{
		self.maxSightDistSqrd = 1024 * 1024; 
	}

	if( self.team != "axis" )
	{
		self thread use_for_ammo(); 

		// Set the followmin for friendlies
		if( IsDefined( self.script_followmin ) )
		{
			self.followmin = self.script_followmin; 
		}

		// Set the followmax for friendlies
		if( IsDefined( self.script_followmax ) )
		{
			self.followmax = self.script_followmax; 
		}


		// Set the on death thread for friendlies
//		self maps\_names::get_name(); 
		level thread friendly_waittill_death( self ); 
	}

	if ( self.team == "axis" )
	{
		if ( self.type == "human" )
		{
			self thread drop_gear();
			//self thread drophealth();
		}

		/#
			self thread maps\_damagefeedback::monitorDamage();
		#/

		// SCRIPTER_MOD: JesseS (4/14/2008): Need to add this back in, used for arcade mode.
		self thread maps\_gameskill::auto_adjust_enemy_death_detection();

		// CODER_MOD: Austin (6/10/2008): Added health regen thread for zombie collectible
		if ( maps\_collectibles::has_collectible( "collectible_zombie" ) )
		{
			self.gib_override = true;
			self thread maps\_collectibles_game::zombie_health_regen();
		}
	}


// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, we will no longer use script_favoriteenemy, since it only
// was used here for "player"
	// sets the favorite enemy of a spawner
//	if( IsDefined( self.script_favoriteenemy ) )
//	{
//	//	println( "favorite enemy is defined" ); 
//		if( self.script_favoriteenemy == "player" )
//		{
//			self.favoriteenemy = level.player; 
//			level.player.targetname = "player"; 
//	//		println( "setting favoriteenemy = player" ); 
//		}
//	}

	if( IsDefined( self.script_fightdist ) )
	{
		self.pathenemyfightdist = self.script_fightdist; 
	}
	
	if( IsDefined( self.script_maxdist ) )
	{
		self.pathenemylookahead = self.script_maxdist; 	
	}

	// disable long death like dying pistol behavior
	if ( isdefined( self.script_longdeath ) )
	{
		assertex( !self.script_longdeath, "Long death is enabled by default so don't set script_longdeath to true, check ai with export " + self.export );
		self.a.disableLongDeath = true;	
		assertEX( self.team != "allies", "Allies can't do long death, so why disable it on guy with export " + self.export );
	}
	else
	{
		// Make axis have 150 health so they can do dying pain.
		if( self.team == "axis")
		{
			self.health = 150; 
		}
	}

	//player score stuff
	//self thread player_score_think(); 
	

	// Gives AI grenades
	if( IsDefined( self.script_grenades ) )
	{
		self.grenadeAmmo = self.script_grenades; 
	}
	// slayback 10/22/07: defaults for each cod5 aitype are specified in aitypes_charactersettings.gdt
	/*
	else
	{
		self.grenadeAmmo = 3; 
	}
	*/
		
	// Guzzo 7/31/08, removing COD4 check	
//	if( IsDefined( self.script_flashbangs ) )
//	{
//		self.grenadeWeapon = "flash_grenade"; 
//		self.grenadeAmmo = self.script_flashbangs; 
//	}

	// Puts AI in pacifist mode
	if( IsDefined( self.script_pacifist ) )
	{
		self.pacifist = true; 
	}

	// Set the health for special cases
	if( IsDefined( self.script_startinghealth ) )
	{
		self.health = self.script_startinghealth; 
	}

	// GLocke [8/30] allow the AI to be killed during animations (like traversals)
	if( IsDefined(self.script_allowdeath) )
	{
		self.allowdeath = self.script_allowdeath;
	}
	
	// SCRIPTER_MOD: JesseS (1/11/2008): turn off weapon drops. ask a lead before using!
	if( IsDefined(self.script_nodropweapon) )
	{
		self.dropweapon = 0;
	}

	// The AI will spawn and attack the player
	if( IsDefined( self.script_playerseek ) )
	{
		if( IsDefined( self.script_radius ) )
		{
			self.goalradius = self.script_radius;
		}

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, now we will find the closest player to me, and make him my goalentity
//		self SetGoalEntity( level.player ); 
		self SetGoalEntity( get_closest_player(self.origin) ); 
		
		if (isdefined(self.script_sound))
		{
			self animscripts\face::SaySpecificDialogue( undefined, self.script_sound, 1.0 ); 
		}
				
		return; 
	}

	// The AI will spawn and follow a patrol
	if( IsDefined( self.script_patroller ) )
	{
		self thread maps\_patrol::patrol(); 
		return; 
	}

	// MikeD: New spiderhole feature
	if( IsDefined( self.script_spiderhole ) )
	{
		self thread maps\_spiderhole::spiderhole(); 
		return; 
	}
	
	// MikeD: New Banzai feature
	if( IsDefined( self.script_banzai ) )
	{
		self thread maps\_banzai::spawned_banzai_dynamic(); 
	}
	else if( IsDefined( self.script_banzai_spawn ) )
	{
		self thread maps\_banzai::spawned_banzai_immediate();
	}
	
	// The AI will spawn and use his .radius as a goalradius, and his goalradius will get smaller over time.
	if( IsDefined( self.script_delayed_playerseek ) )
	{
		if( !IsDefined( self.script_radius ) )
		{
			self.goalradius = 800; 
		}

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, now we will find the closest player to me, and make him my goalentity
//		self SetGoalEntity( level.player ); 
		self SetGoalEntity( get_closest_player(self.origin) ); 

		if (isdefined(self.script_sound))
		{
			self animscripts\face::SaySpecificDialogue( undefined, self.script_sound, 1.0 ); 
		}
		
		level thread delayed_player_seek_think( self ); 
		
		return; 
	}

	if( self.heavy_machine_gunner )
	{
		// SCRIPTER_MOD: JesseS (6/25/2007):  took this out, I think this is how they handled cod2 stuff,
		// more of this logic is contained else where now (anim scripts and _mg_penetration.gsc).
		thread maps\_mgturret::portable_mg_behavior(); 
	}

	if( IsDefined( self.used_an_mg42 ) ) // This AI was called upon to use an MG42 so he's not going to run to his node.
	{
		return; 
	}

	if( override )
	{
		set_goalradius_based_on_settings();
			
		self SetGoalPos( self.origin ); 
		return; 
	}

	//Crazy Coder Mod! King (7/23/08): ACTOR_MIN_GOAL_RADIUS is now 4
	assertEx( (self.goalradius == 8 || self.goalradius == 4), "Changed the goalradius on guy with export " + self.export + " without waiting for spawn_failed. Note that this change will NOT show up by putting a breakpoint on the actors goalradius field because breakpoints don't properly handle the first frame an actor exists." );
	set_goalradius_based_on_settings();


	// The AI will run to a target node and use the node's .radius as his goalradius.
	// If script_seekgoal is set, then he will run to his node with a goalradius of 0, then set his goal radius
	//    to the node's radius.
	if( IsDefined( self.target ) )
	{
		self thread go_to_node(); 
	}
}

set_default_covering_fire()
{
	// allies use "provide covering fire" mode in fixednode mode.
	self.provideCoveringFire = self.team == "allies" && self.fixedNode;
}


// reset this guy to default spec
scrub_guy()
{
	self EqOff(); 
//	if( self.team == "allies" )
//		self SetThreatBiasGroup( "allies" ); 
//	else
	self SetThreatBiasGroup( self.team ); 
	
	

//	if( IsDefined( self.script_bcdialog ) )
//		self set_battlechatter( self.script_bcdialog ); 

	// Set the accuracy for the spawner
	self.baseAccuracy = 1; 
	set_default_pathenemy_settings(); 
	maps\_gameskill::grenadeAwareness(); 
	self clear_force_color(); 
	set_default_covering_fire();
	self.interval = 96; 
	self.disableArrivals = undefined;
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
	self.activatecrosshair = true;
	self.dropweapon = 1; 
	self.goalradius = level.default_goalradius; 
	self.goalheight = level.default_goalheight; 
	self.ignoresuppression = 0; 
	self pushplayer( false );

	if ( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		stop_magic_bullet_shield(); 
	}
	self disable_replace_on_death();
	self.maxsightdistsqrd = 8192*8192; 

	if( WeaponClass( self.weapon ) == "gas" )
	{
		self.maxSightDistSqrd = 1024 * 1024; 
	}

	self.script_forceGrenade = 0; 
	self.walkdist = 16; 
	self unmake_hero(); 
	self.pushable = true;
	animscripts\init::set_anim_playback_rate(); 

	// allies use fixednode by default
	self.fixednode = self.team == "allies";

	// Gives AI grenades
	if( IsDefined( self.script_grenades ) )
	{
		self.grenadeAmmo = self.script_grenades; 
	}
	else
	{
		self.grenadeAmmo = 3; 
	}
}

delayed_player_seek_think( spawned )
{
	spawned endon( "death" ); 
	while( IsAlive( spawned ) )
	{
		if( spawned.goalradius > 200 )
		{
			spawned.goalradius -= 200; 
		}

		wait( 6 ); 
	}
}

flag_turret_for_use( ai )
{
	self endon( "death" ); 
	if( !self.flagged_for_use )
	{
		ai.used_an_mg42 = true; 
		self.flagged_for_use = true; 
		ai waittill( "death" ); 
		self.flagged_for_use = false; 
		self notify( "get new user" ); 
		return; 
	}

	println( "Turret was already flagged for use" ); 
}

set_goal_volume()
{
	self endon( "death" ); 
	waittillframeend; 
	self SetGoalVolume( level.goalVolumes[self.script_goalvolume] ); 
}

get_target_ents( target )
{
	return getentarray( target, "targetname" );
}

get_target_nodes( target )
{
	return getnodearray( target, "targetname" );
}

get_target_structs( target )
{
	return getstructarray( target, "targetname" );
}

node_has_radius( node )
{
	return isdefined( node.radius ) && node.radius != 0;
}

go_to_origin( node, optional_arrived_at_node_func )
{
	self go_to_node( node, "origin", optional_arrived_at_node_func );
}

go_to_struct( node, optional_arrived_at_node_func )
{
	self go_to_node( node, "struct", optional_arrived_at_node_func );
}

go_to_node( node, goal_type, optional_arrived_at_node_func )
{
	if ( isdefined( self.used_an_mg42 ) )// This AI was called upon to use an MG42 so he's not going to run to his node.
		return;

	array = get_node_funcs_based_on_target( node, goal_type );
	if ( !isdefined( array ) )
	{
		self notify( "reached_path_end" );
		// no goal type
		return;
	}
	
	if ( !isdefined( optional_arrived_at_node_func ) )
	{
		optional_arrived_at_node_func = ::empty_arrived_func;
	}
	
	go_to_node_using_funcs( array[ "node" ], array[ "get_target_func" ], array[ "set_goal_func_quits" ], optional_arrived_at_node_func );
}

empty_arrived_func( node )
{
}

get_least_used_from_array( array )
{
	assertex( array.size > 0, "Somehow array had zero entrees" );
	if ( array.size == 1 )
		return array[ 0 ];
		
	targetname = array[ 0 ].targetname;
	if ( !isdefined( level.go_to_node_arrays[ targetname ] ) )
	{
		level.go_to_node_arrays[ targetname ] = array;
	}
	
	array = level.go_to_node_arrays[ targetname ];
	
	// return the node at the front of the array and move it to the back of the array.
	first = array[ 0 ];
	newarray = [];
	for ( i = 0; i < array.size - 1; i++ )
	{
		newarray[ i ] = array[ i + 1 ];
	}
	newarray[ array.size - 1 ] = array[ 0 ];
	level.go_to_node_arrays[ targetname ] = newarray;
		
	return first;
}


go_to_node_using_funcs( node, get_target_func, set_goal_func_quits, optional_arrived_at_node_func )
{
	// AI is moving to a goal node
	self endon( "stop_going_to_node" );
	self endon( "death" );

	for ( ;; )
	{
		// node should always be an array at this point, so lets get just 1 out of the array
		node = get_least_used_from_array( node );

		if ( node_has_radius( node ) )
			self.goalradius = node.radius;
		else
			self.goalradius = level.default_goalradius;
	
		if ( isdefined( node.height ) )
			self.goalheight = node.height;
		else
			self.goalheight = level.default_goalheight;
		
		[[ set_goal_func_quits ]]( node );
		self waittill( "goal" );

		[[ optional_arrived_at_node_func ]]( node );

		if ( isdefined( node.script_flag_set ) )
		{
			flag_set( node.script_flag_set );
		}
		
		if ( targets_and_uses_turret( node ) )
			return true;
		
		node script_delay();

		if ( isdefined( node.script_flag_wait ) )
		{
			flag_wait( node.script_flag_wait );
		}

		if ( !isdefined( node.target ) )
			break;

		nextNode_array = [[ get_target_func ]]( node.target );
		if ( !nextNode_array.size )
			break;

		node = nextNode_array;
	}

	self notify( "reached_path_end" );

	self set_goalradius_based_on_settings( node );
}

go_to_node_set_goal_pos( ent )
{
	self set_goal_pos( ent.origin );
}

go_to_node_set_goal_node( node )
{
	self set_goal_node( node );
}

targets_and_uses_turret( node )
{
	if ( !isdefined( node.target ) )
		return false;
		
	turrets = getentarray( node.target, "targetname" );
	if ( !turrets.size )
		return false;
	
	turret = turrets[ 0 ];
	if ( turret.classname != "misc_turret" )
		return false;
	
	thread use_a_turret( turret );
	return true;
}

remove_crawled( ent )
{
	waittillframeend;
	if ( isdefined( ent ) )
		ent.crawled = undefined;
}

crawl_target_and_init_flags( ent, get_func )
{
	oldsize = 0;
	targets = [];
	index = 0;
	for ( ;; )
	{
		if ( !isdefined( ent.crawled ) )
		{
			ent.crawled = true;
			level thread remove_crawled( ent );
			
			if ( isdefined( ent.script_flag_set ) )
			{
				if ( !isdefined( level.flag[ ent.script_flag_set ] ) )
				{
					flag_init( ent.script_flag_set );
				}
			}
		
			if ( isdefined( ent.script_flag_wait ) )
			{
				if ( !isdefined( level.flag[ ent.script_flag_wait ] ) )
				{
					flag_init( ent.script_flag_wait );
				}
			}

			if ( isdefined( ent.target ) )
			{
				new_targets = [[ get_func ]]( ent.target );
				targets = add_to_array( targets, new_targets );
			}
		}
			
		index++ ;
		if ( index >= targets.size )
			break;
			
		ent = targets[ index ];		
	}
}

get_node_funcs_based_on_target( node, goal_type )
{
	// figure out if its a node or script origin and set the goal_type index based on that.

	// true is for script_origins, false is for nodes
	get_target_func[ "origin" ] = ::get_target_ents;
	get_target_func[ "node" ] = ::get_target_nodes;
	get_target_func[ "struct" ] = ::get_target_structs;

	set_goal_func_quits[ "origin" ] = ::go_to_node_set_goal_pos;
	set_goal_func_quits[ "struct" ] = ::go_to_node_set_goal_pos;
	set_goal_func_quits[ "node" ] = ::go_to_node_set_goal_node;
	
	// if you pass a node, we'll assume you actually passed a node. We can make it find out if its a script origin later if we need that functionality.
	if ( !isdefined( goal_type ) )
		goal_type = "node";
	
	array = [];
	if ( isdefined( node ) )
	{
		array[ "node" ][ 0 ] = node;
		
	}
	else
	{
		// if you dont pass a node then we need to figure out what type of target it is
		node = getentarray( self.target, "targetname" );
	
		if ( node.size > 0 )
		{
			goal_type = "origin";
		}

		if ( goal_type == "node" )
		{
			node = getnodearray( self.target, "targetname" );
			if ( !node.size )
			{
				node = getstructarray( self.target, "targetname" );
				if ( !node.size )
				{
					// Targetting neither
					return;
				}
				goal_type = "struct";
			}
		}
	
		array[ "node" ] = node;
	}

	array[ "get_target_func" ] = get_target_func[ goal_type ];
	array[ "set_goal_func_quits" ] = set_goal_func_quits[ goal_type ];
	return array;
}


set_goalradius_based_on_settings( node )
{
	if( IsDefined( self.script_radius ) )
	{
		// use the override from radiant
		self.goalradius = self.script_radius; 
		return; 
	}

	if( IsDefined( self.script_banzai_spawn ) )
	{
		self.goalradius = 64;
		return;
	}

	if( IsDefined( self.script_forcegoal ) )
	{
		if( IsDefined( node ) && IsDefined( node.radius ) )
		{
			// use the node's radius
			self.goalradius = node.radius; 
			return; 
		}
	}

	// otherwise use the script default
	self.goalradius = level.default_goalradius; 
}

reachPathEnd()
{
	self waittill( "goal" ); 
	self notify( "reached_path_end" ); 
}

autoTarget( targets )
{
	for( ;; )
	{
		user = self GetTurretOwner(); 
		if( !IsAlive( user ) )
		{
			wait( 1.5 ); 
			continue; 
		}
		
		if( !IsDefined( user.enemy ) )
		{
			self SetTargetEntity( random( targets ) ); 
			self notify( "startfiring" ); 
			self StartFiring(); 
		}

		wait( 2 + RandomFloat( 1 ) ); 
	}
}

manualTarget( targets )
{
	for( ;; )
	{
		self SetTargetEntity( random( targets ) ); 
		self notify( "startfiring" ); 
		self StartFiring(); 

		wait( 2 + RandomFloat( 1 ) ); 
	}
}

// this is called from two places w/ generally identical code... maybe larger scale cleanup is called for.
use_a_turret( turret )
{
	if( self.team == "axis" && self.health == 150 )
	{
		self.health = 100; // mg42 operators aren't going to do long death
		self.a.disableLongDeath = true; 
	}

	unmanned = false;

//	thread maps\_mg_penetration::gunner_think( turret ); 
		
	self Useturret( turret ); // dude should be near the mg42
//	turret SetMode( "auto_ai" ); // auto, auto_ai, manual
//	turret SetTargetEntity( level.player ); 
//	turret SetMode( "manual" ); // auto, auto_ai, manual
	if( ( IsDefined( turret.target ) ) &&( turret.target != turret.targetname ) )
	{
		ents = GetEntArray( turret.target, "targetname" ); 
		targets = []; 
		for( i = 0; i < ents.size; i++ )
		{
			if( ents[i].classname == "script_origin" )
			{
				targets[targets.size] = ents[i]; 
			}
		}
		
//		if( IsDefined( turret.script_autotarget ) )
//		{
//			turret thread autoTarget( targets ); 
//		}
//		else if( IsDefined( turret.script_manualtarget ) )
//		{
//			turret SetMode( "manual_ai" ); 
//			turret thread manualTarget( targets ); 
//		}
//		else if( targets.size > 0 )
//		{
//			if( targets.size == 1 )
//			{
//				turret.manual_target = targets[0]; 
//				turret SetTargetEntity( targets[0] ); 
////				turret SetMode( "manual_ai" ); // auto, auto_ai, manual
//				self thread maps\_mgturret::manual_think( turret ); 
////				if( IsDefined( self.script_mg42auto ) )
////					println( "AI at origin ", self.origin , " has script_mg42auto" ); 
//			}
//			else
//			{
//				turret thread maps\_mgturret::mg42_suppressionFire( targets ); 
//			}
//		}

		// MikeD (4/7/2008): Updated manual targets
		if( targets.size > 0 )
		{
			turret.manual_targets = targets;
			turret SetMode( "auto_nonai" );
			turret thread maps\_mgturret::burst_fire_unmanned();

			unmanned = true;
		}
	}

	if( !unmanned )
	{
		self thread maps\_mgturret::mg42_firing( turret ); 
	}

	turret notify( "startfiring" ); 
}

// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
fallback_spawner_think( num, node_array, ignoreWhileFallingBack )
{
	self endon( "death" ); 
		
	level.max_fallbackers[num]+= self.count; 
	firstspawn = true; 
	while( self.count > 0 )
	{
		self waittill( "spawned", spawn ); 
		if( firstspawn )
		{
			if( GetDvar( "fallback" ) == "1" )
			{
				println( "^a First spawned: ", num ); 
			}
			level notify( ( "fallback_firstspawn" + num ) ); 
			firstspawn = false; 
		}
		
		maps\_spawner::waitframe(); // Wait until he does all his usual spawned logic so he will run to his node
		if( maps\_utility::spawn_failed( spawn ) )
		{
			level notify( ( "fallbacker_died" + num ) ); 
			level.max_fallbackers[num]--; 
			continue; 
		}

		spawn thread fallback_ai_think( num, node_array, "is spawner", ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back 
	}

//	level notify( ( "fallbacker_died" + num ) ); 
}

fallback_ai_think_death( ai, num )
{
	ai waittill( "death" ); 
	level.current_fallbackers[num]--; 

	level notify( ( "fallbacker_died" + num ) ); 
}

// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
fallback_ai_think( num, node_array, spawner, ignoreWhileFallingBack )
{
	if( ( !IsDefined( self.fallback ) ) ||( !IsDefined( self.fallback[num] ) ) )
	{
		self.fallback[num] = true; 
	}
	else
	{
		return; 
	}

	self.script_fallback = num; 
	if( !IsDefined( spawner ) )
	{
		level.current_fallbackers[num]++; 
	}

	if( ( IsDefined( node_array ) ) &&( level.fallback_initiated[num] ) )
	{
		self thread fallback_ai( num, node_array, ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
		/*
		self notify( "stop_going_to_node" ); 
		self SetGoalNode( node ); 
		if( IsDefined( node.radius ) )
		{
			self.goalradius = node.radius; 
		}
		*/
	}

	level thread fallback_ai_think_death( self, num ); 
}

fallback_death( ai, num )
{
	ai waittill( "death" ); 
	
	if (isdefined(ai.fallback_node))
	{
		ai.fallback_node.fallback_occupied = false;
	}
			
	level notify( ( "fallback_reached_goal" + num ) ); 
//	ai notify( "fallback_notify" ); 
}

// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
fallback_goal( ignoreWhileFallingBack )
{
	self waittill( "goal" ); 
	self.ignoresuppression = false;
	
	if( IsDefined( ignoreWhileFallingBack ) && ignoreWhileFallingBack )
	{
		self.ignoreall = false;
	}

	self notify( "fallback_notify" ); 
	self notify( "stop_coverprint" ); 
}

fallback_interrupt()
{
	self notify( "stop_fallback_interrupt" );   
    self endon( "stop_fallback_interrupt" ); 
    
	self endon( "stop_going_to_node" ); 
	self endon ("goto next fallback");
	self endon ("fallback_notify");
	self endon( "death" );  
	
	while(1)
	{
		origin = self.origin;
		wait 2;
		if ( self.origin == origin )
		{
			self.ignoreall  = false;
			return;
		}
	}
}

// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
fallback_ai( num, node_array, ignoreWhileFallingBack )
{
	self notify( "stop_going_to_node" ); 
	self endon( "stop_going_to_node" ); 
	self endon ("goto next fallback");
	self endon( "death" );  // SRS 5/21/2008: bugfix - this kept running after AIs were dead

	node = undefined;
	// set the goalnode
	while( 1 )
	{
		ASSERTEX((node_array.size >= level.current_fallbackers[num]), "Number of fallbackers exceeds number of fallback nodes for fallback # " + num + ". Add more fallback nodes or reduce possible fallbackers.");
		
		node = node_array[RandomInt( node_array.size )];
		if (!isdefined(node.fallback_occupied) || !node.fallback_occupied)
		{
			// set the node occupied so we know to find another one
			node.fallback_occupied = true;
			self.fallback_node = node;
			break;
		}

		wait( 0.1 );
	}
	
	self StopUseTurret();
	self.ignoresuppression = true;
	
	if( self.ignoreall == false && IsDefined( ignoreWhileFallingBack ) && ignoreWhileFallingBack )
	{
		self.ignoreall = true;
		self thread fallback_interrupt();
	}
		
	self SetGoalNode( node );
	if( node.radius != 0 )
	{
		self.goalradius = node.radius;
	}

	self endon( "death" ); 
	level thread fallback_death( self, num ); 
	self thread fallback_goal( ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back

	if( GetDvar( "fallback" ) == "1" )
	{
		self thread coverprint( node.origin ); 
	}

	self waittill( "fallback_notify" ); 
	level notify( ( "fallback_reached_goal" + num ) ); 
}

coverprint( org )
{
	self endon( "fallback_notify" ); 
	self endon( "stop_coverprint" ); 
	self endon ("death");
	while( 1 )
	{
		line( self.origin +( 0, 0, 35 ), org, ( 0.2, 0.5, 0.8 ), 0.5 ); 
		print3d( ( self.origin +( 0, 0, 70 ) ), "Falling Back", ( 0.98, 0.4, 0.26 ), 0.85 ); 
		maps\_spawner::waitframe(); 
	}
}

// This gets set up on each fallback trigger
// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
fallback_overmind( num, group, ignoreWhileFallingBack, percent )
{
	fallback_nodes = undefined; 
	nodes = GetAllNodes(); 
	for( i = 0; i < nodes.size; i++ )
	{
		if( ( IsDefined( nodes[i].script_fallback ) ) &&( nodes[i].script_fallback == num ) )
		{
			fallback_nodes = maps\_utility::add_to_array( fallback_nodes, nodes[i] ); 
		}
	}

	if( IsDefined( fallback_nodes ) )
	{
		level thread fallback_overmind_internal( num, group, fallback_nodes, ignoreWhileFallingBack, percent );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
	}
}

// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
fallback_overmind_internal( num, group, fallback_nodes, ignoreWhileFallingBack, percent )
{
	// SCRIPTER_MOD: JesseS (7/13/200): fixed up current vs max fallbackers, added a level max per
	// script_fallback
	level.current_fallbackers[num] = 0;			// currently alive fallbackers
	level.max_fallbackers[num] = 0;					// maximum fallbackers 
	level.spawner_fallbackers[num] = 0; 		// number of fallback spawners
	level.fallback_initiated[num] = false; 	// has fallback started? 


	spawners = GetSpawnerArray(); 
	for( i = 0; i < spawners.size; i++ )
	{
		if( ( IsDefined( spawners[i].script_fallback ) ) &&( spawners[i].script_fallback == num ) )
		{
			if( spawners[i].count > 0 )
			{
				spawners[i] thread fallback_spawner_think( num, fallback_nodes, ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back 
				level.spawner_fallbackers[num]++; 
			}
		}
	}

	assertex ( level.spawner_fallbackers[num] <= fallback_nodes.size, "There are more fallback spawners than fallback nodes. Add more node or remove spawners from script_fallback: "+ num );

	ai = GetAiArray(); 
	for( i = 0; i < ai.size; i++ )
	{
		if( ( IsDefined( ai[i].script_fallback ) ) &&( ai[i].script_fallback == num ) )
		{
			ai[i] thread fallback_ai_think( num, undefined, undefined, ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
		}
	}

	if( ( !level.current_fallbackers[num] ) &&( !level.spawner_fallbackers[num] ) )
	{
		return; 
	}

	spawners = undefined; 
	ai = undefined; 

	thread fallback_wait( num, group, ignoreWhileFallingBack, percent );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
	level waittill( ( "fallbacker_trigger" + num ) ); 
	
	fallback_add_previous_group(num, fallback_nodes);
	
	if( GetDvar( "fallback" ) == "1" )
	{
		println( "^a fallback trigger hit: ", num ); 
	}
	level.fallback_initiated[num] = true; 

	fallback_ai = undefined; 
	ai = GetAiArray(); 
	for( i = 0; i < ai.size; i++ )
	{
		if( ( ( IsDefined( ai[i].script_fallback ) ) &&( ai[i].script_fallback == num ) ) || ( ( IsDefined( ai[i].script_fallback_group ) ) &&( IsDefined( group ) ) &&( ai[i].script_fallback_group == group ) ) )
		{
			fallback_ai = maps\_utility::add_to_array( fallback_ai, ai[i] ); 
		}
	}
	ai = undefined; 

	if( !IsDefined( fallback_ai ) )
	{
		return; 
	}

	if( !IsDefined( percent ) )
	{
		percent = 0.4;
	}

	first_half = fallback_ai.size * percent;
	first_half = Int( first_half ); 

	level notify( "fallback initiated " + num ); 

	fallback_text( fallback_ai, 0, first_half ); 
	
	first_half_ai = [];
	for( i = 0; i < first_half; i++ )
	{
		fallback_ai[i] thread fallback_ai( num, fallback_nodes, ignoreWhileFallingBack ); 
		first_half_ai[i] = fallback_ai[i];
	}

	// waits until everyone as at their goalnode
	for( i = 0; i < first_half; i++ )
	{
		level waittill( ( "fallback_reached_goal" + num ) ); 
	}

	fallback_text( fallback_ai, first_half, fallback_ai.size ); 

	// SCRIPTER_MOD: JesseS (7/13/2007): added some stuff to check to make sure both halves get to go to nodes
	// turns out that someone else is getting other guys' nodes, so we gotta pick a new one 
	for( i = 0; i < fallback_ai.size; i++ )
	{
		if( IsAlive( fallback_ai[i] ) )
		{
			set_fallback = true;
			for (p = 0; p < first_half_ai.size; p++)
			{
				if ( isalive(first_half_ai[p]))
				{
					if (fallback_ai[i] == first_half_ai[p])
					{
						set_fallback = false;
					}
				}
			}
			
			if (set_fallback)
			{
				fallback_ai[i] thread fallback_ai( num, fallback_nodes, ignoreWhileFallingBack ); 
			}
		}
	}
}

fallback_text( fallbackers, start, end )
{


	if( GetTime() <= level._nextcoverprint )
	{
		return; 
	}

	for( i = start; i < end; i++ )
	{
		if( !IsAlive( fallbackers[i] ) )
		{
			continue; 
		}
			
		level._nextcoverprint = GetTime() + 2500 + RandomInt( 2000 ); 

		/* WTF is this?
		total = fallbackers.size; 
		temp = Int( total * 0.4 ); 


		if( RandomInt( 100 ) > 50 )
		{
			if( total - temp > 1 )
			{
				if( RandomInt( 100 ) > 66 )
				{
					msg = "dawnville_defensive_german_1"; 
				}
				else if( RandomInt( 100 ) > 66 )
				{
					msg = "dawnville_defensive_german_2"; 
				}
				else
				{
					msg = "dawnville_defensive_german_3"; 
				}
			}
			else
			{
				if( RandomInt( 100 ) > 66 )
				{
					msg = "dawnville_defensive_german_4"; 
				}
				else if( RandomInt( 100 ) > 66 )
				{
					msg = "dawnville_defensive_german_5"; 
				}
				else
				{
					msg = "dawnville_defensive_german_1"; 
				}
			}
		}
		else
		{

			if( temp > 1 )
			{
				if( RandomInt( 100 ) > 66 )
				{
					msg = "dawnville_defensive_german_2"; 
				}
				else if( RandomInt( 100 ) > 66 )
				{
					msg = "dawnville_defensive_german_3"; 
				}
				else
				{
					msg = "dawnville_defensive_german_4"; 
				}
			}
			else
			{
				if( RandomInt( 100 ) > 66 )
				{
					msg = "dawnville_defensive_german_5"; 
				}
				else if( RandomInt( 100 ) > 66 )
				{
					msg = "dawnville_defensive_german_1"; 
				}
				else
				{
					msg = "dawnville_defensive_german_2"; 
				}
			}
		}

		fallbackers[i] animscripts\face::SaySpecificDialogue( undefined, msg, 1.0 ); 
		*/
		return; 
	}
}

// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
fallback_wait( num, group, ignoreWhileFallingBack, percent )
{
	level endon( ( "fallbacker_trigger" + num ) ); 
	if( GetDvar( "fallback" ) == "1" )
	{
		println( "^a Fallback wait: ", num ); 
	}
	for( i = 0; i < level.spawner_fallbackers[num]; i++ )
	{
		if( GetDvar( "fallback" ) == "1" )
		{
			println( "^a Waiting for spawners to be hit: ", num, " i: ", i ); 
		}
		level waittill( ( "fallback_firstspawn" + num ) ); 
	}
	if( GetDvar( "fallback" ) == "1" )
	{
		println( "^a Waiting for AI to die, fall backers for group ", num, " is ", level.current_fallbackers[num] ); 
	}

//	total_fallbackers = 0; 
	ai = GetAiArray(); 
	for( i = 0; i < ai.size; i++ )
	{
		if( ( ( IsDefined( ai[i].script_fallback ) ) &&( ai[i].script_fallback == num ) ) || ( ( IsDefined( ai[i].script_fallback_group ) ) &&( IsDefined( group ) ) &&( ai[i].script_fallback_group == group ) ) )
		{
			ai[i] thread fallback_ai_think( num, undefined, undefined, ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
		}
	}
	ai = undefined; 

//	if( !total_fallbackers )
//		return; 

	deadfallbackers = 0; 

	while( deadfallbackers < level.max_fallbackers[num] * percent )
	{
		if( GetDvar( "fallback" ) == "1" )
		{
			println( "^cwaiting for " + deadfallbackers + " to be more than " +( level.max_fallbackers[num] * 0.5 ) ); 
		}
		level waittill( ( "fallbacker_died" + num ) ); 
		deadfallbackers++; 
	}

	println( deadfallbackers , " fallbackers have died, time to retreat" ); 
	level notify( ( "fallbacker_trigger" + num ) ); 
}

// for fallback trigger
// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
//  Note: multiple triggers will need to have script_ignoreall set identically on all triggers
//  for consistency when AIs decide to ignore while falling back or not.
fallback_think( trigger )
{
	ignoreWhileFallingBack = false;
	if( IsDefined( trigger.script_ignoreall ) && trigger.script_ignoreall )
	{
		ignoreWhileFallingBack = true;
	}
	
	if( ( !IsDefined( level.fallback ) ) ||( !IsDefined( level.fallback[trigger.script_fallback] ) ) )
	{
		// MikeD (5/7/2008): Added the ability to determine the percent of guys that will fallback
		// when this trigger is hit.
		percent = 0.5;
		if( IsDefined( trigger.script_percent ) )
		{
			percent = trigger.script_percent / 100;
		}

		level thread fallback_overmind( trigger.script_fallback, trigger.script_fallback_group, ignoreWhileFallingBack, percent ); 
	}

	trigger waittill( "trigger" );
		
	level notify( ( "fallbacker_trigger" + trigger.script_fallback ) ); 
//	level notify( ( "fallback" + trigger.script_fallback ) ); 

	// Maybe throw in a thing to kill triggers with the same fallback? God my hands are cold.
	kill_trigger( trigger ); 
}

// This is for allowing guys to fallback more than once
fallback_add_previous_group(num, node_array)
{
	// check to see if its the first time or not
	if (!isdefined (level.current_fallbackers[num - 1]))
	{
		return;
	}
	
	// max fallbackers for next group add stragglers from previous group
	for (i = 0; i < level.current_fallbackers[num - 1]; i++)
	{
			level.max_fallbackers[num]++;
	}
	
	// current fallbackers from previous group should be added to next group as well
	for (i = 0; i < level.current_fallbackers[num - 1]; i++)
	{
			level.current_fallbackers[num]++;
	}

	ai = GetAiArray(); 
	for( i = 0; i < ai.size; i++ )
	{
		if( ( ( IsDefined( ai[i].script_fallback ) ) && ( ai[i].script_fallback == (num - 1) ) ) )
		{
				//ai[i] notify( "stop_going_to_node" );
				ai[i].script_fallback++; 
				
				if (isdefined (ai[i].fallback_node))
				{
					ai[i].fallback_node.fallback_occupied = false;
					ai[i].fallback_node = undefined;
				}
				
				//ai[i] thread fallback_ai( num, node_array );
		}
	}
}

arrive( node )
{
	self waittill( "goal" ); 

	if( node.radius != 0 )
	{
		self.goalradius = node.radius; 
	}
	else
	{
		self.goalradius = level.default_goalradius; 
	}
}

fallback_coverprint()
{
//	self endon( "death" ); 
	self endon( "fallback" ); 
	self endon( "fallback_clear_goal" ); 
	self endon( "fallback_clear_death" ); 
	while( 1 )
	{
		if( IsDefined( self.coverpoint ) )
		{
			line( self.origin +( 0, 0, 35 ), self.coverpoint.origin, ( 0.2, 0.5, 0.8 ), 0.5 ); 
		}
		print3d( ( self.origin +( 0, 0, 70 ) ), "Covering", ( 0.98, 0.4, 0.26 ), 0.85 ); 
		maps\_spawner::waitframe(); 
	}
}

fallback_print()
{
//	self endon( "death" ); 
	self endon( "fallback_clear_goal" ); 
	self endon( "fallback_clear_death" ); 
	while( 1 )
	{
		if( IsDefined( self.coverpoint ) )
		{
			line( self.origin +( 0, 0, 35 ), self.coverpoint.origin, ( 0.2, 0.5, 0.8 ), 0.5 ); 
		}
		print3d( ( self.origin +( 0, 0, 70 ) ), "Falling Back", ( 0.98, 0.4, 0.26 ), 0.85 ); 
		maps\_spawner::waitframe(); 
	}
}

// SCRIPTER_MOD: JesseS (7/13/2007): not being used it appears, but we should keep it around for reference
//fallback()
//{
////	self endon( "death" ); 
//	dest = GetNode( self.target, "targetname" ); 
//	self.coverpoint = dest; 
//
//	self SetGoalNode( dest ); 
//	if( IsDefined( self.script_seekgoal ) )
//	{
//		self thread arrive( dest ); 
//	}
//	else
//	{
//		if( dest.radius != 0 )
//		{
//			self.goalradius = dest.radius; 
//		}
//		else
//		{
//			self.goalradius = level.default_goalradius; 
//		}
//	}
//
//	while( 1 )
//	{
//		self waittill( "fallback" ); 
//		self.interval = 20; 
//		level thread fallback_death( self ); 
//
//		if( GetDvar( "fallback" ) == "1" )
//		{
//			self thread fallback_prInt(); 
//		}
//
//		if( IsDefined( dest.target ) )
//		{
//			dest = GetNode( dest.target, "targetname" ); 
//			self.coverpoint = dest; 
//			self SetGoalNode( dest ); 
//			self thread fallback_goal(); 
//			if( dest.radius != 0 )
//			{
//				self.goalradius = dest.radius; 
//			}
//		}
//		else
//		{
//			level notify( ( "fallback_arrived" + self.script_fallback ) ); 
//			return; 
//		}
//	}
//}


use_for_ammo()
{
	// Use for ammo is disabled pending further design decisions.
/*
	while( IsAlive( self ) )
	{
		self waittill( "trigger" ); 

		currentweapon = level.player GetCurrentWeapon(); 
		level.player GiveMaxAmmo( currentweapon ); 
		println( "Giving player ammo for current weapon" ); 
		wait( 3 ); 
	}
*/
}

friendly_waittill_death( spawned )
{
	// Disabled globally by Zied, addresses bug 3092, too much text on screen.
	/////////////

/*
	if( IsDefined( spawned.script_noDeathMessage ) )
	{
		return; 
	}

	name = spawned.name; 

	spawned waittill( "death" ); 
	if( ( level.script != "stalingrad" ) &&( level.script != "stalingrad_nolight" ) )
	{
		println( name, " - KIA" ); 
	}
*/
}

delete_me()
{
	maps\_spawner::waitframe(); 
	self Delete(); 
}

vLength( vec1, vec2 )
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
	wait( 0.05 ); 
}

specialCheck( name )
{
	for( ;; )
	{
		assertex( GetEntArray( name, "targetname" ).size, "Friendly wave trigger that targets " + name + " doesnt target any spawners" ); 
		wait( 0.05 ); 
	}
}

friendly_wave( trigger )
{
//	thread specialCheck( trigger.target ); 
	
	if( !IsDefined( level.friendly_wave_active ) )
	{
		thread friendly_wave_masterthread(); 
	}
/#
	if( trigger.targetname == "friendly_wave" )
	{
		assert = false; 
		targs = GetEntArray( trigger.target, "targetname" ); 
		for( i = 0; i < targs.size; i++ )
		{
			if( IsDefined( targs[i].classname[7] ) )
			{
				// SCRIPTER_MOD
				// MikeD( 03/08/07 ): Added support for the temp allies.
				// MikeD( 03/14/07 ): Added the check for info_player_respawn 
				if( targs[i].classname[7] != "l" && targs[i].classname[8] != "l" && targs[i].classname != "info_player_respawn" )
				{
					println( "Friendyl_wave spawner at ", targs[i].origin, " is not an ally" ); 
					assert = true; 
				}
			}
		}
		if( assert )
		{
			maps\_utility::error( "Look above" ); 
		}
	}
#/
	while( 1 )
	{
		trigger waittill( "trigger" ); 
		level notify( "friendly_died" ); 
		if( trigger.targetname == "friendly_wave" )
		{
			level.friendly_wave_trigger = trigger; 
		}
		else
		{
			level.friendly_wave_trigger = undefined; 
			println( "friendly wave OFF" ); 
		}

		wait( 1 ); 
	}
}


set_spawncount( count )
{
	if( !IsDefined( self.target ) )
	{
		return; 
	}

	spawners = GetEntArray( self.target, "targetname" ); 
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[i].count = 0; 
	}
}

friendlydeath_thread()
{
	if ( !isdefined( level.totalfriends ) )
		level.totalfriends = 0;
	level.totalfriends++;

	self waittill ("death");

	level notify( "friendly_died" );
	level.totalfriends--;
}

friendly_wave_masterthread()
{
	level.friendly_wave_active = true; 
	//level.totalfriends = 0; 
	triggers = GetEntArray( "friendly_wave", "targetname" ); 
	array_thread( triggers, ::set_spawncount, 0 ); 

	//friends = GetAiArray( "allies" ); 
	//array_thread( friends, ::friendlydeath_thread ); 

	if( !IsDefined( level.maxfriendlies ) )
	{
		level.maxfriendlies = 7; 
	}

	names = 1; 
	while( 1 )
	{
		if( ( IsDefined( level.friendly_wave_trigger ) ) &&( IsDefined( level.friendly_wave_trigger.target ) ) )
		{
			old_friendly_wave_trigger = level.friendly_wave_trigger; 

			spawn = GetEntArray( level.friendly_wave_trigger.target, "targetname" ); 

			// SCRIPTER_MOD
			// MikeD: Filter out any info_player_respawns from the friendlywave spawn points.
			spawn = filter_player_respawns( spawn ); 

			if( !spawn.size )
			{
				level waittill( "friendly_died" ); 
				continue; 
			}
			num = 0; 

			script_delay = IsDefined( level.friendly_wave_trigger.script_delay ); 

			while( ( IsDefined( level.friendly_wave_trigger ) ) &&( level.totalfriends < level.maxfriendlies ) )
			{
				if( old_friendly_wave_trigger != level.friendly_wave_trigger )
				{
					script_delay = IsDefined( level.friendly_wave_trigger.script_delay ); 
					old_friendly_wave_trigger = level.friendly_wave_trigger; 
					assertex( IsDefined( level.friendly_wave_trigger.target ), "Wave trigger must target spawner" ); 
					spawn = GetEntArray( level.friendly_wave_trigger.target, "targetname" ); 

					// SCRIPTER_MOD
					// MikeD: Filter out any info_player_respawns from the friendlywave spawn points.
					spawn = filter_player_respawns( spawn ); 
				}
				else if( !script_delay )
				{
					num = RandomInt( spawn.size ); 
				}
				else if( num == spawn.size )
				{
					num = 0; 
				}
			
				spawn[num].count = 1; 
				if( isdefined( spawn[ num ].script_noenemyinfo ) && isdefined( spawn[ num ].script_forcespawn ) )
					spawned = spawn[ num ] stalingradSpawn( true );
				else if( isdefined( spawn[ num ].script_noenemyinfo ) )
					spawned = spawn[ num ] doSpawn( true );
				else if( IsDefined( spawn[num].script_forcespawn ) )
				{
					spawned = spawn[num] StalingradSpawn(); 
				}
				else
				{
					spawned = spawn[num] DoSpawn(); 
				}
				spawn[num].count = 0; 
				
				if( spawn_failed( spawned ) )
				{
					wait( 0.2 ); 
					continue; 
				}

				if( IsDefined( level.friendlywave_thread ) )
				{
					level thread[[level.friendlywave_thread]]( spawned ); 
				}
				else
				{
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, TODO, we need the SETFRIENDLYGLOBALCHAIN, in order to fix this properly.
// For now, we'll have the spawned ai's goalentity be players[0]
//					spawned SetGoalEntity( level.player ); 
					players = get_players(); 
					
					if ( isdefined( players ) && players.size > 0 )
					{
						spawned SetGoalEntity( players[0] ); 
					}

				}

				if( script_delay )
				{
					if( level.friendly_wave_trigger.script_delay == 0 )
					{
						waittillframeend; 
					}
					else
					{
						wait( level.friendly_wave_trigger.script_delay ); 
					}
					num++; 
				}
				else
				{
					wait( RandomFloat( 5 ) ); 
				}
			}
		}

		level waittill( "friendly_died" ); 
	}
}

// SCRIPTER_MOD
// MikeD: Filter out any info_player_respawns from the friendlywave spawn points.
filter_player_respawns( array )
{
	newarray = []; 

	clear_player_spawnpoints(); 

	for( i = 0; i < array.size; i++ )
	{
		if( IsDefined( array[i].classname ) && array[i].classname == "info_player_respawn" )
		{
			add_player_spawnpoInt( array[i] ); 
			continue; 
		}

		newarray[newarray.size] = array[i]; 
	}

	return newarray; 
}

friendly_mgTurret( trigger )
{
/#
	if( !IsDefined( trigger.target ) )
	{
		maps\_utility::error( "No target for friendly_mg42 trigger, origin:" + trigger GetOrigin() ); 
	}
#/

	node = GetNode( trigger.target, "targetname" ); 

/#
	if( !IsDefined( node.target ) )
	{
		maps\_utility::error( "No mg42 for friendly_mg42 trigger's node, origin: " + node.origin ); 
	}
#/

	mg42 = GetEnt( node.target, "targetname" ); 
	mg42 SetMode( "auto_ai" ); // auto, auto_ai, manual
	mg42 ClearTargetEntity(); 


	in_use = false; 
	while( 1 )
	{
//		println( "^a mg42 waiting for trigger" ); 
		trigger waittill( "trigger", other ); 
//		println( "^a MG42 TRIGGERED" ); 
		if( IsSentient( other ) )
		{
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player
//			if( other == level.player )
			if( IsPlayer( other ) )
			{
				continue; 
			}
		}

		if( !IsDefined( other.team ) )
		{
			continue; 
		}

		if( other.team != "allies" )
		{
		 	continue; 
		}

		if( ( IsDefined( other.script_usemg42 ) ) &&( other.script_usemg42 == false ) )
		{
			continue; 
		}

		if( other thread friendly_mg42_useable( mg42, node ) )
		{
			other thread friendly_mg42_think( mg42, node ); 

			mg42 waittill( "friendly_finished_using_mg42" ); 
			if( IsAlive( other ) )
			{
				other.turret_use_time = GetTime() + 10000; 
			}
		}

		wait( 1 ); 
	}
}

friendly_mg42_death_notify( guy, mg42 )
{
	mg42 endon( "friendly_finished_using_mg42" ); 
	guy waittill( "death" ); 
	mg42 notify( "friendly_finished_using_mg42" ); 
	println( "^a guy using gun died" ); 
}

friendly_mg42_wait_for_use( mg42 )
{
	mg42 endon( "friendly_finished_using_mg42" ); 
	self.useable = true; 
	self setcursorhint("HINT_NOICON");
	self setHintString(&"PLATFORM_USEAIONMG42");
	self waittill( "trigger" ); 
	println( "^a was used by player, stop using turret" ); 
	self.useable = false; 
	self SetHintString( "" ); 
	self StopUSeturret(); 
	self notify( "stopped_use_turret" ); // special hook for decoytown guys -nate
	mg42 notify( "friendly_finished_using_mg42" ); 
}

friendly_mg42_useable( mg42, node )
{
	if( self.useable )
	{
		return false; 
	}
		
	if( ( IsDefined( self.turret_use_time ) ) &&( GetTime() < self.turret_use_time ) )
	{
//		println( "^a Used gun too recently" ); 
		return false; 
	}

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, now we check to see if any player is too close.
//	if( Distance( level.player.origin, node.origin ) < 100 )

	players = get_players(); 
	for( q = 0; q < players.size; q++ )
	{
		if( Distancesquared( players[q].origin, node.origin ) < 100 * 100 )
		{
//			println( "^a player too close" ); 
			return false; 
		}
	}

	if( IsDefined( self.chainnode ) )
	{
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, now we check to see if all players are too far
//		if( Distance( level.player.origin, self.chainnode.origin ) > 1100 )
		player_count = 0; 
		for( q = 0; q < players.size; q++ )
		{
			if( Distancesquared( players[q].origin, self.chainnode.origin ) > 1100 * 1100 )
			{
				player_count++; 
			}
		}

		if( player_count == players.size )
		{
	//		println( "^a too far from chain node" ); 
			return false; 
		}
	}

	return true; 
}

friendly_mg42_endtrigger( mg42, guy )
{
	mg42 endon( "friendly_finished_using_mg42" ); 
	self waittill( "trigger" ); 
	println( "^a Told friendly to leave the MG42 now" ); 
//	guy StopUSeturret(); 
//	Badplace_Cylinder( undefined, 3, level.player.origin, 150, 150, "allies" ); 

	mg42 notify( "friendly_finished_using_mg42" ); 
}

friendly_mg42_stop_use()
{
	if( !IsDefined( self.friendly_mg42 ) )
	{
		return; 
	}
	self.friendly_mg42 notify( "friendly_finished_using_mg42" ); 
}

noFour()
{
	self endon( "death" ); 
	self waittill( "goal" ); 
	self.goalradius = self.oldradius; 
	if( self.goalradius < 32 )
	{
		self.goalradius = 400; 
	}
}

friendly_mg42_think( mg42, node )
{
	self endon( "death" ); 
	mg42 endon( "friendly_finished_using_mg42" ); 
//	self endon( "death" ); 
	level thread friendly_mg42_death_notify( self, mg42 ); 
//	println( self.name + "^a is using an mg42" ); 
	self.oldradius = self.goalradius; 
	self.goalradius = 28; 
	self thread noFour(); 
	self SetGoalNode( node ); 

	self.ignoresuppression = true; 

	self waittill( "goal" ); 
	self.goalradius = self.oldradius; 
	if( self.goalradius < 32 )
	{
		self.goalradius = 400; 
	}

//	println( "^3 my goal radius is ", self.goalradius ); 
	self.ignoresuppression = false; 

	// Temporary fix waiting on new code command to see who the player is following.
//	self SetGoalEntity( level.player ); 
	self.goalradius = self.oldradius; 

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, now we check to see if any play is too close
//	if( Distance( level.player.origin, node.origin ) < 32 )

	players = get_players(); 
	for( q = 0; q < players.size; q++ )
	{
		if( Distancesquared( players[q].origin, node.origin ) < 32 * 32 )
		{
			mg42 notify( "friendly_finished_using_mg42" ); 
			return; 
		}
	}

	self.friendly_mg42 = mg42; // For making him stop using the mg42 from another script
	self thread friendly_mg42_wait_for_use( mg42 ); 
	self thread friendly_mg42_cleanup( mg42 ); 
	self USeturret( mg42 ); // dude should be near the mg42
//	println( "^a Told AI to use mg42" ); 

	if( IsDefined( mg42.target ) )
	{
		stoptrigger = GetEnt( mg42.target, "targetname" ); 
		if( IsDefined( stoptrigger ) )
		{
			stoptrigger thread friendly_mg42_endtrigger( mg42, self ); 
		}
	}

	while( 1 )
	{
		if( Distance( self.origin, node.origin ) < 32 )
		{
			self USeturret( mg42 ); // dude should be near the mg42
		}
		else
		{
			break; // a friendly is too far from mg42, stop using turret
		}

		if( IsDefined( self.chainnode ) )
		{
			if( Distance( self.origin, self.chainnode.origin ) > 1100 )
			{
				break; // friendly node is too far, stop using turret
			}
		}

		wait( 1 ); 
	}

	mg42 notify( "friendly_finished_using_mg42" ); 
}

friendly_mg42_cleanup( mg42 )
{
	self endon( "death" ); 
	mg42 waittill( "friendly_finished_using_mg42" ); 
	self friendly_mg42_doneUsingTurret(); 
}

friendly_mg42_doneUsingTurret()
{
	self endon( "death" ); 
	turret = self.friendly_mg42; 
	self.friendly_mg42 = undefined; 
	self StopUSeturret(); 
	self notify( "stopped_use_turret" ); // special hook for decoytown guys -nate
	self.useable = false; 
	self.goalradius = self.oldradius; 
	if( !IsDefined( turret ) )
	{
		return; 
	}

	if( !IsDefined( turret.target ) )
	{
		return; 
	}

	node = GetNode( turret.target, "targetname" ); 
	oldradius = self.goalradius; 
	self.goalradius = 8; 
	self SetGoalNode( node ); 
	wait( 2 ); 
	self.goalradius = 384; 
	return; 
	self waittill( "goal" ); 
	if( IsDefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" ); 
		if( IsDefined( node.target ) )
		{
			node = GetNode( node.target, "targetname" ); 
		}
			
		if( IsDefined( node ) )
		{
			self SetGoalNode( node ); 
		}
	}
	self.goalradius = oldradius; 
}

//	self thread maps\_mgturret::mg42_firing( mg42 ); 
//	mg42 notify( "startfiring" ); 

tanksquish()
{
	if ( isdefined( level.noTankSquish ) )
	{
		assertex( level.noTankSquish, "level.noTankSquish must be true or undefined" );
		return;
	}
	
	if ( isdefined( level.levelHasVehicles ) && !level.levelHasVehicles )
		return;
	
	while ( 1 )
	{
		self waittill( "damage", amt, who, force, b, mod, d, e );
		
		if ( mod != "MOD_CRUSH" ) //GLocke: used to be "MOD_CRUSHED"
		{
			continue;
		}

		if ( !isdefined( self ) )
		{
			// deleted?
			return;
		}
		
		if ( isalive( self ) )
			continue;
			
		if ( !isalive( who ) )
			return;
		
		//Glocke: 8/21/08 removed this and I hope that doesn't cause a problem
		//if ( !isdefined( who.vehicletype ) )
		//	return;
					
		force = vectorscale( force, 50000 );
		force = ( force[ 0 ], force[ 1 ], abs( force[ 2 ] ) );

		// GLocke: 8/21/08 if level._effect["tanksquish"] is defined then play it, didn't want to add this fx to every level
		if(IsDefined( level._effect ) && IsDefined( level._effect["tanksquish"] ) )
		{
			PlayFX( level._effect["tanksquish"], self.origin + (0, 0, 30));
		}

		self startRagdoll();
		// CODER MOD: Lucas - This could cause destructibles to run out of memory by shooting it out of the level
/*		org = self.origin;
		for ( i = 0; i < 5; i++ )
		{
			if ( isdefined( self ) )
				org = self.origin;
			PhysicsJolt( org, 250, 250, force );
//			Print3d( org, ".", (1,1,1) );
			wait( 0.05 );
		}*/
		self playsound( "human_crunch" );
		return;
	}
}

// Makes a panzer guy run to a spot and shoot a specific spot
panzer_target( ai, node, pos, targetEnt, targetEnt_offsetVec )
{
	ai endon( "death" ); 
	ai.panzer_node = node; 
	
	if( IsDefined( node.script_delay ) )
	{
		ai.panzer_delay = node.script_delay; 
	}
	
	if( ( IsDefined( targetEnt ) ) &&( IsDefined( targetEnt_offsetVec ) ) )
	{
		ai.panzer_ent = targetEnt; 
		ai.panzer_ent_offset = targetEnt_offsetVec; 
	}
	else
	{
		ai.panzer_pos = pos; 
	}
	ai SetGoalPos( ai.origin ); 
	ai SetGoalNode( node ); 
	ai.goalradius = 12; 
	ai waittill( "goal" ); 
	ai.goalradius = 28; 
	ai waittill( "shot_at_target" ); 	
	ai.panzer_ent = undefined; 
	ai.panzer_pos = undefined; 
	ai.panzer_delay = undefined; 
//	ai.exception_exposed = animscripts\combat::exception_exposed_panzer_guy; 
//	ai.exception_stop = animscripts\combat::exception_exposed_panzer_guy; 
//	ai waittill( "panzer mission complete" ); 
}

#using_animtree( "generic_human" ); 
showStart( origin, angles, anime )
{
	org = GetStartOrigin( origin, angles, anime ); 
	for( ;; )
	{
		print3d( org, "x", ( 0.0, 0.7, 1.0 ), 1, 0.25 ); 	// origin, text, RGB, alpha, scale
		wait( 0.05 ); 
	}
}

spawnWaypointFriendlies()
{
	self.count = 1;
	
	if( isdefined( self.script_noenemyinfo ) && isdefined( self.script_forcespawn ) )
		spawn = self stalingradSpawn( true );
	else if( isdefined( self.script_noenemyinfo ) )
		spawn = self doSpawn( true );
	else if( isdefined( self.script_forcespawn ) )
		spawn = self stalingradSpawn();
	else
		spawn = self doSpawn();
		
	if ( spawn_failed( spawn ) )
		return;
	spawn.friendlyWaypoint = true;
}

// Newvillers global stuff:

waittillDeathOrLeaveSquad()
{
	self endon( "death" ); 
	self waittill( "leaveSquad" ); 
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
	triggers = GetEntArray( self.target, "targetname" ); 
	for( i = 0; i < triggers.size; i++ )
	{
		if( triggers[i] GetEntNum() == 526 )
		{
			println( "Target: " + triggers[i].target ); 
		}
	}
	#/
	array_thread( GetEntArray( self.target, "targetname" ), ::friendlySpawnWave_triggerThink, self ); 
	for( ;; )
	{
		self waittill( "trigger", other ); 
		// If we're the current friendly spawn spot then stop friendly spawning because
		// the player is backtracking
		if( activeFriendlySpawn() && getFriendlySpawnTrigger() == self )
		{
			unsetFriendlySpawn(); 
		}

		self waittill( "friendly_wave_start", startPoint ); 
		setFriendlySpawn( startPoint, self ); 
		
		
		// If the startpoint targets a trigger, that trigger can
		// disable the startpoint too
		if( !IsDefined( startPoint.target ) )
		{
			continue; 
		}
		trigger = GetEnt( startPoint.target, "targetname" ); 
		trigger thread spawnWaveStopTrigger( self ); 
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
		spawner can target another spawner. When first spawner's ai dies from death( not deletion ), second spawner activates.
		script_noteworth "instant_respawn" on the trigger will disable the wave respawning
	*/
	
	// Instantrespawn disables wave respawning or waiting for time to pass before respawning
	if( !IsDefined( instantRespawn ) )
	{
		instantRespawn = false; 
	}
	
	if( ( IsDefined( self.script_noteworthy ) ) &&( self.script_noteworthy == "instant_respawn" ) )
	{
		instantRespawn = true; 
	}
	
	level.spawnerWave = []; 
	spawners = GetEntArray( self.target, "targetname" ); 
	array_thread( spawners, ::flood_and_secure_spawner, instantRespawn ); 
	
	playerTriggered = false; 
	
		
	for( ;; )
	{
		self waittill( "trigger", other ); 
		if( !objectiveIsAllowed() )
		{
			continue; 
		}
			
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player
//		if( self IsTouching( level.player ) )
		if( any_player_IsTouching( self ) )
		{
			playerTriggered = true; 
		}
		else
		{
			if( !IsAlive( other ) )
			{
				continue; 
			}
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player
//			if( other == level.player )
			if( IsPlayer( other ) )
			{
				playerTriggered = true; 
			}
			else if( !IsDefined( other.isSquad ) || !other.isSquad )
			{
				// Non squad AI are not allowed to spawn enemies
				continue; 
			}
		}
		
		// Reacquire spawners in case one has died/been deleted and moved up to another
		// because spawners can target other spawners that are used when the first spawner dies.
		spawners = GetEntArray( self.target, "targetname" ); 
		
		
		if( IsDefined( spawners[0] ) )
		{
			if( IsDefined( spawners[0].script_randomspawn ) )
			{
				select_random_Spawn( spawners ); 
			}
		}

		spawners = GetEntArray( self.target, "targetname" ); 
			
		for( i = 0; i < spawners.size; i++ )
		{
			spawners[i].playerTriggered = playerTriggered; 
			spawners[i] notify( "flood_begin" ); 
		}
			
		if( playerTriggered )
		{
			wait( 5 ); 
		}
		else
		{
			wait( 0.1 ); 
		}
	}
}

select_random_spawn(spawners)
{
	groups = [];
	for ( i=0; i < spawners.size; i++ )
	{
		groups[ spawners[ i ].script_randomspawn ] = true;
	}
	
	keys = getarraykeys( groups );
	num_that_lives = random( keys );

	for ( i=0; i < spawners.size; i++ )
	{
		if ( spawners[ i ].script_randomspawn != num_that_lives )
			spawners[i] delete();
	}
	
	
	/*
	highest_num = 0;
	for (i=0;i<spawners.size;i++)
	{
		if (spawners[i].script_randomspawn > highest_num)
			highest_num = spawners[i].script_randomspawn;
	}
	
	selection = randomint (highest_num + 1);
	for (i=0;i<spawners.size;i++)
	{
		if (spawners[i].script_randomspawn != selection)
			spawners[i] delete();
	}
	*/
}

flood_and_secure_spawner( instantRespawn )
{
	if ( isdefined( self.secureStarted ) )
	{
		// Multiple triggers can trigger a flood and secure spawner, but they need to run
		// their logic just once so we exit out if its already running.
		return;
	}

	self.secureStarted = true;
	self.triggerUnlocked = true;// So we don't run auto targetting behavior
	
	/* 
	mg42 = issubstr( self.classname, "mgportable" ) || issubstr( self.classname, "30cal" );
	if ( !mg42 )
	{
		// So we don't go script error'ing or whatnot off auto spawn logic
		// Unless we're an mg42 guy that has to set an mg42 up.
		self.script_moveoverride = true; 
	}
	*/ 
	
	target = self.target;
	targetname = self.targetname;
	if ( ( !isdefined( target ) ) && ( !isdefined( self.script_moveoverride ) ) )
	{
		println( "Entity " + self.classname + " at origin " + self.origin + " has no target" );
		waittillframeend;
		assert( isdefined( target ) );
	}

	// follow up spawners
	spawners = [];
	if ( isdefined( target ) )
	{
		possibleSpawners = getentarray( target, "targetname" );
		for ( i = 0;i < possibleSpawners.size;i++ )
		{
			if ( !issubstr( possibleSpawners[ i ].classname, "actor" ) )
				continue;
			spawners[ spawners.size ] = possibleSpawners[ i ];
		}
	}
	
	ent = spawnstruct();
	org = self.origin;
	flood_and_secure_spawner_think( ent, spawners.size > 0, instantRespawn );
	if ( isalive( ent.ai ) )
		ent.ai waittill( "death" );
	
	if ( !isdefined( target ) )
		return;
	
	// follow up spawners
	possibleSpawners = getentarray( target, "targetname" );
	if ( !possibleSpawners.size )
		return;
	
	for ( i = 0;i < possibleSpawners.size;i++ )
	{
		if ( !issubstr( possibleSpawners[ i ].classname, "actor" ) )
			continue;

		possibleSpawners[ i ].targetname = targetname;
		newTarget = target;
		if ( isdefined( possibleSpawners[ i ].target ) )
		{
			targetEnt = getent( possibleSpawners[ i ].target, "targetname" );
			if ( !isdefined( targetEnt ) || !issubstr( targetEnt.classname, "actor" ) )
				newTarget = possibleSpawners[ i ].target;
		}

		// The guy might already be targetting a different destination
		// But if not, he goes to the node his parent went to. 
		possibleSpawners[ i ].target = newTarget;
			
		possibleSpawners[ i ] thread flood_and_secure_spawner( instantRespawn );

		// Pass playertriggered flag as true because at this point the player must have been involved because one shots dont
		// spawn without the player triggering and multishot guys require player kills or presense to move along
		possibleSpawners[ i ].playerTriggered = true;
		possibleSpawners[ i ] notify( "flood_begin" ); 
	}
}

flood_and_secure_spawner_think( ent, oneShot, instantRespawn )
{
	assert( isdefined( instantRespawn ) );
	self endon( "death" );
	count = self.count;
	// oneShot = ( count == 1 );
	if ( !oneShot )
		oneshot = ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "delete" );
	self.count = 2;// running out of count counts as a dead spawner to script_deathchain

	if ( isdefined( self.script_delay ) )
		delay = self.script_delay;
	else
		delay = 0;
	
	for ( ;; )
	{
		self waittill( "flood_begin" );
		if ( self.playerTriggered )
			break;
/* 			
		// Lets let AI spawn oneshots!
		// Oneshots require player triggering to activate
		if ( oneShot )
			continue;
*/ 
		// guys that have a delay require triggering from the player 	
		if ( delay )
			continue;
		break;
	}

	// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, since this wants the current distance, let's get the closest player and
// get that distance.
//	dist = Distance( level.player.origin, self.origin ); 
	closest_player = get_closest_player( self.origin ); 
	// MikeD: Distancesquared() is cheaper, since we're comparing numbers, and not using the actual distance.
	dist = Distancesquared( closest_player.origin, self.origin ); 

	prof_begin( "flood_and_secure_spawner_think" );

	while ( count )
	{
		self.trueCount = count;
		self.count = 2;
		wait( delay );
		
		if( isdefined( self.script_noenemyinfo ) && isdefined( self.script_forcespawn ) )
			spawn = self stalingradSpawn( true );
		else if( isdefined( self.script_noenemyinfo ) )
			spawn = self doSpawn( true );
		else if( isdefined( self.script_forcespawn ) )
			spawn = self stalingradSpawn();
		else
			spawn = self doSpawn();
			
		if ( spawn_failed( spawn ) )
		{
			playerKill = false;
			if ( delay < 2 )
				wait( 2 );// debounce 
			continue;
		}
		else
		{
			thread addToWaveSpawner( spawn );
			spawn thread flood_and_secure_spawn( self );
			
			// Set the accuracy for the spawner
			if ( isdefined( self.script_accuracy ) )
				spawn.baseAccuracy = self.script_accuracy;
			
			ent.ai = spawn;
			ent notify( "got_ai" );
			self waittill( "spawn_died", deleted, playerKill );
			if ( delay > 2 )
				delay = randomint( 4 ) + 2;// first delay can be long, after that its always a set amount.		
			else
				delay = 0.5 + randomfloat( 0.5 );
		}

		if ( deleted )
		{
			// Deletion indicates that we've hit the max AI limit and this is the oldest / farthest AI
			// so we need to stop this spawner until it gets triggered again or the player gets close
			
			waittillRestartOrDistance( dist );
		}
		else
		{
			/* 
			// Only player kills count towards the count unless the spawner only has a count of 1
			// or NOT
			if ( playerKill || oneShot )
			*/ 
			if ( playerWasNearby( playerKill || oneShot, ent.ai ) )
				count -- ;
				
			if ( !instantRespawn )
				waitUntilWaveRelease();
		}
	}
	
	prof_end( "flood_and_secure_spawner_think" );

	self delete();
}


waittillDeletedOrDeath( spawn )
{
	self endon( "death" ); 
	spawn waittill( "death" ); 
}

addToWaveSpawner( spawn )
{
	name = self.targetname; 
	if( !IsDefined( level.spawnerWave[name] ) )
	{
		level.spawnerWave[name] = SpawnStruct(); 
		level.spawnerWave[name].count = 0; 
		level.spawnerWave[name].total = 0; 
	}
	
	if( !IsDefined( self.addedToWave ) )
	{
		self.addedToWave = true; 
		level.spawnerWave[name].total++; 
	}

	level.spawnerWave[name].count++; 
	/*
	/#
	if( level.debug_corevillers )
	{
		thread debugWaveCount( level.spawnerWave[name] ); 
	}
	#/
	*/
	waittillDeletedOrDeath( spawn ); 
	level.spawnerWave[name].count--; 
	if( !IsDefined( self ) )
	{
		level.spawnerWave[name].total--; 
	}

	/*
	/#
	if( IsDefined( self ) )
	{
		if( level.debug_corevillers )
		{
			self notify( "debug_stop" ); 
		}
	}
	#/
	*/
	
//	if( !level.spawnerWave[name].count )
	// Spawn the next wave if 68% of the AI from the wave are dead.
	if( level.spawnerWave[name].total )
	{
		if( level.spawnerWave[name].count / level.spawnerWave[name].total < 0.32 )
		{
			level.spawnerWave[name] notify( "waveReady" ); 
		}
	}
}

debugWaveCount( ent )
{
	self endon( "debug_stop" ); 
	self endon( "death" ); 
	for( ;; )
	{
		print3d( self.origin, ent.count + "/" + ent.total, ( 0, 0.8, 1 ), 0.5 ); 
		wait( 0.05 ); 
	}
}


waitUntilWaveRelease()
{
	name = self.targetName; 
	if( level.spawnerWave[name].count )
	{
		level.spawnerWave[name] waittill( "waveReady" ); 
	}
}


playerWasNearby( playerKill, ai )
{
	if( playerKill )
	{
		return true; 
	}
	if( IsDefined( ai ) && IsDefined( ai.origin ) )
	{
		org = ai.origin; 
	}
	else
	{
		org = self.origin; 
	}

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, we'll get the closest player instead
//	if( Distance( level.player.origin, org ) < 700 )
	closest_player = get_closest_player( org ); 
	if( Distancesquared( closest_player.origin, org ) < 700 * 700 )
	{
		return true; 
	}

//	/#thread animscripts\utility::debugline( level.player.origin, org, ( 0, 1, 0 ), 20 ); #/

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, we'll get the closest player instead
//	return BulletTracePassed( level.player GetEye(), ai GetEye(), false, undefined ); 
	return BulletTracePassed( closest_player GetEye(), ai GetEye(), false, undefined ); 
}

waittillRestartOrDistance( dist )
{
	self endon( "flood_begin" ); 
	
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): Changed to "squared", cheaper.
//	dist = dist * 0.75; // require the player to get a bit closer to force restart the spawner	
	dist = dist * ( 0.75 * 0.75 ); // require the player to get a bit closer to force restart the spawner

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, instead we'll check the closest player
//	while( Distance( level.player.origin, self.origin ) > dist )
	
	closest_player = get_closest_player( self.origin ); 
	while( Distancesquared( closest_player.origin, self.origin ) > dist )
	{
		wait( 1 ); 
		closest_player = get_closest_player( self.origin ); 
	}
}

flood_and_secure_spawn( spawner )
{
	self thread flood_and_secure_spawn_goal();
	
	self waittill( "death", other );

// CODER_MOD
// JamesS 11/28/07 no more level.player
	playerKill = isalive( other ) && IsPlayer(other);
	if ( !playerkill && isdefined( other ) && other.classname == "worldspawn" )// OR THE WORLDSPAWN???
	{
		playerKill = true;
	}
	
	deleted = !isdefined( self );
	spawner notify( "spawn_died", deleted, playerKill );
}


flood_and_secure_spawn_goal()
{
	if ( isdefined( self.script_moveoverride ) )
		return;
	
	self endon( "death" ); 
	node = GetNode( self.target, "targetname" ); 
	self SetGoalNode( node ); 

//	if (isdefined( self.script_deathChain ) )
//		self setgoalvolume( level.deathchain_goalVolume[ self.script_deathChain ] );
	
	if( IsDefined( level.fightdist ) )
	{
		self.pathenemyfightdist = level.fightdist; 
		self.pathenemylookahead = level.maxdist; 
	}
	
	if( node.radius )
	{
		self.goalradius = node.radius; 
	}
	else
	{
		self.goalradius = 64; 
	}
		
	self waittill( "goal" ); 
	
	while( IsDefined( node.target ) )
	{
		newNode = GetNode( node.target, "targetname" ); 
		if( IsDefined( newNode ) )
		{
			node = newNode; 
		}
		else
		{
			break; 
		}
			
		self SetGoalNode( node ); 
			
		if( node.radius )
		{
			self.goalradius = node.radius; 
		}
		else
		{
			self.goalradius = 64; 
		}
			
		self waittill( "goal" ); 
	}
	
	
	if( IsDefined( self.script_noteworthy ) )
	{
		if( self.script_noteworthy == "delete" )
		{
//			self Delete(); 
			// Do damage instead of delete so he counts as "killed" and we dont have to write 
			// stuff to let the spawner know to stop trying to spawn him.
			self DoDamage( ( self.health *0.5 ), ( 0, 0, 0 ) ); 
			return; 
		}
	}
	
	if( IsDefined( node.target ) )
	{
		turret = GetEnt( node.target, "targetname" ); 
		if( IsDefined( turret ) &&( turret.classname == "misc_mgturret" || turret.classname == "misc_turret" ) )
		{
			self SetGoalNode( node ); 
			self.goalradius = 4; 
			self waittill( "goal" ); 
			if( !IsDefined( self.script_forcegoal ) )
			{
				self.goalradius = level.default_goalradius; 
			}
			self maps\_spawner::use_a_turret( turret ); 
		}
	}

	if( IsDefined( self.script_noteworthy ) )
	{
		if( IsDefined( self.script_noteworthy2 ) )
		{
			if( self.script_noteworthy2 == "furniture_push" )
			{
				thread furniturePushSound(); 
			}
		}

		if( self.script_noteworthy == "hide" )
		{
			self thread set_battlechatter( false ); 
			return; 
		}
	}
	
	if( !IsDefined( self.script_forcegoal ) )
	{
		self.goalradius = level.default_goalradius; 
	}
}

furniturePushSound()
{
	org = GetEnt( self.target, "targetname" ).origin; 
	play_sound_in_space( "furniture_slide", org ); 
	wait( 0.9 ); 
	if( IsDefined( level.whisper ) )
	{
		play_sound_in_space( random( level.whisper ), org ); 
	}
		
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
	triggers = GetEntArray( self.target, "targetname" ); 
	if( !triggers.size )
	{
		// trigger targets chain directly, has no direction
		node = GetNode( self.target, "targetname" ); 
		assert( IsDefined( node ) ); 
	assert( IsDefined( node.script_noteworthy ) ); 
		for( ;; )
		{
			self waittill( "trigger" ); 
			if( IsDefined( level.lastFriendlyTrigger ) && level.lastFriendlyTrigger == self )
			{
				wait( 0.5 ); 
				continue; 
			}

			if( !objectiveIsAllowed() )
			{
				wait( 0.5 ); 
				continue; 
			}

			level notify( "new_friendly_trigger" ); 
			level.lastFriendlyTrigger = self; 
			
			rejoin = !IsDefined( self.script_baseOfFire ) || self.script_baseOfFire == 0; 
			setNewPlayerChain( node, rejoin ); 
		}
	}
	
	/#
	for( i = 0; i < triggers.size; i++ )
	{
		node = GetNode( triggers[i].target, "targetname" ); 
		assert( IsDefined( node ) ); 
		assert( IsDefined( node.script_noteworthy ) ); 
	}
	#/
	
	for( ;; )
	{
		self waittill( "trigger" ); 
//		if( level.currentObjective != self.script_noteworthy2 )

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, instead check to see if any player is touching this trigger
//		while( level.player IsTouching( self ) )
		while( any_player_IsTouching( self ) )
		{
			wait( 0.05 ); 
		}

		if( !objectiveIsAllowed() )
		{
			wait( 0.05 ); 
			continue; 
		}
				
		if( IsDefined( level.lastFriendlyTrigger ) && level.lastFriendlyTrigger == self )
		{
			continue; 
		}

		level notify( "new_friendly_trigger" ); 
		level.lastFriendlyTrigger = self; 

		array_thread( triggers, ::friendlyTrigger ); 
		wait( 0.5 ); 
	}
}

objectiveIsAllowed()
{
	active = true; 
	if( IsDefined( self.script_objective_active ) )
	{
		active = false; 
		// objective must be active for this trigger to hit
		for( i = 0; i < level.active_objective.size; i++ )
		{
			if( !IsSubStr( self.script_objective_active, level.active_objective[i] ) )
			{
				continue; 
			}
			active = true; 
			break; 
		}

		if( !active )				
		{
			return false; 
		}
	}

	if( !IsDefined( self.script_objective_inactive ) )
	{
		return( active ); 
	}

	// trigger only hits if this objective is inactive
	inactive = 0; 
	for( i = 0; i < level.inactive_objective.size; i++ )
	{
		if( !IsSubStr( self.script_objective_inactive, level.inactive_objective[i] ) )
		{
			continue; 
		}
		inactive++; 
	}
	
	tokens = Strtok( self.script_objective_inactive, " " ); 
	return( inactive == tokens.size ); 
}

friendlyTrigger( node )
{
	level endon( "new_friendly_trigger" ); 
	self waittill( "trigger" ); 
	node = GetNode( self.target, "targetname" ); 
	rejoin = !IsDefined( self.script_baseOfFire ) || self.script_baseOfFire == 0; 
	setNewPlayerChain( node, rejoin ); 
}



waittillDeathOrEmpty()
{
	self endon( "death" ); 
	num = self.script_deathChain; 
	while( self.count )
	{
		self waittill( "spawned", spawn ); 
		spawn thread deathChainAINotify( num ); 
	}
}

deathChainAINotify( num )
{
	level.deathSpawner[num]++; 
	self waittill( "death" ); 
	level.deathSpawner[num]--; 
	level notify( "spawner_expired" + num ); 
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
	if( IsDefined( self ) )
	{
		for( i = 0; i < level.deathSpawnerEnts[num].size; i++ )
		{
			if( !IsDefined( level.deathSpawnerEnts[num][i] ) )
			{
				continue; 
			}

			if( self == level.deathSpawnerEnts[num][i] )
			{
				continue; 
			}
			newDeathSpawners[newDeathSpawners.size] = level.deathSpawnerEnts[num][i]; 
		}
	}
	else
	{
		for( i = 0; i < level.deathSpawnerEnts[num].size; i++ )
		{
			if( !IsDefined( level.deathSpawnerEnts[num][i] ) )
			{
				continue; 
			}
			newDeathSpawners[newDeathSpawners.size] = level.deathSpawnerEnts[num][i]; 
		}
	}
	
	level.deathSpawnerEnts[num] = newDeathSpawners; 
	#/
 	level notify( "spawner dot" + org ); 
	level.deathSpawner[num]--; 
	level notify( "spawner_expired" + num ); 
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
	triggers = GetEntArray( "friendly_chain_on_death", "targetname" ); 
	spawners = GetSpawnerArray(); 
	level.deathSpawner = []; 
	/#
	// for debugging deathspawners
	level.deathSpawnerEnts = []; 
	#/
	for( i = 0; i < spawners.size; i++ )
	{
		if( !IsDefined( spawners[i].script_deathchain ) )
		{
			continue; 
		}
		
		num = spawners[i].script_deathchain; 
		if( !IsDefined( level.deathSpawner[num] ) )
		{
			level.deathSpawner[num] = 0; 
			/#
			level.deathSpawnerEnts[num] = []; 
			#/
		}

		spawners[i] thread deathChainSpawnerLogic(); 
//		level.deathSpawner[num]++; 
	}
	
	for( i = 0; i < triggers.size; i++ )
	{
		if( !IsDefined( triggers[i].script_deathchain ) )
		{
			println( "trigger at origin " + triggers[i] GetOrigin() + " has no script_deathchain" ); 
			return; 
		}
		
		triggers[i] thread friendlyChain_onDeathThink(); 
	}
}

friendlyChain_onDeathThink()
{
	while( level.deathSpawner[self.script_deathChain] > 0 )
	{
		level waittill( "spawner_expired" + self.script_deathChain ); 
	}

	level endon( "start_chain" ); 
	node = GetNode( self.target, "targetname" ); 
	for( ;; )
	{
		self waittill( "trigger" ); 
		setNewPlayerChain( node, true ); 
		iprintlnbold( "Area secured, move up!" ); 
		wait( 5 ); // debounce
	}
}

setNewPlayerChain( node, rejoin )
{
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, TODO: we need the setglobalfriendlychain for this to be setup properly.
// For now, I'm going to use players[0].
//	level.player set_friendly_chain_wrapper( node ); 
	players = get_players(); 
	players[0] set_friendly_chain_wrapper( node ); 
	level notify( "new_escort_trigger" ); // stops escorting guy from getting back on escort chain 
	level notify( "new_escort_debug" ); 
	level notify( "start_chain", rejoin ); // get the SMG guy back on the friendly chain
}	


friendlyChains()
{
	level.friendlySpawnOrg = []; 
	level.friendlySpawnTrigger = []; 	
	array_thread( GetEntArray( "friendlychain", "targetname" ), ::friendlychain ); 
}


unsetFriendlySpawn()
{
	newOrg = []; 
	newTrig = []; 
	for( i = 0; i < level.friendlySpawnOrg.size; i++ )
	{
		newOrg[newOrg.size] = level.friendlySpawnOrg[i]; 
		newTrig[newTrig.size] = level.friendlySpawnTrigger[i]; 
	}
	level.friendlySpawnOrg = newOrg; 
	level.friendlySpawnTrigger = newTrig; 
	
	if( activeFriendlySpawn() )
	{
		return; 
	}

	// If we've stepped back through all the spawners then turn off spawning
	flag_Clear( "spawning_friendlies" ); 
}

getFriendlySpawnStart()
{
	assert( level.friendlySpawnOrg.size > 0 ); 
	return( level.friendlySpawnOrg[level.friendlySpawnOrg.size-1] ); 
}

activeFriendlySpawn()
{
	return level.friendlySpawnOrg.size > 0; 
}
	
getFriendlySpawnTrigger()
{
	assert( level.friendlySpawnTrigger.size > 0 ); 
	return( level.friendlySpawnTrigger[level.friendlySpawnTrigger.size-1] ); 
}

setFriendlySpawn( org, trigger )
{
	level.friendlySpawnOrg[level.friendlySpawnOrg.size] = org.origin; 
	level.friendlySpawnTrigger[level.friendlySpawnTrigger.size] = trigger; 
	flag_set( "spawning_friendlies" ); 
}

// SCRIPTER_MOD
// MikeD( 3/23/2007 ): This is not used.
//delayedPlayerGoal()
//{
//	self endon( "death" ); 
//	self endon( "leaveSquad" ); 
//	wait( 0.5 ); 
//	self SetGoalEntity( level.player ); 
//}

spawnWaveStopTrigger( startTrigger )
{
	self notify( "stopTrigger" ); 
	self endon( "stopTrigger" ); 
	
	self waittill( "trigger" ); 
	if( getFriendlySpawnTrigger() != startTrigger )
	{
		return; 
	}

	unsetFriendlySpawn(); 		
}

friendlySpawnWave_triggerThink( startTrigger )
{
	org = GetEnt( self.target, "targetname" ); 
//	thread linedraw(); 
	
	for( ;; )
	{
		self waittill( "trigger" ); 
		startTrigger notify( "friendly_wave_start", org ); 
		if( !IsDefined( org.target ) )
		{
			continue; 
		}
	}
}


goalVolumes()
{
	volumes = GetEntArray( "info_volume", "classname" ); 
	level.deathchain_goalVolume = []; 
	level.goalVolumes = []; 
	
	for( i = 0; i < volumes.size; i++ )
	{
		volume = volumes[i]; 
		if( IsDefined( volume.script_deathChain ) )
		{
			level.deathchain_goalVolume[volume.script_deathChain] = volume; 
		}
		if( IsDefined( volume.script_goalvolume ) )
		{
			level.goalVolumes[volume.script_goalVolume] = volume; 
		}
	}
}

debugprInt( msg, endonmsg, color )
{
//	if( !level.debug_corevillers )
	if( 1 )
	{
		return; 
	}

	org = self GetOrigin(); 
	height = 40 * Sin( org[0] + org[1] ) - 40; 
	org = ( org[0], org[1], org[2] + height ); 
	level endon( endonmsg ); 
	self endon( "new_color" ); 
	if( !IsDefined( color ) )
	{
		color = ( 0, 0.8, 0.6 ); 
	}
	num = 0; 
	for( ;; )
	{
		num+= 12; 
		scale = Sin( num ) * 0.4; 
		if( scale < 0 )
		{
			scale *= -1; 
		}
		scale += 1; 
		print3d( org, msg, color, 1, scale ); 
		wait( 0.05 ); 
	}
}

aigroup_create( aigroup )
{
	level._ai_group[aigroup] = SpawnStruct(); 
	level._ai_group[aigroup].aicount = 0; 
	level._ai_group[aigroup].spawnercount = 0; 
	level._ai_group[aigroup].ai = []; 
	level._ai_group[aigroup].spawners = []; 
}

aigroup_spawnerthink( tracker )
{
	self endon( "death" ); 

	self.decremented = false; 
	tracker.spawnercount++; 

	self thread aigroup_spawnerdeath( tracker ); 
	self thread aigroup_spawnerempty( tracker ); 
	
	while( self.count )
	{
		self waittill( "spawned", soldier ); 
		
		if( spawn_failed( soldier ) )
		{
			continue; 
		}
		
		soldier thread aigroup_soldierthink( tracker ); 
	}
	waittillframeend; 
	
	if( self.decremented )
	{
		return; 
	}

	self.decremented = true; 
	tracker.spawnercount--; 
}

aigroup_spawnerdeath( tracker )
{
	self waittill( "death" ); 

	if( self.decremented )
	{
		return; 
	}

	tracker.spawnercount--; 
}

aigroup_spawnerempty( tracker )
{
	self endon( "death" ); 
	
	self waittill( "emptied spawner" ); 

	waittillframeend; 
	if( self.decremented )
	{
		return; 
	}

	self.decremented = true; 
	tracker.spawnercount--; 
}

aigroup_soldierthink( tracker )
{
	tracker.aicount++; 
	tracker.ai[tracker.ai.size] = self; 
	if ( isdefined( self.script_deathflag_longdeath ) )
	{
		self waittillDeathOrPainDeath();
	}
	else
	{
		self waittill( "death" );
	}
	
	tracker.aicount--; 
}


camper_trigger_think( trigger )
{
	// wait( 0.05 );
	tokens = strtok( trigger.script_linkto, " " );
	spawners = [];
	nodes = [];
	for ( i = 0; i < tokens.size; i++ )
	{
		token = tokens[ i ];
		ai = getent( token, "script_linkname" );
		if ( isdefined( ai ) )
		{
			spawners = add_to_array( spawners, ai ); 
			continue;
		}
		node = getnode( token, "script_linkname" );
		if ( !isdefined( node ) )
		{
			println( "Warning: Trigger token number " + token + " did not exist." );
			continue;
		}
		nodes = add_to_array( nodes, node ); 
	}
	assertEX( spawners.size, "camper_spawner without any spawners associated" );
	assertEX( nodes.size, "camper_spawner without any nodes associated" );
	assertEX( nodes.size >= spawners.size, "camper_spawner with less nodes than spawners" );
	
	trigger waittill( "trigger" );
	
	nodes = array_randomize( nodes );
	for ( i = 0; i < nodes.size; i++ )
		nodes[ i ].claimed = false;
	j = 0;
	for ( i = 0; i < spawners.size; i++ )
	{
		spawner = spawners[ i ];
		
		if ( !isdefined( spawner ) )
			continue;
		
		if ( isdefined( spawner.script_spawn_here ) )
		{
			// these guys spawn where they're placed
			continue;
		}
			
		while ( isdefined( nodes[ j ].script_noteworthy ) && nodes[ j ].script_noteworthy == "dont_spawn" )
			j++ ;
		spawner.origin = nodes[ j ].origin;
		spawner.angles = nodes[ j ].angles;
		spawner add_spawn_function( ::claim_a_node, nodes[ j ] );
		j++ ;
	}
	
	array_thread( spawners, ::add_spawn_function, ::camper_guy );
	array_thread( spawners, ::add_spawn_function, ::move_when_enemy_hides, nodes );
	array_thread( spawners, ::spawn_ai );
}

camper_guy()
{
	self.goalradius = 8;
	self.fixednode = true;
}


move_when_enemy_hides( nodes )
{
	self endon("death");
	
	waitingForEnemyToDisappear = false;
	
	while (1)
	{
		// it is important that we check whether our enemy is defined before doing a cansee check on him.
		if ( !isalive( self.enemy ) )
		{
			self waittill("enemy");
			waitingForEnemyToDisappear = false;
			continue;
		}
	
// CODER_MOD - JamesS
// no more level.player	
		if ( IsPlayer(self.enemy) )
		{
			if ( flag( "player_has_red_flashing_overlay" ) || flag( "player_flashed" ) )
			{
				// player is wounded, chase him with a suicide charge. One must fall!
				self.fixednode = 0;
				for ( ;; )
				{
					self.goalradius = 180;
					self setgoalpos( self.enemy.origin );
					wait( 1 );
				}
				return;
			}
		}

		if ( waitingForEnemyToDisappear )
		{
			if ( self cansee( self.enemy ) )
			{
				wait .05;
				continue;
			}
			waitingForEnemyToDisappear = false;
		}
		else
		{
			if ( self cansee( self.enemy ) )
			{
				// enemy is seen, wait until you cant see him
				waitingForEnemyToDisappear = true;
			}
			wait .05;
			continue;
		}
		
		// you cant see him, 2/3rds of the time move to a different node
		if ( randomint( 3 ) > 0 )
		{
			node = find_unclaimed_node( nodes );
			if ( isdefined ( node ) )
			{
				self claim_a_node ( node , self.claimed_node );
				self setgoalnode( node );
				self waittill ( "goal" );
			}
		}
	}
}

claim_a_node( claimed_node, old_claimed_node )
{
	self setgoalnode( claimed_node );
	self.claimed_node = claimed_node;
	claimed_node.claimed = true;
	if ( isdefined( old_claimed_node ) )
		old_claimed_node.claimed = false;
		
// 	self OrientMode( "face angle", claimed_node.angles[ 1 ] );
}

find_unclaimed_node( nodes )
{
	for ( i=0; i < nodes.size; i++ )
	{
		if ( nodes[i].claimed )
			continue;
		else
			return nodes[i];
	}
	return undefined;
}



// flood_spawner

flood_trigger_think( trigger )
{
	assertEX( isDefined( trigger.target ), "flood_spawner at " + trigger.origin + " without target" );
	
	floodSpawners = GetEntArray( trigger.target, "targetname" ); 
	assertex( floodSpawners.size, "flood_spawner at with target " + trigger.target + " without any targets" ); 
	
	for(i = 0; i < floodSpawners.size; i ++)
	{
		floodSpawners[i].script_trigger = trigger;
	}
	
/*	choke = true;
	
	if(isdefined(trigger.script_choke) && !trigger.script_choke)
	{
		choke = true;
	}	

	for(i = 0; i < floodSpawners.size; i ++)
	{
		floodSpawners[i].script_choke = choke;
	}

	*/
	array_thread( floodSpawners, ::flood_spawner_init ); 
	
	trigger waittill( "trigger" ); 
	// reget the target array since targets may have been deletes, etc... between initialization and triggering
	floodSpawners = GetEntArray( trigger.target, "targetname" ); 
/*	if(choke && NumRemoteClients())
	{
		spread_array_thread(floodSpawners, ::flood_spawner_think, trigger);
	}
	else*/
	{
		array_thread( floodSpawners, ::flood_spawner_think, trigger ); 
	}
}


flood_spawner_init( spawner )
{
	assertex( ( IsDefined( self.spawnflags ) && self.spawnflags & 1 ), "Spawner at origin" + self.origin + "/" +( self GetOrigin() ) + " is not a spawner!" ); 
}

trigger_requires_player( trigger )
{
	if( !IsDefined( trigger ) )
	{
		return false; 
	}
		
	return IsDefined( trigger.script_requires_player ); 
}

two_stage_spawner_think( trigger )
{
	trigger_target = getent( trigger.target, "targetname" );
	assertEx( isdefined( trigger_target ), "Trigger with targetname two_stage_spawner that doesnt target anything." );
	assertEx( issubstr( trigger_target.classname, "trigger" ), "Triggers with targetname two_stage_spawner must target a trigger" );
	assertEx( isdefined( trigger_target.target ), "The second trigger of a two_stage_spawner must target at least one spawner" );
	
	// wait until _spawner has initialized before adding spawn functions
	waittillframeend;
	
	spawners = getentarray( trigger_target.target, "targetname" );
	for ( i=0; i < spawners.size; i++ )
	{
		spawners[ i ].script_moveoverride = true;
		spawners[ i ] add_spawn_function( ::wait_to_go, trigger_target );
	}
	
	trigger waittill( "trigger" );

	spawners = getentarray( trigger_target.target, "targetname" );
	array_thread( spawners, ::spawn_ai );
}

wait_to_go( trigger_target )
{
	trigger_target endon( "death" );
	self endon( "death" );
	self.goalradius	= 8;
	
	trigger_target waittill( "trigger" );
	
	self thread go_to_node();
}

flood_spawner_think( trigger )
{
	self endon( "death" ); 
	self notify( "stop current floodspawner" ); 
	self endon( "stop current floodspawner" ); 

	// pyramid spawner is a spawner that targets another spawner or spawners
	// First the targetted spawners spawn, then when they die, the reinforcement spawns from
	// the spawner this initial spawner
	if( is_pyramid_spawner() )
	{
		pyramid_Spawn( trigger ); 
		return; 
	}
		
	requires_player = trigger_requires_player( trigger ); 

	script_delay(); 
	
	while( self.count > 0 )
	{
// SCRIPTER_MOD
// MikeD( 3/23/2007 ): No more level.player. So now we see if any player is touching the trigger.
//		while( requires_player && !level.player IsTouching( trigger ) )

// AlexL (6/26/2007): This line asserts when trigger is undefined. New version accomodated undefined trigger.
//		while( requires_player && !any_player_IsTouching( trigger ) )
		if( requires_player ) // 0 if trigger is undefined
		{
			while( !any_player_IsTouching( trigger ) )
			{
				wait( 0.5 ); 
			}
		}

		while(!(self ok_to_trigger_spawn()))
		{
			wait_network_frame();
		}

		if( isdefined( self.script_noenemyinfo ) && isdefined( self.script_forcespawn ) )
			soldier = self stalingradSpawn( true );
		else if( isdefined( self.script_noenemyinfo ) )
			soldier = self doSpawn( true );
		else if( isdefined( self.script_forcespawn ) )
			soldier = self stalingradSpawn();
		else
			soldier = self doSpawn();

		if( spawn_failed( soldier ) )
		{
			wait( 2 ); 
			continue; 
		}

		level._numTriggerSpawned ++;

		soldier thread reincrement_count_if_deleted( self ); 
		soldier thread expand_goalradius( trigger ); 

		soldier waittill( "death", attacker );

		if ( !player_saw_kill( soldier, attacker ) )
		{
			self.count++;
		}

		// soldier was deleted, not killed
		if( !IsDefined( soldier ) )
		{
			continue; 
		}

		if( !script_wait( true ) )
		{
			players = get_players();
			
			if (players.size == 1)
			{
				wait( RandomFloatrange( 5, 9 ) ); 
			}
			else if (players.size == 2)
			{
				wait( RandomFloatrange( 3, 6 ) ); 
			}	
			else if (players.size == 3)
			{
				wait( RandomFloatrange( 1, 4 ) ); 
			}		
			else if (players.size == 4)
			{
				wait( RandomFloatrange( 0.5, 1.5 ) ); 
			}	
		}
	}
}

player_saw_kill( guy, attacker )
{
	if ( isdefined( self.script_force_count ) )
		if ( self.script_force_count )
			return true;

	if ( !isdefined( guy ) )
	{
		return false;
	}
	
	if ( IsAlive( attacker ) )
	{
		if ( IsPlayer( attacker ) )
		{
			return true;
		}

		players = get_players();

		for( q = 0; q < players.size; q++ )
		{
			if ( DistanceSquared( attacker.origin, players[q].origin ) < 200 * 200 )
			{
				// player was near the guy that killed the ai?
				return true;
			}
		}
	}
	else
	{
		if ( isdefined( attacker ) )
		{
			if ( attacker.classname	== "worldspawn" )
			{
				return false;
			}
				
			// CODER_MOD got rid of level.player
			player = get_closest_player( attacker.origin );
			if ( isdefined( player ) && distance( attacker.origin, player.origin ) < 200 )
			{
				// player was near the guy that killed the ai?
				return true;
			}
		}
	}
	
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, we'll get the closest player instead
//	if( Distance( level.player.origin, org ) < 700 )
	closest_player = get_closest_player( guy.origin ); 
	if (  isdefined( closest_player ) && distance( guy.origin, closest_player.origin ) < 200 )
	{
		// player was near the guy that got killed?
		return true;
	}

	// did the player see the guy die?
	return bulletTracePassed( closest_player geteye(), guy geteye(), false, undefined );
}

is_pyramid_spawner()
{
	if( !IsDefined( self.target ) )
	{
		return false; 
	}
		
	ent = GetEntArray( self.target, "targetname" ); 
	if( !ent.size )
	{
		return false; 
	}
			
	return IsSubStr( ent[0].classname, "actor" ); 
}


pyramid_death_report( spawner )
{
	spawner.spawn waittill( "death" ); 
	self notify( "death_report" ); 
}

pyramid_Spawn( trigger )
{

	self endon( "death" ); 
	requires_player = trigger_requires_player( trigger ); 

	script_delay(); 

	if( requires_player )
	{
// SCRIPTER_MOD
// MikeD( 3/23/2007 ): No more level.player, now we check to see if any player is touching the trigger.
//		while( !level.player IsTouching( trigger ) )
		while( !any_player_IsTouching( trigger ) )
		{
			wait( 0.5 ); 
		}
	}
	
	// first spawn all the guys we target. They decrement our count tho, so we spawn them in a random order in case 
	// our count is just 1( default )
	
	spawners = GetEntArray( self.target, "targetname" ); 
	/#
		for( i = 0; i < spawners.size; i++ )
		{
			assertex( IsSubStr( spawners[i].classname, "actor" ), "Pyramid spawner targets non AI!" ); 
		}
	#/
	
	// the spawners have to report their death to the head of the pyramid so it can kill itself when they're all gone
	self.spawners = 0; 
	array_thread( spawners, ::pyramid_spawner_reports_death, self ); 
	
	offset = RandomInt( spawners.size ); 
	for( i = 0; i < spawners.size; i++ )
	{
		if( self.count <= 0 )
		{
			return; 
		}
		
		offset++; 
		if( offset >= spawners.size )
		{
			offset = 0; 
		}
		spawner = spawners[offset]; 
		
		// the count is local to self, not to the spawners that are targetted
		spawner.count = 1; 
		
		while(!(self ok_to_trigger_spawn()))
		{
			wait_network_frame();
		}
		
		soldier = spawner spawn_ai(); 
		
		level._numTriggerSpawned++;
		
		if( spawn_failed( soldier ) )
		{
//			assertex( 0, "Initial spawning from spawner at " + self.origin + " failed." ); 
			wait( 2 ); 
			continue; 
		}

		self.count--; 
		spawner.spawn = soldier; 
		
		soldier thread reincrement_count_if_deleted( self ); 
		soldier thread expand_goalradius( trigger ); 
		thread pyramid_death_report( spawner ); 
	}
	
	culmulative_wait = 0.01; 
	while( self.count > 0 )
	{
		self waittill( "death_report" ); 
		script_wait( true ); 
		wait( culmulative_wait ); 
		culmulative_wait+= 2.5; 
	
		offset = RandomInt( spawners.size ); 
		for( i = 0; i < spawners.size; i++ )
		{
			// cleanup in case any spawners were deleted
			spawners = array_removeUndefined( spawners ); 			
			
			if( !spawners.size )
			{
				if( IsDefined( self ) )
				{
					self Delete(); 
				}
				return; 
			}

			offset++; 
			if( offset >= spawners.size )
			{
				offset = 0; 
			}
			
			spawner = spawners[offset]; 
			
			// find a spawner that has lost its AI
			if( IsAlive( spawner.spawn ) )
			{
				continue; 
			}
	
			// spawn from self now, we're reinforcement			
			if( IsDefined( spawner.target ) )
			{
				self.target = spawner.target; 
			}
			else
			{
				self.target = undefined; 
			}
			
			while(!(self ok_to_trigger_spawn()))
			{
				wait_network_frame();
			}
				
			soldier = self spawn_ai(); 
			if( spawn_failed( soldier ) )
			{
				wait( 2 ); 
				continue; 
			}

			level._numTriggerSpawned ++;

			assertex( IsDefined( spawner ), "Theoretically impossible." ); 
			soldier thread reincrement_count_if_deleted( self ); 
			soldier thread expand_goalradius( trigger ); 
			spawner.spawn = soldier; 
			thread pyramid_death_report( spawner ); 
			
			if( self.count <= 0 )
			{
				return; 
			}
		}
	}
}

pyramid_spawner_reports_death( parent )
{
	parent endon( "death" ); 
	parent.spawners++; 
	self waittill( "death" ); 
	parent.spawners--; 
	if( !parent.spawners )
	{
		parent Delete(); 
	}
}

expand_goalradius( trigger )
{
	if( IsDefined( self.script_forcegoal ) )
	{
		return; 
	}

	// triggers with a script_radius of -1 dont override the goalradius
	// triggers with a script_radius of anything else set the goalradius to that size
	radius = level.default_goalradius; 
	if( IsDefined( trigger ) )
	{
		if( IsDefined( trigger.script_radius ) )
		{
			if( trigger.script_radius == -1 )
			{
				return; 
			}
			radius = trigger.script_radius; 
		}
	}

	if ( isdefined( self.script_forcegoal ) )
		return;

	// expands the goalradius of the ai after they reach there initial goal.
	self endon( "death" ); 
	self waittill( "goal" ); 
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
	for( ;; )
	{
		line( org +( 0, 0, 100 ), org, ( 0.2, 0.5, 0.8 ), 0.5 ); 
		wait( 0.05 ); 
	}
}

/*drophealth()
{
	// wait until regular scripts have a change to set self.script_nohealth on the guy from script, after spawn_failed.
	waittillframeend; 
	waittillframeend; 

	if( !IsAlive( self ) )
	{
		return; 
	}
	
	if( IsDefined( self.script_nohealth ) )
	{
		return; 
	}
	
	self waittill( "death" ); 
	
	if( !IsDefined( self ) )
	{
		return; 
	}
		
	// drop health disabled once again
	if( 1 )
	{
		return; 
	}
		

	// has enough time passed since the last health drop?
	if( GetTime() < level.next_health_drop_time )
	{
		return; 
	}
		
	// have enough guys died?
	level.guys_to_die_before_next_health_drop--; 
	if( level.guys_to_die_before_next_health_drop > 0 )
	{
		return; 
	}
	
	level.guys_to_die_before_next_health_drop = RandomIntRange( 2, 5 ); 
	level.next_health_drop_time = GetTime() + 3500; // probably make this a _gameskill thing later
	
	trace = BulletTrace( self.origin +( 0, 0, 50 ), self.origin +( 0, 0, -220 ), true, self ); 
	health = Spawn( "script_model", self.origin +( 0, 0, 10 ) ); 
	health.origin = trace["position"]; 
//	health setmodel( "com_trashbag" );
	
	trigger = Spawn( "trigger_radius", self.origin +( 0, 0, 10 ), 0, 10, 32 ); 
	trigger.radius = 10; 

	trigger drop_health_trigger_think(); 	
	
	trigger Delete(); 
	health Delete(); 
	

//	health = Spawn( "item_health", self.origin +( 0, 0, 10 ) ); 
//	health.angles = ( 0, RandomInt( 360 ), 0 ); 

	/*
	if( IsDefined( level._health_queue ) )
	{
		if( IsDefined( level._health_queue[level._health_queue_num] ) )
		{
			level._health_queue[level._health_queue_num] Delete(); 
		}
	}

	level._health_queue[level._health_queue_num] = health; 
 	level._health_queue_num++; 
 	if( level._health_queue_num > level._health_queue_max )
	{
	 	level._health_queue_num = 0; 
	}
	 */
//}

show_bad_path()
{
	 /#
	if ( getdebugdvar( "debug_badpath" ) == "" )
		setdvar( "debug_badpath", "" );

	self endon( "death" );
	last_bad_path_time = -5000;
	bad_path_count = 0;
	for ( ;; )
	{
		self waittill( "bad_path", badPathPos );
		
		if ( !isDefined(level.debug_badpath) || !level.debug_badpath )
			continue;

		if ( gettime() - last_bad_path_time > 5000 )
		{
			bad_path_count = 0;
		}
		else
		{
			bad_path_count++;
		}

		last_bad_path_time = gettime();

		if ( bad_path_count < 10 )
			continue;
		
		for ( p = 0; p < 10 * 20; p++ )
		{
			line( self.origin, badPathPos, ( 1, 0.4, 0.1 ), 0, 10 * 20 );
			wait( 0.05 );
		}
	}		
	#/ 
}


random_Spawn( trigger )
{
	trigger waittill( "trigger" ); 
	// get a random target and all the links to that target and spawn them
	spawners = GetEntArray( trigger.target, "targetname" ); 
	if( !spawners.size )
	{
		return; 
	}
	spawner = random( spawners ); 
	
	spawners = []; 
	spawners[spawners.size] = spawner; 
	// grab the other spawners linked to the parent spawner
	if( IsDefined( spawner.script_linkto ) )
	{
		links = Strtok( spawner.script_linkto, " " ); 
		for( i = 0; i < links.size; i++ )
		{
			spawners[spawners.size] = GetEnt( links[i], "script_linkname" ); 
		}
	}

	waittillframeend; // _load needs to finish entirely before we can add spawn functions to spawners	
	array_thread( spawners, ::add_spawn_function, ::blowout_goalradius_on_pathend ); 
	array_thread( spawners, ::spawn_ai ); 
}

blowout_goalradius_on_pathend()
{
	if( IsDefined( self.script_forcegoal ) )
	{
		return; 
	}
		
	self endon( "death" ); 
	self waittill( "reached_path_end" ); 
	self.goalradius = level.default_goalradius; 
}

objective_event_init( trigger )
{
	flag = trigger get_trigger_flag(); 
	assertex( IsDefined( flag ), "Objective event at origin " + trigger.origin + " does not have a script_flag. " ); 
	flag_init( flag ); 
		
	assertex( IsDefined( level.deathSpawner[trigger.script_deathChain] ), "The objective event trigger for deathchain " + trigger.script_deathchain + " is not associated with any AI." ); 
	/#
	if( !IsDefined( level.deathSpawner[trigger.script_deathChain] ) )
	{
		return; 
	}
	#/
	while( level.deathSpawner[trigger.script_deathChain] > 0 )
	{
		level waittill( "spawner_expired" + trigger.script_deathChain ); 
	}
		
	flag_set( flag ); 
}

setup_ai_eq_triggers()
{
	self endon( "death" ); 
	// ai placed in the level run their spawn func before the triggers are initialized
	waittillframeend; 

// SCRIPTER_MOD
// MikeD( 3/23/2007 ): No more level.player
//	self.is_the_player = self == level.player; 
	self.is_the_player = IsPlayer( self ); 
	self.eq_table = []; 
	self.eq_touching = []; 
	for( i = 0; i < level.eq_trigger_num; i++ )
	{
		self.eq_table[i] = false; 
	}
}

ai_array()
{
	level.ai_array[level.ai_number] = self; 
	self waittill( "death" ); 
	waittillframeend; 
	level.ai_array[level.ai_number] = undefined; 
}




player_score_think()
{
	if( self.team == "allies" )
	{
		return; 
	}
	self waittill( "death", attacker ); 
// SCRIPTER_MOD
// MikeD( 3/23/2007 ): No more level.player
//	if( ( IsDefined( attacker ) ) &&( attacker == level.player ) )
//		level.player thread updatePlayerScore( 1 + RandomInt( 3 ) ); 

	if( IsDefined( attacker ) && IsPlayer( attacker ) )
	{
		attacker thread updatePlayerScore( 1 + RandomInt( 3 ) ); 
	}
}


updatePlayerScore( amount )
{
	if( amount == 0 )
	{
		return; 
	}

	self notify( "update_xp" ); 
	self endon( "update_xp" ); 

	self.rankUpdateTotal += amount; 

	self.hud_rankscroreupdate.label = &"SCRIPT_PLUS"; 
		
	self.hud_rankscroreupdate Setvalue( self.rankUpdateTotal ); 
	self.hud_rankscroreupdate.alpha = 1; 
	self.hud_rankscroreupdate thread fontPulse( self ); 

	wait( 1 ); 
	self.hud_rankscroreupdate FadeOverTime( 0.75 ); 
	self.hud_rankscroreupdate.alpha = 0; 
	
	self.rankUpdateTotal = 0; 
}

 
xp_init()
{
	self.rankUpdateTotal = 0; 
	self.hud_rankscroreupdate = NewHudElem( self ); 
	self.hud_rankscroreupdate.horzAlign = "center"; 
	self.hud_rankscroreupdate.vertAlign = "middle"; 
	self.hud_rankscroreupdate.alignX = "center"; 
	self.hud_rankscroreupdate.alignY = "middle"; 
	self.hud_rankscroreupdate.x = 0; 
	self.hud_rankscroreupdate.y = -60; 
	self.hud_rankscroreupdate.font = "default"; 
	self.hud_rankscroreupdate.fontscale = 2; 
	self.hud_rankscroreupdate.archived = false; 
	self.hud_rankscroreupdate.color = ( 1, 1, 1 ); 
	self.hud_rankscroreupdate fontPulseInit(); 
}

fontPulseInit()
{
	self.baseFontScale = self.fontScale; 
	self.maxFontScale = self.fontScale * 2; 
	self.inFrames = 3; 
	self.outFrames = 5; 
}


fontPulse( player )
{
	self notify( "fontPulse" ); 
	self endon( "fontPulse" ); 
	
	scaleRange = self.maxFontScale - self.baseFontScale; 
	
	while( self.fontScale < self.maxFontScale )
	{
		self.fontScale = min( self.maxFontScale, self.fontScale +( scaleRange / self.inFrames ) ); 
		wait( 0.05 ); 
	}
		
	while( self.fontScale > self.baseFontScale )
	{
		self.fontScale = max( self.baseFontScale, self.fontScale -( scaleRange / self.outFrames ) ); 
		wait( 0.05 ); 
	}
}

#using_animtree( "generic_human" );
spawner_dronespawn( spawner )
{
	assert( isdefined( level.dronestruct[ spawner.classname ] ) );
	struct = level.dronestruct[ spawner.classname ];
	drone = spawn( "script_model", spawner.origin );
	drone.angles = spawner.angles;
	drone setmodel( struct.model );
// 	drone hide();
	drone UseAnimTree( #animtree );
	drone makefakeai();
	attachedmodels = struct.attachedmodels;
	attachedtags = struct.attachedtags;
	for ( i = 0;i < attachedmodels.size;i++ )
		drone attach( attachedmodels[ i ], attachedtags[ i ] );
	if ( isdefined( spawner.script_startingposition ) )
		drone.script_startingposition = spawner.script_startingposition;
	if ( isdefined( spawner.script_noteworthy ) )
		drone.script_noteworthy = spawner.script_noteworthy;
	if ( isdefined( spawner.script_deleteai ) )
		drone.script_deleteai = spawner.script_deleteai;
	if ( isdefined( spawner.script_linkto ) )
		drone.script_linkto = spawner.script_linkto;
	if ( isdefined( spawner.script_moveoverride ) )
		drone.script_moveoverride = spawner.script_moveoverride;
	// for later use to makerealai
	if ( issubstr( spawner.classname, "ally" ) )
		drone.team = "allies";
	else if ( issubstr( spawner.classname, "enemy" ) )
		drone.team = "axis";
	else
		drone.team = "neutral";
	if ( isdefined( spawner.target ) )
		drone.target = spawner.target;
	drone.spawner = spawner;
	assert( isdefined( drone ) );
	if ( isdefined( spawner.script_noteworthy ) && spawner.script_noteworthy == "drone_delete_on_unload" )
		drone.drone_delete_on_unload = true; 
	else 
		drone.drone_delete_on_unload = false;
	
	spawner notify( "drone_spawned", drone );
	return drone;
}
spawner_makerealai( drone )
{
	if(!isdefined(drone.spawner))
	{
		println("----failed dronespawned guy info----");
		println("drone.classname: "+drone.classname);
		println("drone.origin   : "+drone.origin); 
		assertmsg("makerealai called on drone does with no .spawner");
	}
	orgorg = drone.spawner.origin; 
	organg = drone.spawner.angles; 
	drone.spawner.origin = drone.origin; 
	drone.spawner.angles = drone.angles; 
	guy = drone.spawner stalingradspawn();
	failed = spawn_failed(guy);
	if(failed)
	{
		println("----failed dronespawned guy info----");
		println("failed guys spawn position : "+drone.origin);
		println("failed guys spawner export key: "+drone.spawner.export);
		println("getaiarray size is: "+getaiarray().size);
		println("------------------------------------");
		assertMSG("failed to make real ai out of drone (see console for more info)");
	}
	drone.spawner.origin = orgorg; 
	drone.spawner.angles = organg; 
	drone Delete(); 
	return guy; 
}


hiding_door_spawner()
{
	// place a hiding_door_guy prefab and then place a spawner next to it with script_noteworthy "hiding_door_spawner". 
	// Spawn the guy however you like (trigger or script)
	// Target the spawner to a trigger, this trigger will make the guy open the door.
	// Alternatively put a script_flag_wait on the spawner. The guy will wait for the flag to be set before opening the door.
	// If you put neither, a trigger_radius will be spawned, using the radius of the spawner if a radius is set
	
	
	door_orgs = getentarray( "hiding_door_guy_org", "targetname" );
	assertex( door_orgs.size, "Hiding door guy with export " + self.export + " couldn't find a hiding_door_org!" );
	
	door_org = getclosest( self.origin, door_orgs );
	assertex( distance( door_org.origin, self.origin ) < 256, "Hiding door guy with export " + self.export + " was not placed within 256 units of a hiding_door_org" );
	
	door_org.targetname = undefined; // so future searches won't grab this one
	door_model = getent( door_org.target, "targetname" );
	
	door_clip = getent( door_model.target, "targetname" );
	assert( isdefined( door_model.target ) );
	
	pushPlayerClip = undefined;
	if ( isdefined( door_clip.target ) )
		pushPlayerClip = getent( door_clip.target, "targetname" );
	if ( isdefined( pushPlayerClip ) )
		door_org thread hiding_door_guy_pushplayer( pushPlayerClip );
	
	door_model delete(); // we spawn our own door, the one in the prefab is just to aid placement
	
	door = spawn_anim_model( "hiding_door" );
	
	door_org thread anim_first_frame_solo( door, "fire_3" );
	
	if( isdefined( door_clip ) )
	{
		door_clip linkto( door, "door_hinge_jnt" );
		door_clip disconnectPaths();
	}
	
	trigger = undefined;
	if ( isdefined( self.target ) )
	{
		trigger = getent( self.target, "targetname" );
		if ( !issubstr( trigger.classname, "trigger" ) )
			trigger = undefined;
	}
	
	if ( !isdefined( self.script_flag_wait ) && !isdefined( trigger ) )
	{
		radius = 200;
		if ( isdefined( self.radius ) )
			radius = self.radius;
			
		// no trigger mechanism specified, so add a radius trigger
		trigger = spawn( "trigger_radius", door_org.origin, 0, radius, 48 );
	}
	
	self add_spawn_function( ::hiding_door_guy, door_org, trigger, door, door_clip );
	self waittill( "spawned" );
}

hiding_door_guy( door_org, trigger, door, door_clip )
{
	starts_open = hiding_door_starts_open( door_org );

	self.animname = "hiding_door_guy";
	self endon( "death" );
	
	self.grenadeammo = 2;
	
	self set_deathanim( "death_2" );
	self.allowdeath = true;
	self.health = 50000; // buffer health, he "dies" in one hit

	guy_and_door = [];
	guy_and_door[ guy_and_door.size ] = door;
	guy_and_door[ guy_and_door.size ] = self;
	
	thread hiding_door_guy_cleanup( door_org, self, door, door_clip );
	
	thread hiding_door_death( door, door_org, self, door_clip );

	if ( starts_open )
	{
		// wait for trigger before closing the door
		door_org thread anim_loop( guy_and_door, "idle" );
	}
	else
	{
		door_org thread anim_first_frame( guy_and_door, "fire_3" );
	}
	
	if ( isdefined( trigger	) )
	{
		trigger waittill( "trigger" );
	}
	else
	{
		flag_wait( self.script_flag_wait );
	}

	if ( starts_open )
	{
		door_org notify( "stop_loop" );
		door_org anim_single( guy_and_door, "close" );
	}

	for ( ;; )
	{
		scene = "fire_3";
		if ( randomint( 100 ) < 25 * self.grenadeammo )
		{
			self.grenadeammo--;
			scene = "grenade"; // once the grenade throw has the notetrack we'll change this
		}

		door_org thread anim_single( guy_and_door, scene );

		// delay the settime by a frame or it wont work
		delaythread( 0.05, ::anim_set_time, guy_and_door, scene, 0.4 );

		door_org waittill( scene );

		door_org thread anim_loop( guy_and_door, "idle" );
		wait( randomfloat( 0.25, 1.5 ) );
		door_org notify( "stop_loop" );
	}
}

hiding_door_guy_cleanup( door_org, guy, door, door_clip )
{
	// if the guy gets deleted before the sequence happens this thread will catch that and clean up any problems that could arise
	guy waittill( "death" );
	
	// stop the looping animations because the guy is removed now
	door_org notify( "stop_loop" );
	
	thread hiding_door_death_door_connections( door_clip );
	door_org notify( "push_player" );
	door_org thread anim_single_solo( door, "death_2" );
}

hiding_door_guy_pushplayer( pushPlayerClip )
{
	self waittill( "push_player" );
	pushPlayerClip moveto( self.origin, 1.5 );
	wait 3.0;
	pushPlayerClip delete();
}

hiding_door_guy_grenade_throw( guy )
{
	// called from a notetrack
	startOrigin = guy getTagOrigin( "J_Wrist_RI" );
	player = get_closest_player( guy.origin );	
	strength = ( distance( player.origin, guy.origin ) * 2.0 );
	if ( strength < 300 )
		strength = 300;
	if ( strength > 1000 )
		strength = 1000;
	vector = vectorNormalize( player.origin - guy.origin );
	velocity = vectorScale( vector, strength );
	guy magicGrenadeManual( startOrigin, velocity, randomfloatrange( 3.0, 5.0 ) );
}

hiding_door_death( door, door_org, guy, door_clip )
{
	guy waittill( "damage" );
	if ( !isalive( guy ) )
		return;
	guys = [];
	guys[ guys.size ] = door;
	guys[ guys.size ] = guy;
	thread hiding_door_death_door_connections( door_clip );
	door_org notify( "push_player" );
	door_org thread anim_single( guys, "death_2" );
	wait( 0.5 );
	if ( isalive( guy ) )
	{
		//guy.a.nodeath = true;
		guy dodamage( guy.health + 150, (0,0,0) );
	}
}

hiding_door_death_door_connections( door_clip )
{
	if( !isdefined( door_clip ) )
		return;
	
	door_clip connectpaths();
	wait 2;
	door_clip disconnectpaths();
}

hiding_door_starts_open( door_org )
{
	return isdefined( door_org.script_noteworthy );
}
