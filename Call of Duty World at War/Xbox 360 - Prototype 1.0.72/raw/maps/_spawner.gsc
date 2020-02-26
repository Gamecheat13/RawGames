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
	level.current_spawn_num = 0; 
	level.killedaxis = 0; 
	level.ffpoints = 0; 
	level.missionfailed = false; 
	level.gather_delay = []; 
	level.smoke_thrown = []; 
	level.smoke_thrower = []; 
	level.deathflags = [];
	level.spawner_number = 0;

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

	spawners = GetSpawnerArray(); 
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[i] thread spawn_prethink(); 
	}

	thread process_deathflags();

	array_thread( ai, ::spawn_think );
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

	self waittill( "death" );

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
	trigger endon( "death" ); 
	for( ;; )
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
	for( ;; )
	{
		trigger waittill( "trigger", guy );
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
		
		guy = spawner spawn_ai(); 
			
		if( spawn_failed( guy ) )
		{
			spawner notify( "spawn_failed" ); 
		}
		if( IsDefined( self.Wait ) &&( self.Wait > 0 ) )
		{
			wait( self.Wait ); 
		}
	}
}

trigger_spawner( trigger )
{
	assertEx( isdefined( trigger.target ), "Triggers with flag TRIGGER_SPAWN " + trigger.origin + " must target at least one spawner." );
	
	trigger endon( "death" ); 
	trigger waittill( "trigger" ); 
	spawners = GetEntArray( trigger.target, "targetname" ); 
	
	for( i = 0; i < spawners.size; i++ )
	{
		if( IsDefined( spawners[i].script_forcespawn ) )
		{
			spawned = spawners[i] StalingradSpawn(); 
		}
		else
		{
			spawned = spawners[i] DoSpawn(); 
		}
	}
}

flood_spawner_scripted( spawners )
{
	assertex( IsDefined( spawners ) && spawners.size, "Script tried to flood spawn without any spawners" ); 

	maps\_utility::array_thread( spawners, ::flood_spawner_init ); 
	maps\_utility::array_thread( spawners, ::flood_spawner_think ); 
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



// spawn maximum 16 grenades per team
spawn_grenade( origin, team )
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

	grenade = Spawn( "weapon_fraggrenade", origin ); 
	level.grenade_cache[team][index] = grenade; 

	level.grenade_cache_index[team] = ( index + 1 ) % 16; 

	return grenade; 
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

	self.decomissioned = true;

	if( self.grenadeAmmo <= 0 )
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
		
spawn_grenade_bag( org, angles, team )
{
	grenade = spawn_grenade( org, team ); 

	// SCRIPTER_MOD
	// MikeD( 03/07/07 ): Changed "grenade_bag" to "german_grenade_bag"
	grenade SetModel( "grenade_bag" ); 
	grenade.count = 3; 
//	wait( 0.2 ); 
//	if( IsDefined( grenade ) )
	grenade.angles = angles; 
	return grenade; 
}

guy_convert_to_drone( guy )
{
	dronespawn_setstruct_from_guy ( guy );
	guy delete();
	
}

dronespawn_check()
{
	//spawn a guy, grab his info. delete him. Poor guy
	if(isdefined(level.dronestruct[self.classname]))
		return true;
	return false;
	
}

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

dronespawn_setstruct( spawner )
{
	//spawn a guy, grab his info. delete him. Poor guy
	if(dronespawn_check())
		return;
	guy = spawner stalingradspawn();  //first frame everybody spawns and spawn_failed isn't effective yet
//	failed = spawn_failed(guy);
//	assert(!failed);
	spawner.count ++; //replenish the spawner
	dronespawn_setstruct_from_guy ( guy );
	guy delete();
}

empty()
{
}

spawn_prethink()
{
	assert( self != level ); 
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
		
		/*
		if( !IsSentient( spawn ) || !IsAlive( spawn ) )
		{
			prof_end( "spawn_prethink" ); 
			continue; 
		}
		*/
		
				
//		level thread debug_message( "SPAWNED", spawned.origin ); 

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
spawn_think( targetname )
{
	assert( self != level ); 
	spawn_think_action( targetname ); 
	assert( IsAlive( self ) ); 
	
	thread run_spawn_functions();
	
	self.finished_spawning = true;
	self notify( "finished spawning" );
	assert( isdefined( self.team ) );
	if ( self.team == "allies" && !isdefined( self.script_nofriendlywave ) )
		self thread friendlydeath_thread();
}

run_spawn_functions()
{
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
}

// Actually do the spawn_think
spawn_think_action( targetname )
{
	self thread tanksquish(); 

	// ai get their values from spawners and theres no need to have this value on ai
	self.spawner_number = undefined;

	/#
	if( GetDebugDvar( "debug_misstime" ) == "start" )
	{
		self thread maps\_debug::debugMisstime(); 
	}
		
	thread show_bad_path(); 
	#/

	if( !IsDefined( self.ai_number ) )
	{
		set_ai_number(); 
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

	if ( isdefined( self.script_forceColor ) )
	{
		// send all forcecolor through a centralized function
		set_force_color( self.script_forceColor );
	}
	
	if ( isdefined( self.script_fixednode ) )
	{
		// force the fixednode setting on an ai
		self.script_fixednode = ( self.script_fixednode == 1 );
	}
	else
	{
		// allies use fixednode by default
		self.fixednode = self.team == "allies";
	}

	// allies use "provide covering fire" mode in fixednode mode.
	self.provideCoveringFire = self.team == "allies" && self.fixedNode;

	
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
	
	assertex( self.pathEnemyLookAhead == 0 && self.pathEnemyFightDist == 0, "Tried to change pathenemyFightDist or pathenemyLookAhead on an AI before running spawn_failed on guy with export " + self.export ); 
	set_default_pathenemy_settings(); 

	portableMG42guy = IsSubStr( self.classname, "mgportable" ) || IsSubStr( self.classname, "30cal" ); 
	
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

	if( IsDefined( self.script_sightrange ) )
	{
		self.maxSightDistSqrd = self.script_sightrange; 
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

	if( self.team == "axis" && self.type == "human" )
	{
		self thread drop_gear(); 
		self thread drophealth(); 
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
	if( IsDefined( self.script_longdeath ) && self.script_longdeath == false )
	{
		self.a.disableLongDeath = true; 	
		assertex( self.team != "allies", "Allies can't do long death, so why disable it on the guy at " + self.origin + "?" ); 
	}
	else
	{
		// Make axis have 150 health so they can do dying pain.
		if( self.team == "axis" && !portableMG42guy )
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
	else
	{
		self.grenadeAmmo = 3; 
	}
		
		
	if( IsDefined( self.script_flashbangs ) )
	{
		self.grenadeWeapon = "flash_grenade"; 
		self.grenadeAmmo = self.script_flashbangs; 
	}

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

	// The AI will spawn and attack the player
	if( IsDefined( self.script_playerseek ) )
	{
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, now we will find the closest player to me, and make him my goalentity
//		self SetGoalEntity( level.player ); 
		self SetGoalEntity( get_closest_player() ); 
		
		return; 
	}

	// The AI will spawn and follow a patrol
	if( IsDefined( self.script_patroller ) )
	{
		self thread maps\_patrol::patrol(); 
		return; 
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
		self SetGoalEntity( get_closest_player() ); 

		level thread delayed_player_seek_think( self ); 
		
		return; 
	}

	if( portableMG42guy )
	{
		thread maps\_mgturret::portable_mg_behavior(); 
		return; 
	}

	if( IsDefined( self.used_an_mg42 ) ) // This AI was called upon to use an MG42 so he's not going to run to his node.
	{
		return; 
	}

	if( override )
	{
		set_goal_radius_based_on_settings(); 
			
		self SetGoalPos( self.origin ); 
		return; 
	}

	assertEx( self.goalradius == 4, "Changed the goalradius on guy with export " + self.export + " without waiting for spawn_failed. Note that this change will NOT show up by putting a breakpoint on the actors goalradius field because breakpoints don't properly handle the first frame an actor exists." );
	set_goal_radius_based_on_settings(); 


	// The AI will run to a target node and use the node's .radius as his goalradius.
	// If script_seekgoal is set, then he will run to his node with a goalradius of 0, then set his goal radius
	//    to the node's radius.
	if( IsDefined( self.target ) )
	{
		self thread go_to_node(); 
	}
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
	self.dropweapon = 1; 
	self.goalradius = level.default_goalradius; 
	self.goalheight = level.default_goalheight; 
	self.ignoresuppression = 0; 
	self pushplayer( false );

	if ( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
	{
		stop_magic_bullet_shield(); 
	}
		
	self notify( "disable_reinforcement" ); 
	self.maxsightdistsqrd = 8192*8192; 
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

go_to_node( node )
{
	if( IsDefined( self.used_an_mg42 ) ) // This AI was called upon to use an MG42 so he's not going to run to his node.
	{
		return; 
	}

	self endon( "stop_going_to_node" ); 
	
	volume = undefined; 

	if( !IsDefined( node ) )
	{
		node = GetNodeArray( self.target, "targetname" ); 
		if( node.size > 0 )
		{
			level.current_spawn_num++; 
			while( level.current_spawn_num >= node.size )
			{
				level.current_spawn_num -= node.size; 
			}

			if( level.current_spawn_num < 0 )
			{
				level.current_spawn_num = 0; 
			}

//			println( "Going to node ", level.current_spawn_num ); 
			node = node[level.current_spawn_num]; 
		}
		else
		{
			// a non node target, something scripted
/*
			targets = getentarray( self.target, "targetname" );
			if ( targets.size == 1 )
			{
				target = targets[ 0 ];
				if ( issubstr( target.classname, "info_player" ) )
				{
					self setgoalentity( level.player );
				}
			}
*/
			
			return; 
			/*
			// are we targetted a turret?
			turrets = GetEntArray( self.target, "targetname" ); 
			if( turrets.size != 1 )
			{
				return; 
			}
				
			turret = turrets[0]; 
			if( turret.classname != "misc_turret" )
			{
				return; 
			}
				
			*/
			/*
			volume = GetEntArray( self.target, "targetname" ); 
			if( volume.size > 0 )
			{
				level.current_spawn_num++; 
				while( level.current_spawn_num >= volume.size )
				{
					level.current_spawn_num -= volume.size; 
				}

				if( level.current_spawn_num < 0 )
				{
					level.current_spawn_num = 0; 
				}

//				println( "Going to volume ", level.current_spawn_num ); 
				volume = volume[level.current_spawn_num]; 
				if( volume.classname != "info_volume" )
				{
					return; 
				}
					
				assertex( IsDefined( volume.target ), "Goal volume at " + volume GetOrigin() + " doesn't target a node" ); 
				node = GetNode( volume.target, "targetname" ); 
			}
			else
			{
				return; 
			}
			*/
		}
	}

/*
	if( IsDefined( node.target ) )
	{
		turret = GetEnt( node.target, "targetname" ); 
		if( ( IsDefined( turret ) ) &&( ( turret.classname == "misc_mg42" ) ||( turret.classname == "misc_turret" ) ) )
		{
			turret thread flag_turret_for_use( self ); 
		}
	}
*/


	assertex( self.goalheight == 80, "Tried to set goalheight on guy with export " + self.export + " before running spawn_failed on the guy." ); 
	// AI is moving to a goal node
	if( IsDefined( node.height ) )
	{
		self.goalheight = node.height; 
	}
	else
	{
		self.goalheight = level.default_goalheight; 
	}
	
	self SetGoalNode( node ); 

	if( node.radius != 0 )
	{
		self.goalradius = node.radius; 
	}
	else
	{
		self.goalradius = level.default_goalradius; 
	}

/*
	// done with script_goalvolume now
	if( IsDefined( volume ) )
	{
		// AI is moving to a goal volume
		self SetGoalVolume( volume ); 
	}
*/
		
	/*
	if( IsDefined( self.script_seekgoal ) )
	{
		self.goalradius = ( 0 ); 
		self waittill( "goal" ); 
	}
	*/


    self endon ("death");
	if( IsDefined( node.target ) )
	{

		nextNode_array = GetNodeArray( node.target, "targetname" ); 
		if( nextNode_array.size > 0 )
		{
			nextNode = nextNode_array[RandomInt( nextNode_array.size )]; 
		}
		else
		{
			nextNode = undefined; 
		}

		if( IsDefined( nextNode ) )
		{
			self waittill( "goal" ); 
			for( ;; )
			{
				node script_delay(); 
				node = nextNode; 
				if( node.radius != 0 )
				{
					self.goalradius = node.radius; 
				}
				self SetGoalNode( node ); 
				self waittill( "goal" ); 
				if( !IsDefined( node.target ) )
				{
					reached_end_of_node_chain( node ); 
					return; 
				}

				nextNode_array = GetNodeArray( node.target, "targetname" ); 
				if( nextNode_array.size > 0 )
				{
					nextNode = nextNode_array[RandomInt( nextNode_array.size )]; 
				}
				else
				{
					nextNode = undefined; 
				}

				if( !IsDefined( nextNode ) )
				{
					reached_end_of_node_chain( node ); 
					break; 
				}
			}
		}
		else		
		{
			self waittill( "goal" ); 
			reached_end_of_node_chain( node ); 
		}
	}
	else
	{
		self reachPathEnd();
		set_goal_radius_based_on_settings( node ); 
	}
}

set_goal_radius_based_on_settings( node )
{
	if( IsDefined( self.script_radius ) )
	{
		// use the override from radiant
		self.goalradius = self.script_radius; 
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

reached_end_of_node_chain( node )
{
	self SetGoalNode( node ); 
	self waittill( "goal" ); 
	set_goal_radius_based_on_settings( node ); 

	self notify( "reached_path_end" ); 
	
	if( !IsDefined( node.target ) )
	{
		return; 
	}
	turrets = GetEntArray( node.target, "targetname" ); 
	if( turrets.size != 1 )
	{
		return; 
	}
		
	turret = turrets[0]; 
	if( turret.classname != "misc_turret" )
	{
		return; 
	}

	self.goalradius = 4; 
	self SetGoalNode( node ); 
	self waittill( "goal" ); 
	set_goal_radius_based_on_settings( node ); 
	self use_a_turret( turret ); 
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

//	thread maps\_mg_penetration::gunner_think( turret ); 
		
	self USeturret( turret ); // dude should be near the mg42
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
		
		if( IsDefined( turret.script_autotarget ) )
		{
			turret thread autoTarget( targets ); 
		}
		else if( IsDefined( turret.script_manualtarget ) )
		{
			turret SetMode( "manual_ai" ); 
			turret thread manualTarget( targets ); 
		}
		else if( targets.size > 0 )
		{
			if( targets.size == 1 )
			{
				turret.manual_target = targets[0]; 
				turret SetTargetEntity( targets[0] ); 
//				turret SetMode( "manual_ai" ); // auto, auto_ai, manual
				self thread maps\_mgturret::manual_think( turret ); 
//				if( IsDefined( self.script_mg42auto ) )
//					println( "AI at origin ", self.origin , " has script_mg42auto" ); 
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

fallback_spawner_think( num, node )
{
	self endon( "death" ); 
	level.current_fallbackers[num]+= self.count; 
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
			level.current_fallbackers[num]--; 
			continue; 
		}

		spawn thread fallback_ai_think( num, node, "is spawner" ); 
	}

//	level notify( ( "fallbacker_died" + num ) ); 
}

fallback_ai_think_death( ai, num )
{
	ai waittill( "death" ); 
	level.current_fallbackers[num]--; 

	level notify( ( "fallbacker_died" + num ) ); 
}

fallback_ai_think( num, node, spawner )
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

	if( ( IsDefined( node ) ) &&( level.fallback_initiated[num] ) )
	{
		self thread fallback_ai( num, node ); 
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
	level notify( ( "fallback_reached_goal" + num ) ); 
//	ai notify( "fallback_notify" ); 
}

fallback_goal()
{
	self waittill( "goal" ); 
	self.ignoresuppression = false; 

	self notify( "fallback_notify" ); 
	self notify( "stop_coverprint" ); 
}

fallback_ai( num, node )
{
	self notify( "stop_going_to_node" ); 

	self StopUSeturret(); 
	self.ignoresuppression = true; 
	self SetGoalNode( node ); 
	if( node.radius != 0 )
	{
		self.goalradius = node.radius; 
	}

	self endon( "death" ); 
	level thread fallback_death( self, num ); 
	self thread fallback_goal(); 

	if( GetDvar( "fallback" ) == "1" )
	{
		self thread coverprInt( node.origin ); 
	}

	self waittill( "fallback_notify" ); 
	level notify( ( "fallback_reached_goal" + num ) ); 
}

coverprInt( org )
{
	self endon( "fallback_notify" ); 
	self endon( "stop_coverprint" ); 

	while( 1 )
	{
		line( self.origin +( 0, 0, 35 ), org, ( 0.2, 0.5, 0.8 ), 0.5 ); 
		print3d( ( self.origin +( 0, 0, 70 ) ), "Falling Back", ( 0.98, 0.4, 0.26 ), 0.85 ); 
		maps\_spawner::waitframe(); 
	}
}


newfallback_overmind( num, group )
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

	if( !IsDefined( fallback_nodes ) )
	{
		return; 
	}

	level.current_fallbackers[num] = 0; 
	level.spawner_fallbackers[num] = 0; 
	level.fallback_initiated[num] = false; 

	spawners = GetSpawnerArray(); 
	for( i = 0; i < spawners.size; i++ )
	{
		if( ( IsDefined( spawners[i].script_fallback ) ) &&( spawners[i].script_fallback == num ) )
		{
			if( spawners[i].count > 0 )
			{
				spawners[i] thread fallback_spawner_think( num, fallback_nodes[RandomInt( fallback_nodes.size )] ); 
				level.spawner_fallbackers[num]++; 
			}
		}
	}

	ai = GetAiArray(); 
	for( i = 0; i < ai.size; i++ )
	{
		if( ( IsDefined( ai[i].script_fallback ) ) &&( ai[i].script_fallback == num ) )
		{
			ai[i] thread fallback_ai_think( num ); 
		}
	}

	if( ( !level.current_fallbackers[num] ) &&( !level.spawner_fallbackers[num] ) )
	{
		return; 
	}

	spawners = undefined; 
	ai = undefined; 

	thread fallback_wait( num, group ); 
	level waittill( ( "fallbacker_trigger" + num ) ); 
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

	first_half = fallback_ai.size*0.4; 
	first_half = Int( first_half ); 

	level notify( "fallback initiated " + num ); 

	fallback_text( fallback_ai, 0, first_half ); 
	for( i = 0; i < first_half; i++ )
	{
		fallback_ai[i] thread fallback_ai( num, fallback_nodes[RandomInt( fallback_nodes.size )] ); 
	}

	for( i = 0; i < first_half; i++ )
	{
		level waittill( ( "fallback_reached_goal" + num ) ); 
	}

	fallback_text( fallback_ai, first_half, fallback_ai.size ); 

	for( i = first_half; i < fallback_ai.size; i++ )
	{
		if( IsAlive( fallback_ai[i] ) )
		{
			fallback_ai[i] thread fallback_ai( num, fallback_nodes[RandomInt( fallback_nodes.size )] ); 
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
		
		return; 
	}
}

fallback_wait( num, group )
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
			ai[i] thread fallback_ai_think( num ); 
		}
	}
	ai = undefined; 

//	if( !total_fallbackers )
//		return; 

	max_fallbackers = level.current_fallbackers[num]; 

	deadfallbackers = 0; 
	while( level.current_fallbackers[num] > max_fallbackers * 0.5 )
	{
		if( GetDvar( "fallback" ) == "1" )
		{
			println( "^cwaiting for " + level.current_fallbackers[num] + " to be less than " +( max_fallbackers * 0.5 ) ); 
		}
		level waittill( ( "fallbacker_died" + num ) ); 
		deadfallbackers++; 
	}

	println( deadfallbackers , " fallbackers have died, time to retreat" ); 
	level notify( ( "fallbacker_trigger" + num ) ); 
}

fallback_think( trigger ) // for fallback trigger
{
	if( ( !IsDefined( level.fallback ) ) ||( !IsDefined( level.fallback[trigger.script_fallback] ) ) )
	{
		level thread newfallback_overmind( trigger.script_fallback, trigger.script_fallback_group ); 
	}

	trigger waittill( "trigger" ); 
	level notify( ( "fallbacker_trigger" + trigger.script_fallback ) ); 
//	level notify( ( "fallback" + trigger.script_fallback ) ); 

	// Maybe throw in a thing to kill triggers with the same fallback? God my hands are cold.
	kill_trigger( trigger ); 
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

fallback_coverprInt()
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

fallback_prInt()
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

fallback()
{
//	self endon( "death" ); 
	dest = GetNode( self.target, "targetname" ); 
	self.coverpoint = dest; 

	self SetGoalNode( dest ); 
	if( IsDefined( self.script_seekgoal ) )
	{
		self thread arrive( dest ); 
	}
	else
	{
		if( dest.radius != 0 )
		{
			self.goalradius = dest.radius; 
		}
		else
		{
			self.goalradius = level.default_goalradius; 
		}
	}

	while( 1 )
	{
		self waittill( "fallback" ); 
		self.interval = 20; 
		level thread fallback_death( self ); 

		if( GetDvar( "fallback" ) == "1" )
		{
			self thread fallback_prInt(); 
		}

		if( IsDefined( dest.target ) )
		{
			dest = GetNode( dest.target, "targetname" ); 
			self.coverpoint = dest; 
			self SetGoalNode( dest ); 
			self thread fallback_goal(); 
			if( dest.radius != 0 )
			{
				self.goalradius = dest.radius; 
			}
		}
		else
		{
			level notify( ( "fallback_arrived" + self.script_fallback ) ); 
			return; 
		}
	}
}


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
	maps\_utility::array_thread( triggers, ::set_spawncount, 0 ); 

	//friends = GetAiArray( "allies" ); 
	//maps\_utility::array_thread( friends, ::friendlydeath_thread ); 

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
				if( IsDefined( spawn[num].script_forcespawn ) )
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
					spawned SetGoalEntity( players[0] ); 

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
	if( ( IsDefined( level.noTankSquish ) ) &&( level.noTankSquish == true ) )
	{
		return; 
	}
	self notify( "tanksquishoff" ); 
	self endon( "tanksquishoff" ); 
	self endon( "death" ); 
	
	while( 1 )
	{
		self waittill( "damage", amt, who ); 
		if( !IsAlive( self ) && IsDefined( who ) && IsDefined( who.vehicletype ) )
		{
			self PlaySound( "human_crunch" ); 
		}
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
	
	if( IsDefined( self.script_forcespawn ) )
	{
		spawn = self StalingradSpawn(); 
	}
	else
	{
		spawn = self DoSpawn(); 
	}
		
	if( spawn_failed( spawn ) )
	{
		return; 
	}
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
	if( IsDefined( self.secureStarted ) )
	{
		// Multiple triggers can trigger a flood and secure spawner, but they need to run
		// their logic just once so we exit out if its already running.
		return; 
	}

	self.secureStarted = true; 
	self.triggerUnlocked = true; // So we don't run auto targetting behavior
	
	mg42 = IsSubStr( self.classname, "mgportable" ) || IsSubStr( self.classname, "30cal" ); 
	if( !mg42 )
	{
		// So we don't go script error'ing or whatnot off auto spawn logic
		// Unless we're an mg42 guy that has to set an mg42 up.
		self.script_moveoverride = true; 
	}
	
	target = self.target; 
	targetname = self.targetname; 
	if( !IsDefined( target ) )
	{
		println( "Entity " + self.classname + " at origin " + self.origin + " has no target" ); 
		waittillframeend; 
		assert( IsDefined( target ) ); 
	}

	// follow up spawners
	possibleSpawners = GetEntArray( target, "targetname" ); 
	spawners = []; 	
	for( i = 0; i < possibleSpawners.size; i++ )
	{
		if( !IsSubStr( possibleSpawners[i].classname, "actor" ) )
		{
			continue; 
		}

//		possibleSpawners[i] thread deathChainFallback(); 
		spawners[spawners.size] = possibleSpawners[i]; 
	}
	
	ent = SpawnStruct(); 
	org = self.origin; 
	flood_and_secure_spawner_think( mg42, ent, spawners.size > 0, instantRespawn ); 
	if( IsAlive( ent.ai ) )
	{
		ent.ai waittill( "death" ); 
	}
	
	
	// follow up spawners
	possibleSpawners = GetEntArray( target, "targetname" ); 
	if( !possibleSpawners.size )
	{
		return; 
	}

	for( i = 0; i < possibleSpawners.size; i++ )
	{
		if( !IsSubStr( possibleSpawners[i].classname, "actor" ) )
		{
			continue; 
		}

		possibleSpawners[i].targetname = targetname; 
		newTarget = target; 
		if( IsDefined( possibleSpawners[i].target ) )
		{
			targetEnt = GetEnt( possibleSpawners[i].target, "targetname" ); 
			if( !IsDefined( targetEnt ) || !IsSubStr( targetEnt.classname, "actor" ) )
			{
				newTarget = possibleSpawners[i].target; 
			}
		}

		// The guy might already be targetting a different destination
		// But if not, he goes to the node his parent went to. 
		possibleSpawners[i].target = newTarget; 
			
		possibleSpawners[i] thread flood_and_secure_spawner( instantRespawn ); 

		// Pass playertriggered flag as true because at this point the player must have been involved because one shots dont
		// spawn without the player triggering and multishot guys require player kills or presense to move along
		possibleSpawners[i].playerTriggered = true; 
		possibleSpawners[i] notify( "flood_begin" ); 
	}
}

flood_and_secure_spawner_think( mg42, ent, oneShot, instantRespawn )
{
	assert( IsDefined( instantRespawn ) ); 
	self endon( "death" ); 
	count = self.count; 
	//oneShot = ( count == 1 ); 
	if( !oneShot )
	{
		oneshot = ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "delete" ); 
	}
	self.count = 2; // running out of count counts as a dead spawner to script_deathchain

	if( IsDefined( self.script_delay ) )
	{
		delay = self.script_delay; 
	}
	else
	{
		delay = 0; 
	}
	
	for( ;; )
	{
		self waittill( "flood_begin" ); 
		if( self.playerTriggered )
		{
			break; 
		}
/*			
		// Lets let AI spawn oneshots!
		// Oneshots require player triggering to activate
		if( oneShot )
		{
			continue; 
		}
*/
		// guys that have a delay require triggering from the player 	
		if( delay )
		{
			continue; 
		}
		break; 
	}

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player, since this wants the current distance, let's get the closest player and
// get that distance.
//	dist = Distance( level.player.origin, self.origin ); 
	closest_player = get_closest_player( self.origin ); 
	// MikeD: Distancesquared() is cheaper, since we're comparing numbers, and not using the actual distance.
	dist = Distancesquared( closest_player.origin, self.origin ); 

	prof_begin("flood_and_secure_spawner_think");

	while( count )
	{
		self.trueCount = count; 
		self.count = 2; 
		wait( delay ); 
		if( IsDefined( self.script_forcespawn ) )
		{
			spawn = self StalingradSpawn(); 
		}
		else
		{
			spawn = self DoSpawn(); 
		}
			
		if( spawn_failed( spawn ) )
		{
			playerKill = false; 
			if( delay < 2 )
			{
				wait( 2 ); // debounce 
			}
			continue; 
		}
		else
		{
			thread addToWaveSpawner( spawn ); 
			spawn thread flood_and_secure_Spawn( self, mg42 ); 
			ent.ai = spawn; 
			ent notify( "got_ai" ); 
			self waittill( "spawn_died", deleted, playerKill ); 
			if( delay > 2 )
			{
				delay = RandomInt( 4 ) + 2; // first delay can be long, after that its always a set amount.		
			}
			else
			{
				delay = 0.5 + RandomFloat( 0.5 ); 
			}
		}

		if( deleted )
		{
			// Deletion indicates that we've hit the max AI limit and this is the oldest/farthest AI
			// so we need to stop this spawner until it gets triggered again or the player gets close
			
			waittillRestartOrDistance( dist ); 
		}
		else
		{
			/*
			// Only player kills count towards the count unless the spawner only has a count of 1
			// or NOT
			if( playerKill || oneShot )
			*/
			if( playerWasNearby( playerKill || oneShot, ent.ai ) )
			{
				count--; 
			}
			if( !instantRespawn )
			{
				waitUntilWaveRelease(); 
			}
		}
	}

    prof_end("flood_and_secure_spawner_think");
	
	self Delete(); 
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

flood_and_secure_Spawn( spawner, mg42 )
{
	if( !mg42 )
	{
		self thread flood_and_secure_spawn_goal(); 
	}
	self waittill( "death", other ); 

// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player
//	playerKill = IsAlive( other ) && other == level.player; 
	playerKill = IsAlive( other ) && IsPlayer( other ); 
	if( !playerkill && IsDefined( other ) && other.classname == "worldspawn" ) // OR THE WORLDSPAWN???
	{
		playerKill = true; 
	}

	deleted = !IsDefined( self ); 
	spawner notify( "spawn_died", deleted, playerKill ); 
}

flood_and_secure_spawn_goal()
{
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
	self waittill( "death" ); 
	
	tracker.aicount--; 
}


camper_trigger_think( trigger )
{
	//wait( 0.05 );
	tokens = strtok( trigger.script_linkto, " " );
	spawners = [];
	nodes = [];
	for ( i=0; i < tokens.size; i++ )
	{
		ai = getent( tokens[ i ], "script_linkname" );
		if ( isdefined( ai ) )
		{
			spawners = add_to_array( spawners, ai ); 
			continue;
		}
		node = getnode( tokens[ i ], "script_linkname" );
		assertEx( isdefined( node ), "trigger token number did not exist or is not a node: " + tokens[i] );
		nodes = add_to_array ( nodes, node ); 
	}
	assertEX( spawners.size , "camper_spawner without any spawners associated" );
	assertEX( nodes.size , "camper_spawner without any nodes associated" );
	assertEX( nodes.size >= spawners.size , "camper_spawner with less nodes than spawners" );
	
	trigger waittill ( "trigger" );
	
	nodes = array_randomize( nodes );
	for ( i=0; i < nodes.size; i++ )
		nodes[i].claimed = false;
	j = 0;
	for ( i=0; i < spawners.size; i++ )
	{
		while ( isdefined ( nodes[j].script_noteworthy ) && nodes[j].script_noteworthy == "dont_spawn" )
			j++;
		spawners[i].origin = nodes[j].origin;
		spawners[i].angles = nodes[j].angles;
		spawners[i] add_spawn_function ( ::claim_a_node, nodes[j] );
		j++;
	}
	
	array_thread( spawners, ::add_spawn_function, ::set_goal_radius, 32 );
	array_thread( spawners, ::add_spawn_function, ::move_when_enemy_hides, nodes );
	array_thread( spawners, maps\_spawner::spawn_ai );
}

move_when_enemy_hides( nodes )
{
	self endon("death");
	
	waitingForEnemyToDisappear = false;
	
	while (1)
	{
		// it is important that we check whether our enemy is defined before doing a cansee check on him.
		if ( !isdefined( self.enemy ) )
		{
			self waittill("enemy");
			waitingForEnemyToDisappear = false;
			continue;
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

claim_a_node ( claimed_node , old_claimed_node )
{
	self.claimed_node = claimed_node;
	claimed_node.claimed = true;
	if ( isdefined ( old_claimed_node ) )
		old_claimed_node.claimed = false;
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
	assertex( IsDefined( trigger.target ), "flood_spawner without target" ); 
	
	floodSpawners = GetEntArray( trigger.target, "targetname" ); 
	assertex( floodSpawners.size, "flood_spawner at with target " + trigger.target + " without any targets" ); 
	
	array_thread( floodSpawners, ::flood_spawner_init ); 
	
	trigger waittill( "trigger" ); 
	// reget the target array since targets may have been deletes, etc... between initialization and triggering
	floodSpawners = GetEntArray( trigger.target, "targetname" ); 
	array_thread( floodSpawners, ::flood_spawner_think, trigger ); 
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
	self.goalradius	= 32;
	
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
		while( requires_player && !any_player_IsTouching( trigger ) )
		{
			wait( 0.5 ); 
		}


		if( IsDefined( self.script_forcespawn ) )
		{
			soldier = self StalingradSpawn(); 
		}
		else
		{
			soldier = self DoSpawn(); 
		}

		if( spawn_failed( soldier ) )
		{
			wait( 2 ); 
			continue; 
		}

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

		if( !script_wait() )
		{
			wait( RandomFloatrange( 5, 9 ) ); 
		}
	}
}

player_saw_kill( guy, attacker )
{
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
				
			if ( distance( attacker.origin, level.player.origin ) < 200 )
			{
				// player was near the guy that killed the ai?
				return true;
			}
		}
	}
	
	if ( distance( guy.origin, level.player.origin ) < 200 )
	{
		// player was near the guy that got killed?
		return true;
	}

	// did the player see the guy die?
	return bulletTracePassed( level.player geteye(), guy geteye(), false, undefined );
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
		
		soldier = spawner spawn_ai(); 
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
		script_wait(); 
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
				
			soldier = self spawn_ai(); 
			if( spawn_failed( soldier ) )
			{
				wait( 2 ); 
				continue; 
			}

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

drophealth()
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
}

show_bad_path()
{
	/#
	if( GetDebugDvar( "debug_badpath" ) == "" )
	{
		SetDvar( "debug_badpath", "" ); 
	}

	self endon( "death" ); 
	for( ;; )
	{
		self waittill( "bad_path", badPathPos ); 
		if( !level.debug_badpath )
		{
			continue; 
		}
		
		for( p = 0; p < 10*20; p++ )
		{
			line( self.origin, badPathPos, ( 1, 0.4, 0.1 ), 0, 10*20 ); 
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

spawn_ai()
{
	if( IsDefined( self.script_forcespawn ) )
	{
		return self StalingradSpawn(); 
	}
	return self DoSpawn(); 
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
spawner_droneSpawn( spawner )
{
	assert( IsDefined( level.dronestruct[spawner.classname] ) ); 
	struct = level.dronestruct[spawner.classname]; 
	drone = Spawn( "script_model", spawner.origin ); 
	drone SetModel( struct.model ); 
//	drone Hide(); 
	drone UseAnimtree( #animtree ); 
	drone MakeFakeAi(); 
	attachedmodels = struct.attachedmodels; 
	attachedtags = struct.attachedtags; 
	for( i = 0; i < attachedmodels.size; i++ )
	{
		drone Attach( attachedmodels[i], attachedtags[i] ); 
	}
	if( IsDefined( spawner.script_startingposition ) )
	{
		drone.script_startingposition = spawner.script_startingposition; 
	}
	//for later use to makerealai
	drone.spawner = spawner; 

	assert( IsDefined( drone ) ); 
	if( IsDefined( spawner.script_noteworthy ) && spawner.script_noteworthy == "drone_delete_on_unload" )
	{
		drone.drone_delete_on_unload = true; 
	}
	else 
	{
		drone.drone_delete_on_unload = false; 
	}
	
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