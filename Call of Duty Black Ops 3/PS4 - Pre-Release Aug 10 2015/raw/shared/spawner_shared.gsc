#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace spawner;

// Values for showing damage and XP popups.







// .script_delete	a group of guys, only one of which spawns
// .script_patroller	follow your targeted patrol
// .script_followmin
// .script_followmax
// .script_radius
// .script_friendname
// .script_startinghealth
// .script_accuracy
// .script_grenades
// .script_sightrange
// .script_ignoreme

function autoexec __init__sytem__() {     system::register("spawner",&__init__,&__main__,undefined);    }

function __init__()
{
	if( GetDvarString( "noai" ) == "" )
	{
		SetDvar( "noai", "off" );
	}
	
	// create default threatbiasgroups;

	/*CreateThreatBiasGroup( "allies" );//TODO T7
	CreateThreatBiasGroup( "axis" );*/

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
	level.portable_mg_gun_tag = "J_Shoulder_RI"; // need to get J_gun back to make it work properly
	level.mg42_hide_distance = 1024;
	
	level.global_spawn_timer = 0;
	level.global_spawn_count = 0;
	
	if( !isdefined( level.maxFriendlies ) )
	{
		level.maxFriendlies = 11;
	}
	
	level.ai_classname_in_level = [];

	spawners = GetSpawnerArray();
	for( i = 0; i < spawners.size; i++ )
	{
		spawners[i] thread spawn_prethink();
	}
	
	//TODO T7 - MPAI_PETER_TODO _subclass_main::subclass_setup_spawn_functions();

	thread process_deathflags();

	precache_player_weapon_drops( array( "rpg" ) );
	
	goal_volume_init();
	
	level thread spawner_targets_init();
	
	level.ai = [];
	spawner::add_global_spawn_function( "axis", &global_ai_array );
	spawner::add_global_spawn_function( "allies", &global_ai_array );
	spawner::add_global_spawn_function( "team3", &global_ai_array );
	
	level thread update_nav_triggers();
}

function __main__()
{
	waittillframeend;

	ai = GetAISpeciesArray( "all" );
	array::thread_all( ai, &living_ai_prethink );
	
	foreach( ai_guy in ai )
	{
		if ( IsAlive( ai_guy ) )
		{
			ai_guy.overrideActorKilled = &callback_Track_Dead_NPCs_By_Type;
			ai_guy thread spawn_think();
		}
	}
	
	level thread spawn_throttle_reset();
}

function update_nav_triggers()
{
	level.valid_navmesh_positions = [];
		
	a_nav_triggers = GetEntArray( "trigger_navmesh", "classname" );
	
	if ( !a_nav_triggers.size )
	{
		return;
	}
		
	/* Build a targetname array - Code only wants the targetname, not the individual triggers */
	
	level.navmesh_zones = [];
	foreach ( trig in a_nav_triggers )
	{
		level.navmesh_zones[ trig.targetname ] = false;
	}
	
	while ( true )
	{
		UpdateNavTriggers();//optimized version of code commented out below
//		/* Reset all nav zones to be off */
//		
//		foreach ( targetname, on in level.navmesh_zones )
//		{
//			level.navmesh_zones[ targetname ] = false;
//		}
//		
//		/* Mark valid zones based on if the AI is touching it or goalpos is inside it */
//		
//		foreach ( team, a_ai in level.ai )
//		{
//			foreach ( ai in a_ai )
//			{
//				if ( IsActor( ai ) && IsAlive( ai ) )
//				{
//					a_str_trigs = GetNavMeshTriggersForPoint( ai.origin );
//					
//					foreach( str_trig in a_str_trigs )
//					{
//						level.navmesh_zones[ str_trig ] = true;
//					}
//					
//					a_str_trigs = GetNavMeshTriggersForPoint( ai.goalpos );
//					
//					foreach( str_trig in a_str_trigs )
//					{
//						level.navmesh_zones[ str_trig ] = true;
//					}
//				}
//			}
//		}
//		
//		/* Go through and actually enable/disable the nav triggers */
//		
//		foreach ( targetname, on in level.navmesh_zones )
//		{
//			EnableNavMeshTrigger( targetname, on );
//		}
		
		level util::waittill_notify_or_timeout( "update_nav_triggers", 1 );
	}
}

function global_ai_array()
{
	if ( !isdefined( level.ai[ self.team ] ) ) level.ai[ self.team ] = []; else if ( !IsArray( level.ai[ self.team ] ) ) level.ai[ self.team ] = array( level.ai[ self.team ] ); level.ai[ self.team ][level.ai[ self.team ].size]=self;;
	
	self waittill( "death" );
	
	if ( isdefined( self ) )
	{
		// Check if this AI still belongs to the current team, as its team might have been changed over time
		if( IsDefined( level.ai ) && IsDefined( level.ai[ self.team ] ) && IsInArray( level.ai[ self.team ], self ) )
		{
			ArrayRemoveValue( level.ai[ self.team ], self );
		}
		else
		{
			// Find if this AI exists in the list of other AI's and remove him from there instead
			foreach( aiArray in level.ai )
			{
				if( IsInArray( aiArray, self ) )
				{
					ArrayRemoveValue( aiArray, self );
					break;
				}
			}
		}
	}
	else
	{
		foreach ( team, array in level.ai )
		{
			for ( i = array.size - 1; i >= 0; i-- )
			{
				if ( !isdefined( array[ i ] ) )
				{
					ArrayRemoveIndex( array, i );
				}
			}
		}
	}
}

function spawn_throttle_reset()
{
	while ( true )
	{
		util::wait_network_frame();
		level.global_spawn_count = 0;
	}
}

function callback_Track_Dead_NPCs_By_Type()	
{
	return;
}

function goal_volume_init()
{
	volumes = GetEntArray( "info_volume", "classname" );
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

function precache_player_weapon_drops( weapon_names )
{
	level.ai_classname_in_level_keys = getarraykeys( level.ai_classname_in_level );
	for ( i = 0 ; i < level.ai_classname_in_level_keys.size ; i++ )
	{
		if( weapon_names.size <= 0 )
		{
			break;
		}

		for( j = 0 ; j < weapon_names.size ; j++ )
		{
			weaponName = weapon_names[j];

			if ( !issubstr( tolower( level.ai_classname_in_level_keys[ i ] ), weaponName ) )
			{
				continue;
			}

			ArrayRemoveValue( weapon_names, weaponName );
			break;
		}
	}
	level.ai_classname_in_level_keys = undefined;
}

function process_deathflags()
{
	keys = getarraykeys( level.deathflags );
	level.deathflags = [];
	for ( i=0; i < keys.size; i++ )
	{
		deathflag = keys[ i ];
		level.deathflags[ deathflag ] = [];
		level.deathflags[ deathflag ][ "ai" ] = [];
		
		if ( !isdefined( level.flag[ deathflag ] ) )
		{
			level flag::init( deathflag );
		}
	}
	
}

function spawn_guys_until_death_or_no_count()
{
	self endon( "death" );
	self waittill( "count_gone" );
}

function flood_spawner_scripted( spawners )
{
	assert( isdefined( spawners ) && spawners.size, "Script tried to flood spawn without any spawners" );

	array::thread_all( spawners,&flood_spawner_init );
	array::thread_all( spawners,&flood_spawner_think );
}

function reincrement_count_if_deleted( spawner )
{
	spawner endon( "death" );

	self waittill( "death" );
	if( !isdefined( self ) )
	{
		spawner.count++;
	}
}

function kill_trigger( trigger )
{
	if( !isdefined( trigger ) )
	{
		return;
	}
		
	if( ( isdefined( trigger.targetname ) ) &&( trigger.targetname != "flood_spawner" ) )
	{
		return;
	}
		
	trigger Delete();
}

function waittillDeathOrPainDeath()
{
	self endon( "death" );
	self waittill( "pain_death" ); // pain that ends in death
}

function drop_gear()
{
	team = self.team;
	waittillDeathOrPainDeath();

	if( !isdefined( self ) )
	{
		return;
	}

	if( self.grenadeAmmo <= 0 )
	{
		return;
	}

	if( isdefined( self.dropweapon ) && !self.dropweapon )
	{
		return;
	}

	if (!IsDefined(	level.nextGrenadeDrop ))
	{
		level.nextGrenadeDrop = RandomInt(3);
	}

	level.nextGrenadeDrop--;
	if( level.nextGrenadeDrop > 0 )
	{
		return;
	}

	level.nextGrenadeDrop = 2 + RandomInt( 2 );
	const max = 25;
	const min = 12;
	spawn_grenade_bag( self.origin +( RandomInt( max )-min, RandomInt( max )-min, 2 ) +( 0, 0, 42 ), ( 0, RandomInt( 360 ), 0 ), self.team );
	
}

/* DEAD CODE REMOVAL
function random_tire( start, end )
{
    model = util::spawn( "script_model", (0,0,0) );
    model.angles = ( 0, randomint( 360 ), 0 );

    dif = randomfloat( 1 );
    model.origin = start * dif + end * ( 1 - dif );
    model setmodel( "com_junktire" );
    vel = math::random_vector( 15000 );
    vel = ( vel[ 0 ], vel[ 1 ], abs( vel[ 2 ] ) );
    model physicslaunch( model.origin, vel );
    
    wait ( randomintrange ( 8, 12 ) );
    model delete();
}
*/
	
function spawn_grenade_bag( origin, angles, team )
{
	// delete oldest grenade
	if( !isdefined( level.grenade_cache ) || !isdefined( level.grenade_cache[team] ) )
	{
		level.grenade_cache_index[team] = 0;
		level.grenade_cache[team] = [];
	}

	index = level.grenade_cache_index[team];
	grenade = level.grenade_cache[team][index];
	if( isdefined( grenade ) )
	{
		grenade Delete();
	}

	count = self.grenadeammo;
	grenade = sys::Spawn( "weapon_" + self.grenadeWeapon.name + level.game_mode_suffix, origin );
	level.grenade_cache[team][index] = grenade;
	level.grenade_cache_index[team] = ( index + 1 ) % 16;

	grenade.angles = angles;
	grenade.count = count;

	//grenade SetModel( "grenade_bag" );
}

function spawn_prethink()
{
	assert( self != level );

	level.ai_classname_in_level[ self.classname ] = true;
	
	/#
	if (GetDvarString ("noai") != "off")
	{
		// NO AI in the level plz
		self.count = 0;
		return;
	}
	#/

	// Populate the list of Axis and Ally drone spawners
// 	self _drones::drone_add_spawner(); _drones.gsc has been removed
			
	if( isdefined( self.script_aigroup ) )
	{
		aigroup_init( self.script_aigroup, self );
	}

	if( isdefined( self.script_delete ) )
	{
		array_size = 0;
		if( isdefined( level._ai_delete ) )
		{
			if( isdefined( level._ai_delete[self.script_delete] ) )
			{
				array_size = level._ai_delete[self.script_delete].size;
			}
		}

		level._ai_delete[self.script_delete][array_size] = self;
	}
	
	if ( isdefined( self.target ) )
	{
		crawl_through_targets_to_init_flags();
	}
}

function update_nav_triggers_for_actor()
{
	level notify( "update_nav_triggers" );
				
	while ( IsAlive( self ) )
	{
		self util::waittill_either( "death", "goal_changed" );
		level notify( "update_nav_triggers" );
	}
}

// called from _callbacksetup when actor is spawned.
function spawn_think( spawner )
{
	self endon( "death" );
	
	// do not run the spawn_think again when we already have. This will prevent this thread from
	// running again on a restart from checkpoint.
	if ( IsDefined( self.spawn_think_thread_active ) )
		return;
	
	self.spawn_think_thread_active = true;
	
	self.spawner = spawner;
	
	assert( IsActor( self ) || IsVehicle( self ), __FUNCTION__ + " only supports actors and vehicles." );
	
	if ( !IsVehicle( self ) )
	{
		if ( !IsAlive( self ) )
		{
			return;
		}
		
		self.maxhealth = self.health;	// HACK: temp until code sets it
		
		self thread update_nav_triggers_for_actor();
	}
	
	self.script_animname = undefined;
	
	if ( isdefined( self.script_aigroup ) )
	{
		level flag::set( self.script_aigroup + "_spawning" );
		self thread aigroup_think( level._ai_group[ self.script_aigroup ] );
	}
	
	if ( isdefined( spawner ) && isdefined( spawner.script_dropAmmo ) )
	{
		self.disableAmmoDrop = !spawner.script_dropAmmo;
	}
	
	if ( isdefined( spawner ) && isdefined( spawner.spawn_funcs ) )
	{
		self.spawn_funcs = spawner.spawn_funcs;
	}
	
	if ( IsAI( self ) )
	{
		spawn_think_action( spawner );
		
		assert( IsAlive( self ) );
		assert( isdefined( self.team ) );
	}
	
	self thread run_spawn_functions();
	
	self.finished_spawning = true;
	self notify( "finished spawning" );
}

function run_spawn_functions()
{
	self endon( "death" );
	
	if ( !isdefined( level.spawn_funcs ) )
	{
		return;
	}
	
	if ( isdefined( self.archetype ) && isdefined( level.spawn_funcs[ self.archetype ] ) )
	{
		for (i = 0; i < level.spawn_funcs[ self.archetype ].size; i++)
		{
			func = level.spawn_funcs[ self.archetype ][ i ];
			util::single_thread(self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ], func[ "param5" ] );
		}
	}
	
	waittillframeend;	// spawn functions should override default settings, so they need to be last
	
	callback::callback( #"on_ai_spawned" );

	if ( IsDefined( level.spawn_funcs[ self.team ] ) )
	{
		for (i = 0; i < level.spawn_funcs[ self.team ].size; i++)
		{
			func = level.spawn_funcs[ self.team ][ i ];
			util::single_thread(self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ], func[ "param5" ] );
		}
	}

	if ( isdefined( self.spawn_funcs ) )
	{
		for ( i = 0; i < self.spawn_funcs.size; i++ )
		{
			func = self.spawn_funcs[ i ];
			util::single_thread( self, func[ "function" ], func[ "param1" ], func[ "param2" ], func[ "param3" ], func[ "param4" ], func[ "param5" ] );
		}

		/#
			// keep spawn funcs around in debug
			return;
		#/

		self.spawn_funcs = undefined;
	}
}

function living_ai_prethink()
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

function crawl_through_targets_to_init_flags()
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

function remove_spawner_values()
{
	/* remove all unnessesary data tranfered from the spawner */
	self.spawner_number = undefined;
}

// Actually do the spawn_think
function spawn_think_action( spawner )
{
	remove_spawner_values();

	if ( ( isdefined( level._use_faceanim ) && level._use_faceanim ) )
	{
		self thread serverfaceanim::init_serverfaceanim();
	}

	/* set targetname to the spawner's targetname + "_ai" if a targetname isn't already set */

	if ( isdefined( spawner ) )
	{
		if ( isdefined( spawner.targetname ) && !isdefined( self.targetname ) )
		{
			self.targetname = spawner.targetname + "_ai";
		}
	}
	
	if ( isdefined( spawner ) && isdefined( spawner.script_animname ) )
	{
		self.animname = spawner.script_animname;
	}
	else if ( isdefined( self.script_animname ) )
	{
		self.animname = self.script_animname;
	}
	
	// handle default ai flags for ent_flag * functions
//	self thread util::ent_flag_init_ai_standards();
	
	/#
	thread show_bad_path();
	#/
	
	if ( isdefined( self.script_forceColor ) )
	{
		// send all forcecolor through a centralized function
		colors::set_force_color( self.script_forceColor );
	
		// All AI spawned will do "replace_on_death" unless told not to.
		if ( ( !isdefined( self.script_no_respawn ) || self.script_no_respawn < 1 ) && !isdefined( level.no_color_respawners_sm ) )
		{
			self thread replace_on_death();
		}
	}
		
	if ( ( isdefined( self.script_moveoverride ) ) &&( self.script_moveoverride == 1 ) )
	{
		override = true;
	}
	else
	{
		override = false;
	}
	
	//SCRIPT_MOD: GLOCKE: built this into the actor damage callback
	//if( self watches_for_friendly_fire() )
	//{
	//	level thread _friendlyfire::friendly_fire_think( self );
	//}
	
	// create threatbiasgroups
	//TODO T7 - function port
	/*if( isdefined( self.script_threatbiasgroup ) )
	{
		self SetThreatBiasGroup( self.script_threatbiasgroup );
	}
	else if( self.team == "allies" )
	{
		self SetThreatBiasGroup( "allies" );
	}
	else
	{
		self SetThreatBiasGroup( "axis" );
	}*/

	self.heavy_machine_gunner = IsSubStr( self.classname, "mgportable" );
	
	gameskill::grenadeAwareness();
	
	if( isdefined( self.script_ignoreme ) )
	{
		assert( self.script_ignoreme == true, "Tried to set self.script_ignoreme to false, not allowed. Just set it to undefined." );
		self.ignoreme = true;
	}
	
//	if ( isdefined( self.script_ignore_suppression ) )
//	{
//		assert( self.script_ignore_suppression == true, "Tried to set self.script_ignore_suppresion to false, not allowed. Just set it to undefined." );
//		self.ignoreSuppression = true;
//	}
	
	if( isdefined( self.script_hero ) )
	{
		assert( self.script_hero == 1, "Tried to set script_hero to something other than 1" );
		//TODO T7 - port if needed
		//self util::make_hero();
	}
	
	if ( isdefined( self.script_ignoreall ) )
	{
		assert( self.script_ignoreall == true, "Tried to set self.script_ignoreme to false, not allowed. Just set it to undefined." );
		self.ignoreall = true;
		//self init::clearEnemy();
	}
		
//	// disable reaction feature if needed
//	if( isdefined( self.script_disablereact ) )
//	{
//		self util::disable_react();
//	}
//	
//	// disable pain if needed
//	if( isdefined( self.script_disablepain ) )
//	{
//		self util::disable_pain();
//	}
//	
//	// disable pain if needed
//	if( isdefined( self.script_disableturns ) )
//	{
//		self.disableTurns = true;
//	}
	
	if ( isdefined( self.script_sightrange ) )
	{
		self.maxSightDistSqrd = self.script_sightrange;
	}
	else if ( ( self.weaponclass === "gas" ) )
	{
		self.maxSightDistSqrd = 1024 * 1024;
	}
	
	if ( self.team != "axis" )
	{
		// Set the followmin for friendlies
		if ( isdefined( self.script_followmin ) )
		{
			self.followmin = self.script_followmin;
		}
	
		// Set the followmax for friendlies
		if ( isdefined( self.script_followmax ) )
		{
			self.followmax = self.script_followmax;
		}
	}
	
	if ( self.team == "axis" )
	{
		if ( IsDefined( self.type ) && self.type == "human" )
		{
			//self thread drop_gear();
			//self thread drophealth();
		}
	}
	
	if ( isdefined( self.script_fightdist ) )
	{
		self.pathenemyfightdist = self.script_fightdist;
	}
	
	if ( isdefined( self.script_maxdist ) )
	{
		self.pathenemylookahead = self.script_maxdist;
	}
	
	// disable long death like dying pistol behavior
	if ( isdefined( self.script_longdeath ) )
	{
		assert( !self.script_longdeath, "Long death is enabled by default so don't set script_longdeath to true, check ai with export " + self.export );
		self.a.disableLongDeath = true;
		assert( self.team != "allies", "Allies can't do long death, so why disable it on guy with export " + self.export );
	}
	
	// Gives AI grenades (defaults for each cod5 aitype are specified in aitypes_charactersettings.gdt)
	if ( isdefined( self.script_grenades ) )
	{
		self.grenadeAmmo = self.script_grenades;
	}
		
	// Puts AI in pacifist mode
	if ( isdefined( self.script_pacifist ) )
	{
		self.pacifist = true;
	}
	
	// Set the health for special cases
	if ( isdefined( self.script_startinghealth ) )
	{
		self.health = self.script_startinghealth;
	}
	
	// GLocke [8/30] allow the AI to be killed during animations (like traversals)
	if ( isdefined( self.script_allowdeath ) )
	{
		self.allowdeath = self.script_allowdeath;
	}

	// Force gib support on KVP
	if ( isdefined( self.script_forcegib ) )
	{
		self.force_gib = 1;
		
		// use the string as gib ref

		//TODO T7 - MPAI_PETER_TODO
		/*if( as_death::isValidGibRef( self.script_forcegib ) ) 
		{
			self.custom_gib_refs[0] = self.script_forcegib;
		}*/
	}
		
	if ( isdefined( self.script_lights_on ) ) // re-purposing this key for AI, usually used on vehicles
	{
		self.has_ir = true;
	}
	
	// starth stealth if needed
	if ( isdefined( self.script_stealth ) )
	{
//		self thread _stealth_logic::stealth_ai(); TODO: _stealth_logic.gsc has been removed
	}
	
	// The AI will spawn and follow a patrol
	if ( isdefined( self.script_patroller ) )
	{
//		self thread _patrol::patrol(); _patrol.gsc has been removed
		return;
	}
	
	if ( ( isdefined( self.script_rusher ) && self.script_rusher ) )
	{
//		self rusher::rush(); _rusher.gsc has been removed
		return;
	}
//		
//	if( isdefined( self.script_enable_cqb ) )
//	{
//		self util::change_movemode("cqb");
//	}
//	
//	if( isdefined( self.script_enable_heat ) )
//	{
//		self util::enable_heat();
//	}
	
	// Setup playerseek
//	if( isdefined( self.script_playerseek ) )
//	{
//		if( self.script_playerseek == 1 )
//		{
//			self thread util::player_seek(); // direct player seek
//			return;
//		}
//		else
//		{
//			self thread util::player_seek( self.script_playerseek ); // delayed player seek
//		}
//	}
	
	if ( isdefined( self.used_an_mg42 ) ) // This AI was called upon to use an MG42 so he's not going to run to his node.
	{
		return;
	}
			
	if ( override )
	{
		self thread set_goalradius_based_on_settings();
		self SetGoal( self.origin );
		return;
	}
	
	// SUMEET TODO - Following script will run as a thread and can override the awareness goals. 
	// Disabling it for now. We will investigate further.
	if ( ( isdefined( level.using_awareness ) && level.using_awareness ) )
	{
		return;
	}
	
	if ( ( isdefined(self.vehicleclass) && ( self.vehicleclass == "artillery" ) ) )//we don't want to check this for turrets
	{
		return;	
	}

	if ( isdefined( self.target ) )
	{
		e_goal = GetEnt( self.target, "targetname" );
		if ( isdefined( e_goal ) )
		{
			self SetGoal( e_goal );
		}
		else
		{
			self thread go_to_node();
		}
	}
	else
	{
		self thread set_goalradius_based_on_settings();
	
		if ( isdefined( self.script_spawner_targets ) )
		{
			// New way of sending guys to nodes using "script_spawner_targets" key on the spawner
			self thread go_to_spawner_target( StrTok( self.script_spawner_targets," " ) );
		}
	}
	
	// set the goal volume after the goal position has been set
	if ( isdefined( self.script_goalvolume ) )
	{
		self thread set_goal_volume();
	}
	
	// override for the default turnrate (ai_turnrate dvar). Degrees per second (360 = one complete turn)
	if ( isdefined( self.script_turnrate ) )
	{
		self.turnrate = self.script_turnrate;
	}
	//TODO T7 - port/update if needed
	//self dds::dds_ai_init();
}

function set_goal_volume()
{
	self endon( "death" );
	
	// wait until frame end so that the AI's goal has a chance to get set
	waittillframeend;

	volume = level.goalVolumes[ self.script_goalvolume ];
	if ( !isdefined( volume ) )
		return;

	if ( isdefined( volume.target ) )
	{
		node 	 = GetNode( volume.target, "targetname" );
		ent 	 = GetEnt( volume.target, "targetname" );
		struct 	 = struct::get( volume.target, "targetname" );
		pos 	 = undefined;

		if ( isdefined( node ) )
		{
			pos = node;
			self SetGoal( pos );
		}
		else if ( isdefined( ent ) )
		{
			pos = ent;
			self SetGoal( pos.origin );
		}
		else if ( isdefined( struct ) )
		{
			pos = struct;
			self SetGoal( pos.origin );
		}

		if ( isdefined( pos.radius ) && pos.radius != 0 )
		{
			self.goalradius = pos.radius;
		}
		
		if ( isdefined( pos.goalheight ) && pos.goalheight != 0 )
		{
			self.goalheight = pos.goalheight;
		}
	}

	if ( isdefined( self.target ) )
	{
		self SetGoal( volume );
	}
	else if ( isdefined( self.script_spawner_targets ) )
	{
		self waittill( "spawner_target_set" );
		self SetGoal( volume );
	}
	else
	{
		self SetGoal( volume );
	}
}

function get_target_ents( target )
{
	return GetEntArray( target, "targetname" );
}

function get_target_nodes( target )
{
	return getnodearray( target, "targetname" );
}

function get_target_structs( target )
{
	return struct::get_array( target, "targetname" );
}

function node_has_radius( node )
{
	return isdefined( node.radius ) && node.radius != 0;
}

function go_to_origin( node, optional_arrived_at_node_func )
{
	self go_to_node( node, "origin", optional_arrived_at_node_func );
}

function go_to_struct( node, optional_arrived_at_node_func )
{
	self go_to_node( node, "struct", optional_arrived_at_node_func );
}

function go_to_node( node, goal_type, optional_arrived_at_node_func )
{
	self endon("death");

	if ( isdefined( self.used_an_mg42 ) )// This AI was called upon to use an MG42 so he's not going to run to his node.
	{
		return;
	}

	array = get_node_funcs_based_on_target( node, goal_type );
	if ( !isdefined( array ) )
	{
		self notify( "reached_path_end" );
		// no goal type
		return;
	}
	
	if ( !isdefined( optional_arrived_at_node_func ) )
	{
		optional_arrived_at_node_func = &util::empty;
	}
	
	go_to_node_using_funcs( array[ "node" ], array[ "get_target_func" ], array[ "set_goal_func_quits" ], optional_arrived_at_node_func );
}

//////////////////////////////////////////////////////////////////////
/////////// Handling of script_spawner_targets ///////////////////////
//																	//
// This was new functionality for Spawn Manager.  Now works for		//
// any spawner regardless of how it is spawned.  Sends AI to a		//
// random node that is in the same 'script_spawner_targets' group.	//
//////////////////////////////////////////////////////////////////////

//-- Makes a global array of nodes that is then processed by the spawner targets system
function spawner_targets_init()
{
	allnodes = GetAllNodes();
	level.script_spawner_targets_nodes = [];
	for( i = 0; i < allnodes.size; i++)
	{
		if(isdefined(allnodes[i].script_spawner_targets))
		{
			level.script_spawner_targets_nodes[level.script_spawner_targets_nodes.size] = allnodes[i];
		}
	}
}

function go_to_spawner_target(target_names)
{
	self endon( "death" );

	self notify( "go_to_spawner_target" );
	self endon( "go_to_spawner_target" );

	nodes = [];
	a_nodes_unavailable = [];
	nodesPresent = false;
			
	for ( i = 0; i < target_names.size; i++ )
	{
		target_nodes = get_spawner_target_nodes( target_names[i] );
		if ( target_nodes.size > 0 )
		{
			nodesPresent = true;
		}

		foreach ( node in target_nodes )
		{
			if ( IsNodeOccupied( node ) || ( isdefined( node.node_claimed ) && node.node_claimed ) )
			{
				if ( !isdefined( a_nodes_unavailable ) ) a_nodes_unavailable = []; else if ( !IsArray( a_nodes_unavailable ) ) a_nodes_unavailable = array( a_nodes_unavailable ); a_nodes_unavailable[a_nodes_unavailable.size]=node;;
			}
			else if ( (isdefined(node.spawnflags)&&((node.spawnflags & 512) == 512)) )
			{
				if ( !isdefined( a_nodes_unavailable ) ) a_nodes_unavailable = []; else if ( !IsArray( a_nodes_unavailable ) ) a_nodes_unavailable = array( a_nodes_unavailable ); a_nodes_unavailable[a_nodes_unavailable.size]=node;;
			}
			else
			{
				if ( !isdefined( nodes ) ) nodes = []; else if ( !IsArray( nodes ) ) nodes = array( nodes ); nodes[nodes.size]=node;;
			}
		}
	}

	// if not a single node is unoccupied then wait until one is.
	if ( nodes.size == 0 )
	{
		while ( nodes.size == 0 )
		{
			foreach ( node in a_nodes_unavailable )
			{
				if ( !IsNodeOccupied( node )
				    && !( isdefined( node.node_claimed ) && node.node_claimed )
				    && !(isdefined(node.spawnflags)&&((node.spawnflags & 512) == 512)) )
				{
					if ( !isdefined( nodes ) ) nodes = []; else if ( !IsArray( nodes ) ) nodes = array( nodes ); nodes[nodes.size]=node;;
					break;
				}
			}

			wait .2;
		}
	}
	
	Assert( nodesPresent, "No spawner target nodes for AI." );

	goal = undefined;
	if ( nodes.size > 0 )
	{
		goal = array::random( nodes );
	}
	
	if ( isdefined( goal ) )
	{
		// If script has set the goalradius then use it to go to the spawner target
		if ( isdefined( self.script_radius ) )
		{
			self.goalradius = self.script_radius;
		}
		else
		{
			self.goalradius = 400;  // TODO: this is temp
		}
		
		goal.node_claimed = true;
		self SetGoal( goal );
		
		self notify( "spawner_target_set" );
		
		self thread release_spawner_target_node( goal );

		self waittill( "goal" );
	}
	
	self set_goalradius_based_on_settings( goal );
}

function release_spawner_target_node( node )
{
	self util::waittill_any( "death", "goal_changed" );
	node.node_claimed = undefined;
}

// GLocke: 5/26/10 - changed this to use a global level array instead of recreating
// the node array everytime an AI is told to go_to_spawner_target
function get_spawner_target_nodes(group)
{
	if ( group == "" )
	{
		return [];
	}

	nodes = [];
	for ( i = 0; i < level.script_spawner_targets_nodes.size; i++)
	{
		groups = strtok( level.script_spawner_targets_nodes[i].script_spawner_targets, " ");

		for ( j = 0; j < groups.size; j++)
		{
			if ( groups[j] == group )
			{
				nodes[nodes.size] = level.script_spawner_targets_nodes[i];
			}
		}
	}

	return nodes;
}

//////////////////////////////////////////////////////////////////
/////////// End of script_spawner_targets handling ///////////////
//////////////////////////////////////////////////////////////////

function get_least_used_from_array( array )
{
	assert( array.size > 0, "Somehow array had zero entrees" );
	if ( array.size == 1 )
	{
		return array[ 0 ];
	}
		
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


function go_to_node_using_funcs( node, get_target_func, set_goal_func_quits, optional_arrived_at_node_func, require_player_dist )
{
	// AI is moving to a goal node
	self endon( "stop_going_to_node" );
	self endon( "death" );

	for ( ;; )
	{
		// node should always be an array at this point, so lets get just 1 out of the array
		node = get_least_used_from_array( node );

		player_wait_dist = require_player_dist;
		if( isdefined( node.script_requires_player ) )
		{
			if( node.script_requires_player > 1 )
				player_wait_dist = node.script_requires_player;
			else
				player_wait_dist = 256;
		
			node.script_requires_player = false;
		}

		self set_goalradius_based_on_settings( node );
	
		if ( isdefined( node.height ) )
		{
			self.goalheight = node.height;
		}
		
		[[ set_goal_func_quits ]]( node );
		self waittill( "goal" );

		[[ optional_arrived_at_node_func ]]( node );

		if ( isdefined( node.script_flag_set ) )
		{
			level flag::set( node.script_flag_set );
		}
	
		if ( isdefined( node.script_flag_clear ) )
		{
			level flag::set( node.script_flag_clear );
		}
			
		if ( isdefined( node.script_ent_flag_set ) )
		{
			if( !self flag::exists( node.script_ent_flag_set ) )
				AssertMsg( "Tried to set a ent flag  "+ node.script_ent_flag_set +"  on a node, but it doesnt exist." );

			self flag::set( node.script_ent_flag_set );
		}

		if ( isdefined( node.script_ent_flag_clear ) )
		{
			if( !self flag::exists( node.script_ent_flag_clear ) )
				AssertMsg( "Tried to clear a ent flag  "+ node.script_ent_flag_clear +"  on a node, but it doesnt exist." );

			self flag::clear( node.script_ent_flag_clear );
		}
	
		if ( isdefined( node.script_flag_wait ) )
		{
			level flag::wait_till( node.script_flag_wait );
		}

		while ( isdefined( node.script_requires_player ) )
		{
			node.script_requires_player = false;
			if ( self go_to_node_wait_for_player( node, get_target_func, player_wait_dist ) )
			{
				node.script_requires_player = true;
				node notify( "script_requires_player" );
				break;
			}

			wait 0.1;
		}
		
		if( isdefined( node.script_aigroup ) )
		{
			waittill_ai_group_cleared(  node.script_aigroup  );
		}

		node util::script_delay();

		if ( !isdefined( node.target ) )
		{
			break;
		}

		nextNode_array = update_target_array( node.target );
		if ( !nextNode_array.size )
		{
			break;
		}

		node = nextNode_array;
	}


	if( isdefined( self.arrived_at_end_node_func ) )
		[[ self.arrived_at_end_node_func ]]( node );

	self notify( "reached_path_end" );

	if( isdefined( self.delete_on_path_end ) )
		self Delete();

	self set_goalradius_based_on_settings( node );
}


function go_to_node_wait_for_player( node, get_target_func, dist )
{
	//are any of the players closer to the node than we are?
	players = GetPlayers();

	for( i=0; i< players.size; i++ )
	{
		player = players[i];

		if ( distancesquared( player.origin, node.origin ) < distancesquared( self.origin, node.origin ) )
			return true;
	}

	//are any of the player ahead of us based on our forward angle?
	vec = anglestoforward( self.angles );
	if ( isdefined( node.target ) )
	{
		temp = [[ get_target_func ]]( node.target );

		//if we only have one node then we can get the forward from that one to us
		if ( temp.size == 1 )
			vec = vectornormalize( temp[ 0 ].origin - node.origin );
		//otherwise since we dont know which one we're taking yet the next best thing to do is to take the forward of the node we're on
		else if ( isdefined( node.angles ) )
			vec = anglestoforward( node.angles );
	}
	//also if there is no target since we're at the end of the chain, the next best thing to do is to take the forward of the node we're on
	else if ( isdefined( node.angles ) )
		vec = anglestoforward( node.angles );

	vec2 = [];

	for( i=0; i< players.size; i++ )
	{
		player = players[i];

		vec2[ vec2.size ] = vectornormalize( ( player.origin - self.origin ) );
	}

	//i just created a vector which is in the direction i want to
	//go, lets see if the player is closer to our goal than we are
	for( i=0; i< vec2.size; i++ )
	{
		value = vec2[i];

		if ( vectordot( vec, value ) > 0 )
			return true;
	}

	//ok so that just checked if he was a mile away but more towards the target
	//than us...but we dont want him to be right on top of us before we start moving
	//so lets also do a distance check to see if he's close behind
	dist2rd = dist * dist;
	for( i=0; i< players.size; i++ )
	{
		player = players[i];

		if ( distancesquared( player.origin, self.origin ) < dist2rd )
			return true;
	}

	//ok guess he's not here yet
	return false;
}


function go_to_node_set_goal_pos( ent )
{
	self SetGoal( ent.origin );
}

function go_to_node_set_goal_node( node )
{
	self SetGoal( node );
}

function remove_crawled( ent )
{
	waittillframeend;
	if ( isdefined( ent ) )
	{
		ent.crawled = undefined;
	}
}

function crawl_target_and_init_flags( ent, get_func )
{
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
					level flag::init( ent.script_flag_set );
				}
			}
		
			if ( isdefined( ent.script_flag_wait ) )
			{
				if ( !isdefined( level.flag[ ent.script_flag_wait ] ) )
				{
					level flag::init( ent.script_flag_wait );
				}
			}

			if ( isdefined( ent.target ) )
			{
				new_targets = [[ get_func ]]( ent.target );
				array::add( targets, new_targets );
			}
		}
			
		index++ ;
		if ( index >= targets.size )
		{
			break;
		}
			
		ent = targets[ index ];
	}
}

function get_node_funcs_based_on_target( node, goal_type )
{
	// figure out if its a node or script origin and set the goal_type index based on that.

	// true is for script_origins, false is for nodes
	get_target_func[ "origin" ] =&get_target_ents;
	get_target_func[ "node" ] =&get_target_nodes;
	get_target_func[ "struct" ] =&get_target_structs;

	set_goal_func_quits[ "origin" ] =&go_to_node_set_goal_pos;
	set_goal_func_quits[ "struct" ] =&go_to_node_set_goal_pos;
	set_goal_func_quits[ "node" ] =&go_to_node_set_goal_node;
	
	// if you pass a node, we'll assume you actually passed a node. We can make it find out if its a script origin later if we need that functionality.
	if ( !isdefined( goal_type ) )
	{
		goal_type = "node";
	}
	
	array = [];
	if ( isdefined( node ) )
	{
		array[ "node" ][ 0 ] = node;
	}
	else
	{
		// if you dont pass a node then we need to figure out what type of target it is
		node = GetEntArray( self.target, "targetname" );
	
		if ( node.size > 0 )
		{
			goal_type = "origin";
		}

		if ( goal_type == "node" )
		{
			node = getnodearray( self.target, "targetname" );
			if ( !node.size )
			{
				node = struct::get_array( self.target, "targetname" );
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

//Check to see if target exists and return it
function update_target_array( str_target )
{
	//Check if node
	a_nd_target = GetNodeArray( str_target, "targetname" );
	if( a_nd_target.size )
	{
		return a_nd_target;
	}
	
	//Check if struct
	a_s_target = struct::get_array( str_target, "targetname" );
	if( a_s_target.size )
	{
		return a_s_target;
	}
	
	//Check if "origin"/volume/ent
	a_e_target = GetEntArray( str_target, "targetname" );
	if( a_e_target.size )
	{
		return a_e_target;
	}	
}


function set_goalradius_based_on_settings( node )
{
	self endon( "death" );
	waittillframeend;
	if( isdefined( self.script_radius ) )
	{
		// use the override from radiant
		self.goalradius = self.script_radius;
	}
	else if ( isdefined( node ) && node_has_radius( node ) )
	{
		self.goalradius = node.radius;
	}

	if( ( isdefined( self.script_forcegoal ) && self.script_forcegoal ) )
	{
		n_radius = ( self.script_forcegoal > 1 ? self.script_forcegoal : undefined );
		self thread ai::force_goal( get_goal( self.target ), n_radius );
	}
}

function get_goal( str_goal, str_key = "targetname" )
{
	a_goals = GetNodeArray( str_goal, str_key );
	if ( !a_goals.size )
	{
		a_goals = GetEntArray( str_goal, str_key );
	}
	
	return array::random( a_goals );
}

function fallback_spawner_think( num, node_array, ignoreWhileFallingBack )
{
	self endon( "death" );
		
	level.max_fallbackers[num]+= self.count;
	firstspawn = true;
	while( self.count > 0 )
	{
		self waittill( "spawned", spawn );
		if( firstspawn )
		{
			/#
			if( GetDvarString( "fallback" ) == "1" )
			{
				println( "^a First spawned: ", num );
			}
			#/
			level notify( ( "fallback_firstspawn" + num ) );
			firstspawn = false;
		}
		
		{wait(.05);}; // Wait until he does all his usual spawned logic so he will run to his node
		if( spawn_failed( spawn ) )
		{
			level notify( ( "fallbacker_died" + num ) );
			level.max_fallbackers[num]--;
			continue;
		}

		spawn thread fallback_ai_think( num, node_array, "is spawner", ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
	}

	//level notify( ( "fallbacker_died" + num ) );
}

function fallback_ai_think_death( ai, num )
{
	ai waittill( "death" );
	level.current_fallbackers[num]--;

	level notify( ( "fallbacker_died" + num ) );
}

function fallback_ai_think( num, node_array, spawner, ignoreWhileFallingBack )
{
	if( ( !isdefined( self.fallback ) ) ||( !isdefined( self.fallback[num] ) ) )
	{
		self.fallback[num] = true;
	}
	else
	{
		return;
	}

	self.script_fallback = num;
	if( !isdefined( spawner ) )
	{
		level.current_fallbackers[num]++;
	}

	if( ( isdefined( node_array ) ) &&( level.fallback_initiated[num] ) )
	{
		self thread fallback_ai( num, node_array, ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
	}

	level thread fallback_ai_think_death( self, num );
}

function fallback_death( ai, num )
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
function fallback_goal( ignoreWhileFallingBack )
{
	self waittill( "goal" );
	self.ignoresuppression = false;
	
	if( isdefined( ignoreWhileFallingBack ) && ignoreWhileFallingBack )
	{
		self.ignoreall = false;
	}

	self notify( "fallback_notify" );
	self notify( "stop_coverprint" );
}

function fallback_interrupt()
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
function fallback_ai( num, node_array, ignoreWhileFallingBack )
{
	self notify( "stop_going_to_node" );
	self endon( "stop_going_to_node" );
	self endon ("goto next fallback");
	self endon( "death" );  // SRS 5/21/2008: bugfix - this kept running after AIs were dead

	node = undefined;
	// set the goalnode
	while( 1 )
	{
		assert((node_array.size >= level.current_fallbackers[num]), "Number of fallbackers exceeds number of fallback nodes for fallback # " + num + ". Add more fallback nodes or reduce possible fallbackers.");
		
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
	//TODO T7 - function port
	//self StopUseTurret();

	self.ignoresuppression = true;
	
	if( self.ignoreall == false && isdefined( ignoreWhileFallingBack ) && ignoreWhileFallingBack )
	{
		self.ignoreall = true;
		self thread fallback_interrupt();
	}
		
	self SetGoal( node );
	if( node.radius != 0 )
	{
		self.goalradius = node.radius;
	}

	self endon( "death" );
	level thread fallback_death( self, num );
	self thread fallback_goal( ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
/#
	if( GetDvarString( "fallback" ) == "1" )
	{
		self thread coverprint( node.origin );
	}
	#/	
	self waittill( "fallback_notify" );
	level notify( ( "fallback_reached_goal" + num ) );
}

/#
function coverprint( org )
{
	self endon( "fallback_notify" );
	self endon( "stop_coverprint" );
	self endon ("death");
	while( 1 )
	{
		line( self.origin +( 0, 0, 35 ), org, ( 0.2, 0.5, 0.8 ), 0.5 );
		print3d( ( self.origin +( 0, 0, 70 ) ), "Falling Back", ( 0.98, 0.4, 0.26 ), 0.85 );
		{wait(.05);};
	}
}
#/
	
// This gets set up on each fallback trigger
// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
function fallback_overmind( num, group, ignoreWhileFallingBack, percent )
{
	fallback_nodes = undefined;
	nodes = GetAllNodes();
	for( i = 0; i < nodes.size; i++ )
	{
		if( ( isdefined( nodes[i].script_fallback ) ) &&( nodes[i].script_fallback == num ) )
		{
			array::add( fallback_nodes, nodes[i] );
		}
	}

	if( isdefined( fallback_nodes ) )
	{
		level thread fallback_overmind_internal( num, group, fallback_nodes, ignoreWhileFallingBack, percent );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
	}
}

// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
function fallback_overmind_internal( num, group, fallback_nodes, ignoreWhileFallingBack, percent )
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
		if( ( isdefined( spawners[i].script_fallback ) ) &&( spawners[i].script_fallback == num ) )
		{
			if( spawners[i].count > 0 )
			{
				spawners[i] thread fallback_spawner_think( num, fallback_nodes, ignoreWhileFallingBack );  // SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
				level.spawner_fallbackers[num]++;
			}
		}
	}

	assert( level.spawner_fallbackers[num] <= fallback_nodes.size, "There are more fallback spawners than fallback nodes. Add more node or remove spawners from script_fallback: "+ num );

	ai = GetAIArray();
	for( i = 0; i < ai.size; i++ )
	{
		if( ( isdefined( ai[i].script_fallback ) ) &&( ai[i].script_fallback == num ) )
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

	/#
	if( GetDvarString( "fallback" ) == "1" )
	{
		println( "^a fallback trigger hit: ", num );
	}
	#/
		
	level.fallback_initiated[num] = true;

	fallback_ai = undefined;
	ai = GetAIArray();
	for( i = 0; i < ai.size; i++ )
	{
		if( ( ( isdefined( ai[i].script_fallback ) ) &&( ai[i].script_fallback == num ) ) || ( ( isdefined( ai[i].script_fallback_group ) ) &&( isdefined( group ) ) &&( ai[i].script_fallback_group == group ) ) )
		{
			array::add( fallback_ai, ai[i] );
		}
	}
	ai = undefined;

	if( !isdefined( fallback_ai ) )
	{
		return;
	}

	if( !isdefined( percent ) )
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

function fallback_text( fallbackers, start, end )
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

		return;
	}
}

// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
function fallback_wait( num, group, ignoreWhileFallingBack, percent )
{
	level endon( ( "fallbacker_trigger" + num ) );
	/#
	if( GetDvarString( "fallback" ) == "1" )
	{
		println( "^a Fallback wait: ", num );
	}
	#/
	for( i = 0; i < level.spawner_fallbackers[num]; i++ )
	{
		/#
		if( GetDvarString( "fallback" ) == "1" )
		{
			println( "^a Waiting for spawners to be hit: ", num, " i: ", i );
		}
		#/
		level waittill( ( "fallback_firstspawn" + num ) );
	}
	/#
	if( GetDvarString( "fallback" ) == "1" )
	{
		println( "^a Waiting for AI to die, fall backers for group ", num, " is ", level.current_fallbackers[num] );
	}
	#/
		
//	total_fallbackers = 0;
	ai = GetAIArray();
	for( i = 0; i < ai.size; i++ )
	{
		if( ( ( isdefined( ai[i].script_fallback ) ) &&( ai[i].script_fallback == num ) ) || ( ( isdefined( ai[i].script_fallback_group ) ) &&( isdefined( group ) ) &&( ai[i].script_fallback_group == group ) ) )
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
		/#
		if( GetDvarString( "fallback" ) == "1" )
		{
			println( "^cwaiting for " + deadfallbackers + " to be more than " +( level.max_fallbackers[num] * 0.5 ) );
		}
		#/
		level waittill( ( "fallbacker_died" + num ) );
		deadfallbackers++;
	}

	/#println( deadfallbackers , " fallbackers have died, time to retreat" );#/
	level notify( ( "fallbacker_trigger" + num ) );
}

// for fallback trigger
// SRS 5/3/2008: updated to allow AIs to ignoreall while falling back
//  Note: multiple triggers will need to have script_ignoreall set identically on all triggers
//  for consistency when AIs decide to ignore while falling back or not.
function fallback_think( trigger )
{
	ignoreWhileFallingBack = false;
	if( isdefined( trigger.script_ignoreall ) && trigger.script_ignoreall )
	{
		ignoreWhileFallingBack = true;
	}
	
	if( ( !isdefined( level.fallback ) ) ||( !isdefined( level.fallback[trigger.script_fallback] ) ) )
	{
		// MikeD (5/7/2008): Added the ability to determine the percent of guys that will fallback
		// when this trigger is hit.
		percent = 0.5;
		if( isdefined( trigger.script_percent ) )
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
function fallback_add_previous_group(num, node_array)
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

	ai = GetAIArray();
	for( i = 0; i < ai.size; i++ )
	{
		if( ( ( isdefined( ai[i].script_fallback ) ) && ( ai[i].script_fallback == (num - 1) ) ) )
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

/* DEAD CODE REMOVAL
function delete_me()
{
	WAIT_SERVER_FRAME;
	self Delete();
}
*/

/* DEAD CODE REMOVAL
function waitframe()
{
	WAIT_SERVER_FRAME;
}
*/

/* DEAD CODE REMOVAL
function friendly_mg42_death_notify( guy, mg42 )
{
	mg42 endon( "friendly_finished_using_mg42" );
	guy waittill( "death" );
	mg42 notify( "friendly_finished_using_mg42" );
	println( "^a guy using gun died" );
}
*/

/* DEAD CODE REMOVAL
function friendly_mg42_wait_for_use( mg42 )
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
*/

/* DEAD CODE REMOVAL
function friendly_mg42_useable( mg42, node )
{
	if( self.useable )
	{
		return false;
	}
		
	if( ( isdefined( self.turret_use_time ) ) &&( GetTime() < self.turret_use_time ) )
	{
//		println( "^a Used gun too recently" );
		return false;
	}

	// check to see if any player is too close.
	players = GetPlayers();
	for( q = 0; q < players.size; q++ )
	{
		if( Distancesquared( players[q].origin, node.origin ) < 100 * 100 )
		{
//			println( "^a player too close" );
			return false;
		}
	}

	if( isdefined( self.chainnode ) )
	{
		// check to see if all players are too far
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
*/

/* DEAD CODE REMOVAL
function friendly_mg42_endtrigger( mg42, guy )
{
	mg42 endon( "friendly_finished_using_mg42" );
	self waittill( "trigger" );
	println( "^a Told friendly to leave the MG42 now" );
//	guy StopUSeturret();

	mg42 notify( "friendly_finished_using_mg42" );
}
*/

/* DEAD CODE REMOVAL
function noFour()
{
	self endon( "death" );
	self waittill( "goal" );
	self.goalradius = self.oldradius;
	if( self.goalradius < 32 )
	{
		self.goalradius = 400;
	}
}
*/

/* DEAD CODE REMOVAL
function friendly_mg42_think( mg42, node )
{
	self endon( "death" );
	mg42 endon( "friendly_finished_using_mg42" );

	level thread friendly_mg42_death_notify( self, mg42 );

	self.oldradius = self.goalradius;
	self.goalradius = 28;
	self thread noFour();
	self SetGoal( node );

	self.ignoresuppression = true;

	self waittill( "goal" );
	self.goalradius = self.oldradius;
	if( self.goalradius < 32 )
	{
		self.goalradius = 400;
	}

	self.ignoresuppression = false;

	self.goalradius = self.oldradius;

	// check to see if any play is too close
	players = GetPlayers();
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

	if( isdefined( mg42.target ) )
	{
		stoptrigger = GetEnt( mg42.target, "targetname" );
		if( isdefined( stoptrigger ) )
		{
			stoptrigger thread friendly_mg42_endtrigger( mg42, self );
		}
	}

	while( 1 )
	{
		if( Distancesquared( self.origin, node.origin ) < 32*32 )
		{
			self USeturret( mg42 ); // dude should be near the mg42
		}
		else
		{
			break; // a friendly is too far from mg42, stop using turret
		}

		if( isdefined( self.chainnode ) )
		{
			if( Distancesquared( self.origin, self.chainnode.origin ) > 1100*1100 )
			{
				break; // friendly node is too far, stop using turret
			}
		}

		wait( 1 );
	}

	mg42 notify( "friendly_finished_using_mg42" );
}
*/

/* DEAD CODE REMOVAL
function friendly_mg42_cleanup( mg42 )
{
	self endon( "death" );
	mg42 waittill( "friendly_finished_using_mg42" );
	self friendly_mg42_doneUsingTurret();
}
*/

/* DEAD CODE REMOVAL
function friendly_mg42_doneUsingTurret()
{
	self endon( "death" );
	turret = self.friendly_mg42;
	self.friendly_mg42 = undefined;
	self StopUSeturret();
	self notify( "stopped_use_turret" ); // special hook for decoytown guys -nate
	self.useable = false;
	self.goalradius = self.oldradius;
	if( !isdefined( turret ) )
	{
		return;
	}

	if( !isdefined( turret.target ) )
	{
		return;
	}

	node = GetNode( turret.target, "targetname" );
	oldradius = self.goalradius;
	self.goalradius = 8;
	self SetGoal( node );
	wait( 2 );
	self.goalradius = 384;
	return;
	self waittill( "goal" );
	if( isdefined( self.target ) )
	{
		node = GetNode( self.target, "targetname" );
		if( isdefined( node.target ) )
		{
			node = GetNode( node.target, "targetname" );
		}
			
		if( isdefined( node ) )
		{
			self SetGoal( node );
		}
	}
	self.goalradius = oldradius;
}
*/


/* DEAD CODE REMOVAL
function spawnWaypointFriendlies()
{
	self.count = 1;
	spawn = self spawn_ai();
		
	if ( spawn_failed( spawn ) )
	{
		return;
	}
	
	spawn.friendlyWaypoint = true;
}
*/

function aigroup_init( aigroup, spawner )
{
	if ( !isdefined( level._ai_group[aigroup] ) )
	{
		level._ai_group[aigroup] = SpawnStruct();
		level._ai_group[aigroup].aigroup = aigroup;
		level._ai_group[aigroup].aicount = 0;
		level._ai_group[aigroup].killed_count = 0;
		level._ai_group[aigroup].ai = [];
		level._ai_group[aigroup].spawners = [];
		level._ai_group[aigroup].cleared_count = 0;

		if ( !isdefined( level.flag[aigroup + "_cleared"] ) )
		{
			level flag::init(aigroup + "_cleared");
		}
		
		if ( !isdefined( level.flag[aigroup + "_spawning"] ) )
		{
			level flag::init(aigroup + "_spawning");
		}

		level thread set_ai_group_cleared_flag( level._ai_group[aigroup] );
	}

	if ( isdefined( spawner ) )
	{
		if ( !isdefined( level._ai_group[aigroup].spawners ) ) level._ai_group[aigroup].spawners = []; else if ( !IsArray( level._ai_group[aigroup].spawners ) ) level._ai_group[aigroup].spawners = array( level._ai_group[aigroup].spawners ); level._ai_group[aigroup].spawners[level._ai_group[aigroup].spawners.size]=spawner;;
		spawner thread aigroup_spawner_death( level._ai_group[aigroup] );
	}
}

function aigroup_spawner_death( tracker )
{
	self util::waittill_any( "death", "aigroup_spawner_death" );
	tracker notify( "update_aigroup" );
}

function aigroup_think( tracker )
{
	tracker.aicount++;
	tracker.ai[tracker.ai.size] = self;
	tracker notify( "update_aigroup" );
	
	if ( isdefined( self.script_deathflag_longdeath ) )
	{
		self waittillDeathOrPainDeath();
	}
	else
	{
		self waittill( "death" );
	}

	tracker.aicount--;
	tracker.killed_count++;	
	tracker notify( "update_aigroup" );
}

function set_ai_group_cleared_flag( tracker )
{
	waittillframeend;	// wait for all spawners to get added to group

	while ( ( tracker.aicount + get_ai_group_spawner_count( tracker.aigroup ) ) > tracker.cleared_count )
	{
		tracker waittill( "update_aigroup" );
	}
	
	level flag::set( tracker.aigroup + "_cleared" );
}

// flood_spawner

function flood_trigger_think( trigger )
{
	assert( isdefined( trigger.target ), "flood_spawner at " + trigger.origin + " without target" );
	
	floodSpawners = GetEntArray( trigger.target, "targetname" );
	assert( floodSpawners.size, "flood_spawner at with target " + trigger.target + " without any targets" );
	
	for(i = 0; i < floodSpawners.size; i++)
	{
		floodSpawners[i].script_trigger = trigger;
	}
	
/*	choke = true;
	
	if(isdefined(trigger.script_choke) && !trigger.script_choke)
	{
		choke = true;
	}

	for(i = 0; i < floodSpawners.size; i++)
	{
		floodSpawners[i].script_choke = choke;
	}

	*/
	array::thread_all( floodSpawners,&flood_spawner_init );
	
	trigger waittill( "trigger" );
	// reget the target array since targets may have been deletes, etc... between initialization and triggering
	floodSpawners = GetEntArray( trigger.target, "targetname" );
/*	if(choke && NumRemoteClients())
	{
		util::spread_array_thread(floodSpawners,&flood_spawner_think, trigger);
	}
	else*/
	{
		array::thread_all( floodSpawners,&flood_spawner_think, trigger );
	}
}


function flood_spawner_init( spawner )
{
	Assert( (isdefined(self.spawnflags)&&((self.spawnflags & 1) == 1)), "Spawner at origin" + self.origin + "/" +( self GetOrigin() ) + " is not a spawner!" );
}

function trigger_requires_player( trigger )
{
	if( !isdefined( trigger ) )
	{
		return false;
	}
		
	return isdefined( trigger.script_requires_player );
}

function flood_spawner_think( trigger )
{
	self endon( "death" );
	self notify( "stop current floodspawner" );
	self endon( "stop current floodspawner" );
		
	requires_player = trigger_requires_player( trigger );

	util::script_delay();
	
	while( self.count > 0 )
	{
		// see if any player is touching the trigger.
// AlexL (6/26/2007): This line asserts when trigger is undefined. New version accomodated undefined trigger.
//		while( requires_player && !util::any_player_is_touching( trigger ) )
		if( requires_player ) // 0 if trigger is undefined
		{
			while( !util::any_player_is_touching( trigger ) )
			{
				wait( 0.5 );
			}
		}

		soldier = self spawner::spawn();

		if( spawn_failed( soldier ) )
		{
			wait( 2 );
			continue;
		}

		soldier thread reincrement_count_if_deleted( self );

		soldier waittill( "death", attacker );
		if ( !player_saw_kill( soldier, attacker ) )
		{
			self.count++;
		}

		// soldier was deleted, not killed
		if( !isdefined( soldier ) )
		{
			continue;
		}

		if( !util::script_wait( true ) )
		{
			players = GetPlayers();

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

function player_saw_kill( guy, attacker )
{
	if ( isdefined( self.script_force_count ) )
	{
		if ( self.script_force_count )
		{
			return true;
		}
	}

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

		players = GetPlayers();

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
				
			player = util::get_closest_player( attacker.origin );
			if ( isdefined( player ) && distancesquared( attacker.origin, player.origin ) < 200*200 )
			{
				// player was near the guy that killed the ai?
				return true;
			}
		}
	}
	
	// get the closest player
	closest_player = util::get_closest_player( guy.origin );
	if (  isdefined( closest_player ) && distancesquared( guy.origin, closest_player.origin ) < 200*200 )
	{
		// player was near the guy that got killed?
		return true;
	}

	// did the player see the guy die?
	return bulletTracePassed( closest_player geteye(), guy geteye(), false, undefined );
}

function show_bad_path()
{
	 /#
	/*if ( GetDvarString( "debug_badpath" ) == "" )
		SetDvar( "debug_badpath", "" );*/

	self endon( "death" );
	last_bad_path_time = -5000;
	bad_path_count = 0;
	for ( ;; )
	{
		self waittill( "bad_path", badPathPos );
		
		if ( !isdefined(level.debug_badpath) || !level.debug_badpath )
		{
			continue;
		}

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
		{
			continue;
		}
		
		for ( p = 0; p < 10 * 20; p++ )
		{
			line( self.origin, badPathPos, ( 1, 0.4, 0.1 ), 0, 10 * 20 );
			{wait(.05);};
		}
	}
	#/
}


//function objective_event_init( trigger )
//{
//	flag = trigger util::get_trigger_flag();
//	assert( isdefined( flag ), "Objective event at origin " + trigger.origin + " does not have a script_flag. " );
//	level flag::init( flag );
//		
//	assert( isdefined( level.deathSpawner[trigger.script_deathChain] ), "The objective event trigger for deathchain " + trigger.script_deathchain + " is not associated with any AI." );
//	/#
//	if( !isdefined( level.deathSpawner[trigger.script_deathChain] ) )
//	{
//		return;
//	}
//	#/
//	while( level.deathSpawner[trigger.script_deathChain] > 0 )
//	{
//		level waittill( "spawner_expired" + trigger.script_deathChain );
//	}
//		
//	level flag::set( flag );
//}

//-- self == ai
function watches_for_friendly_fire() 
{
	//-- if you are an allied force that shouldn't use friendlyfire, then you are setup here
	
	//-- Afghanistan 1st Playable Milestone
	/*
	if( level.script == "afghanistan")
	{
		return false;
	}
	*/

	return true;
}

/@
"Name: spawn()"
"Summary: Spawns an AI from an AI spawner. Handles force spawning based on 'script_forcespawn' value."
"Module: Utility"
"OptionalArg: [bForceSpawn]: Set to true to force spawn the AI"
"OptionalArg: [v_origin]: Origin spawn the AI"
"OptionalArg: [v_angles]: Angles to spawn the AI"
"Example: guy = spawner spawn();"
"SPMP: singleplayer"
@/
function spawn( b_force = false, str_targetname, v_origin, v_angles, bIgnoreSpawningLimit )
{
	if( IsDefined( level.overrideGlobalSpawnFunc ) && self.team == "axis" )
	{
		return [[level.overrideGlobalSpawnFunc]]( b_force, str_targetname, v_origin, v_angles );
	}
	
	e_spawned = undefined;
	force_spawn = false;
	makeroom = false;
	infinitespawn = false;
	deleteonzerocount = false;
	
	/#
	if ( GetDvarString( "noai" ) != "off" )
	{
		return;
	}
	#/
		
	if ( ( isdefined( self.script_minplayers ) && ( self.script_minplayers > level.players.size ) )
		    || ( isdefined( self.script_numplayers ) && ( self.script_numplayers > level.players.size ) )
		    || ( isdefined( self.script_maxplayers ) && ( self.script_maxplayers < level.players.size ) ) )
	{
		self Delete();
		return;
	}
		
	// SUMEET - This check is to avoid script errors due to spawning two AI's from the same spawner on the
	// same frame.
	while ( ( isdefined( self.lastSpawnTime ) && self.lastSpawnTime >= GetTime() )
	       || ( !( isdefined( bIgnoreSpawningLimit ) && bIgnoreSpawningLimit ) && level.global_spawn_count >= 3 ) )
	{
		{wait(.05);};
	}
		
	if ( IsActorSpawner( self ) )
	{
		if ( (isdefined(self.spawnflags)&&((self.spawnflags & 2) == 2)) )
		{
			makeroom = true;
		}
	}
	else if ( IsVehicleSpawner( self ) )
	{
		if ( (isdefined(self.spawnflags)&&((self.spawnflags & 8) == 8)) )
		{
			makeroom = true;
		}
	}
	
	// ForceSpawn and InfiniteSpawn flags match between actors and vehicles
	if ( b_force || (isdefined(self.spawnflags)&&((self.spawnflags & 16) == 16)) || isdefined( self.script_forcespawn ) )
	{
		force_spawn = true;
	}
		
	if ( (isdefined(self.spawnflags)&&((self.spawnflags & 64) == 64)) )
	{
		infinitespawn = true;
	}
		
	/#
	// Override what type of archetype is spawned.
	if ( IsDefined( level.archetype_spawners ) && IsArray( level.archetype_spawners ) )
	{	
		archetype_spawner = undefined;
		
		if ( self.team == "axis" )
		{
			archetype = GetDvarString( "feature_ai_enemy_archetype" );
			if ( GetDvarString( "feature_ai_archetype_override" ) == "ally" )
			{
				archetype = GetDvarString( "feature_ai_ally_archetype" );
			}
			archetype_spawner = level.archetype_spawners[archetype];
		}
		else if ( self.team == "allies" )
		{
			archetype = GetDvarString( "feature_ai_ally_archetype" );
			if ( GetDvarString( "feature_ai_archetype_override" ) == "enemy" )
			{
				archetype = GetDvarString( "feature_ai_enemy_archetype" );
			}
			archetype_spawner = level.archetype_spawners[archetype];
		}
		
		if ( IsSpawner( archetype_spawner ) )
		{
			while ( IsDefined( archetype_spawner.lastSpawnTime ) &&
				archetype_spawner.lastSpawnTime >= GetTime() )
			{
				{wait(.05);};
			}
		
			originalOrigin = archetype_spawner.origin;
			originalAngles = archetype_spawner.angles;
			originalTarget = archetype_spawner.target;
			originalTargetName = archetype_spawner.targetname;
			
			archetype_spawner.target = self.target;
			archetype_spawner.targetname = self.targetname;
			archetype_spawner.script_noteworthy = self.script_noteworthy;
			archetype_spawner.script_string = self.script_string;
			archetype_spawner.origin = self.origin;
			archetype_spawner.angles = self.angles;
			
			e_spawned = archetype_spawner SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn );
			
			archetype_spawner.target = originalTarget;
			archetype_spawner.targetname = originalTargetName;
			archetype_spawner.origin = originalOrigin;
			archetype_spawner.angles = originalAngles;
						
			if ( (isdefined(archetype_spawner.spawnflags)&&((archetype_spawner.spawnflags & 64) == 64)) )
			{
				archetype_spawner.count++;
			}
			
			archetype_spawner.lastSpawnTime = GetTime();
		}
	}
	#/
	
	if ( !IsDefined( e_spawned ) )
	{
		female_override = undefined;
		use_female = RandomInt( 100 ) < level.female_percent;
		if( level.dont_use_female_replacements === true )  //allows female mapping to selectively be disabled for certain sections of a level
		{
			use_female = 0;
		}
		if ( isdefined( level.female_mapping_table ) && isdefined( level.female_mapping_table[ self.classname ] ) && use_female )
		{
			female_override = level.female_mapping_table[ self.classname ];
		}

		if ( IsDefined( female_override ) )
		{
			e_spawned = self SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn, female_override );
		}
		else
		{
            override_aitype = undefined;
            
            if( isDefined( level.override_spawned_aitype_func ))
            {
                override_aitype = [[ level.override_spawned_aitype_func ]]( self );
            }
            
            if( IsDefined( override_aitype ) )
            {
                e_spawned = self SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn, override_aitype );
            }
            else
            {
                e_spawned = self SpawnFromSpawner( str_targetname, force_spawn, makeroom, infinitespawn );
            }
		}
		
	}
	
	// Store the last spawned time on the spawner
	if ( IsDefined( e_spawned ) )
	{
		level.global_spawn_count++;
		
		if( isdefined( level.run_custom_function_on_ai ) )
		{
			if( IsDefined( archetype_spawner ) )
				e_spawned thread [[level.run_custom_function_on_ai]]( archetype_spawner, str_targetname, force_spawn );
			else
				e_spawned thread [[level.run_custom_function_on_ai]]( self, str_targetname, force_spawn );
		}

		if ( isdefined( v_origin ) || isdefined( v_angles ) )
		{
			e_spawned teleport_spawned( v_origin, v_angles );
		}
		
		self.lastSpawnTime = GetTime();
	}
	
	if ( ( deleteonzerocount || ( isdefined( self.script_delete_on_zero ) && self.script_delete_on_zero ) ) && isdefined( self.count ) && ( self.count <= 0 ) )
	{
		self Delete();
	}
	
	if ( IsSentient( e_spawned ) )
	{
		if ( !spawn_failed( e_spawned ) )
		{
			return e_spawned;
		}
	}
	else
	{
		return e_spawned;
	}
}

function teleport_spawned( v_origin, v_angles )
{
	if(!isdefined(v_origin))v_origin=self.origin;
	if(!isdefined(v_angles))v_angles=self.angles;
	
	if ( IsActor( self ) )
	{
		self ForceTeleport( v_origin, v_angles );
	}
	else
	{
		self.origin = v_origin;
		self.angles = v_angles;
	}
}

/@
"Name: spawn_failed( <spawn> )"
"Summary: Checks to see if the spawned AI spawned correctly or had errors. Also waits until all spawn initialization is complete. Returns true or false."
"Module: AI"
"CallOn: "
"MandatoryArg: <spawn> : The actor that just spawned"
"Example: spawn_failed( level.price );"
"SPMP: singleplayer"
@/
function spawn_failed( spawn )
{
	if ( IsAlive( spawn ) )
	{
		if ( !isdefined( spawn.finished_spawning ) )
		{
			spawn waittill("finished spawning");
		}

		waittillframeend;

		if ( IsAlive( spawn ) )
		{
			return false;
		}
	}

	return true;
}

/@
"Name: kill_spawnernum( <num> )"
"Summary: Kill spawners with script_killspawner value of <num>."
"Module: Utility"
"MandatoryArg: <num> : The killspawner number"
"Example: kill_spawnernum(4);"
"SPMP: singleplayer"
@/
function kill_spawnernum( number )
{
	foreach ( sp in GetSpawnerArray( "" + number, "script_killspawner" ) )
	{
		sp Delete();
	}
}

/@
"Name: disable_replace_on_death()"
"Summary: Disables replace on death for color reinforcements"
"Module: Color"
"CallOn: An AI"
"Example: guy disable_replace_on_death();"
"SPMP: singleplayer"
@/
function disable_replace_on_death()
{
	self.replace_on_death = undefined;
	self notify( "_disable_reinforcement" );
}

/@
"Name: replace_on_death()"
"Summary: Will replace a color guy after he dies. Good for manually putting a respawnable guy onto a color chain."
"Module: Utility"
"CallOn: an actor"
"Example: new_color_guy thread replace_on_death();"
"SPMP: singleplayer"
@/
function replace_on_death()
{
	colors::colorNode_replace_on_death();
}

/@
"Name: set_ai_group_cleared_count( <aigroup>, <count> )"
"Summary: Sets how many guys left in an aigroup for it to be "cleared"."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"MandatoryArg: <count> : How many guys/spawners are left when cleared."
"Example: set_ai_group_cleared_count( "room_1_guys", 2 ); // cleared when 2 guys are left"
"SPMP: singleplayer"
@/
function set_ai_group_cleared_count(aigroup, count)
{
	aigroup_init(aigroup);
	level._ai_group[aigroup].cleared_count = count;
}

/@
"Name: waittill_ai_group_cleared( <aigroup> )"
"Summary: Waits until all of an AI group is cleared, including alive guys and spawners. If any spawners have a count greater than 0, this will continue to wait."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_cleared( "room_1_guys" );"
"SPMP: singleplayer"
@/
function waittill_ai_group_cleared( aigroup )
{
	assert(isdefined(level._ai_group[aigroup]), "The aigroup "+aigroup+" does not exist");
	level flag::wait_till(aigroup + "_cleared");
}

/@
"Name: waittill_ai_group_count( <aigroup>, <count> )"
"Summary: Waits until an AI group's count is equal to or lower than the specified number. The group's count is made up of the sum of its spawner counts and the number of alive guys in the group"
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_count( "room_1_guys", 3 );"
"SPMP: singleplayer"
@/
function waittill_ai_group_count( aigroup, count )
{
	while ( get_ai_group_spawner_count( aigroup ) + level._ai_group[ aigroup ].aicount > count )
	{
		level._ai_group[ aigroup ] waittill( "update_aigroup" );
	}
}

/@
"Name: waittill_ai_group_ai_count( <aigroup>, <count> )"
"Summary: Waits until an AI group's AI count is equal to or lower than the specified number. Only alive guys are counted (spawner counts are not counted)."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_ai_count( "room_1_guys", 3 );"
"SPMP: singleplayer"
@/
function waittill_ai_group_ai_count( aigroup, count )
{
	while( level._ai_group[ aigroup ].aicount > count )
	{
		level._ai_group[ aigroup ] waittill( "update_aigroup" );
	}
}

/@
"Name: waittill_ai_group_spawner_count( <aigroup>, <count> )"
"Summary: Waits until an AI group's spawner count is equal to or lower than the specified number. Only spawner counts are counted (alive AI are not counted)."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_spawner_count( "room_1_guys", 3 );"
"SPMP: singleplayer"
@/
function waittill_ai_group_spawner_count( aigroup, count )
{
	while ( get_ai_group_spawner_count( aigroup ) > count )
	{
		level._ai_group[ aigroup ] waittill( "update_aigroup" );
	}
}

/@
"Name: waittill_ai_group_amount_killed( <aigroup>, <amount_killed> )"
"Summary: Waits until a certain number of members an AI group are killed."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_amount_killed( "room_1_guys", 3 );"
"SPMP: singleplayer"
@/
function waittill_ai_group_amount_killed( aigroup, amount_killed )
{
	while ( level._ai_group[ aigroup ].killed_count < amount_killed )
	{
		level._ai_group[ aigroup ] waittill( "update_aigroup" );
	}
}

/@
"Name: get_ai_group_count( <aigroup> )"
"Summary: Returns the integer sum of alive AI count and spawner count for this group."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: if( get_ai_group_count( "room_1_guys" ) < 3 )..."
"SPMP: singleplayer"
@/
function get_ai_group_count( aigroup )
{
	return( get_ai_group_spawner_count( aigroup ) + level._ai_group[ aigroup ].aicount );
}

/@
"Name: get_ai_group_sentient_count( <aigroup> )"
"Summary: Returns integer of the alive AI count for this group."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: if( get_ai_group_sentient_count( "room_1_guys" ) < 3 )..."
"SPMP: singleplayer"
@/
function get_ai_group_sentient_count( aigroup )
{
	return( level._ai_group[ aigroup ].aicount );
}

function get_ai_group_spawner_count( aigroup )
{
	n_count = 0;
	foreach ( sp in level._ai_group[ aigroup ].spawners )
	{
		if ( isdefined( sp ) )
		{
			n_count += sp.count;
		}
	}
	return n_count;
}

/@
"Name: get_ai_group_ai( <aigroup> )"
"Summary: Returns an array of the alive AI for this group."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: room_1_guys = get_ai_group_ai( "room_1_guys" );"
"SPMP: singleplayer"
@/
function get_ai_group_ai( aigroup )
{
	aiSet = [];
	for( index = 0; index < level._ai_group[ aigroup ].ai.size; index ++ )
	{
		if( !isAlive( level._ai_group[ aigroup ].ai[ index ] ) )
		{
			continue;
		}

		aiSet[ aiSet.size ] = level._ai_group[ aigroup ].ai[ index ];
	}

	return( aiSet );
}

/@
"Name: add_global_spawn_function( <team> , <func> , <param1> , <param2> , <param3> )"
"Summary: All spawners of this team will run this function on spawn."
"Module: Utility"
"MandatoryArg: <team> : The team of the spawners that will run this function."
"MandatoryArg: <func> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"OptionalArg: <param5> : An optional parameter."
"Example: add_global_spawn_function( "axis",&do_the_amazing_thing, some_amazing_parameter );"
"SPMP: singleplayer"
@/

function add_global_spawn_function( team, spawn_func, param1, param2, param3, param4, param5 )
{
	if ( !isdefined( level.spawn_funcs ) )
	{
		level.spawn_funcs = [];
	}
	
    if ( !isdefined( level.spawn_funcs[team] ) )
    {
        level.spawn_funcs[team] = [];
    }

	func = [];
	func[ "function" ] =spawn_func;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	func[ "param5" ] = param5;

	if ( !isdefined( level.spawn_funcs[ team ] ) ) level.spawn_funcs[ team ] = []; else if ( !IsArray( level.spawn_funcs[ team ] ) ) level.spawn_funcs[ team ] = array( level.spawn_funcs[ team ] ); level.spawn_funcs[ team ][level.spawn_funcs[ team ].size]=func;;
}

/@
"Name: add_archetype_spawn_function( <archetype> , <func> , <param1> , <param2> , <param3> )"
"Summary: All spawners of this team will run this function on spawn."
"Module: Utility"
"MandatoryArg: <archetype> : The AI archetype."
"MandatoryArg: <func> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"OptionalArg: <param5> : An optional parameter."
"Example: add_archetype_spawn_function( "basic_soldier", &do_the_amazing_thing, some_amazing_parameter );"
"SPMP: singleplayer"
@/

function add_archetype_spawn_function( archetype, spawn_func, param1, param2, param3, param4, param5 )
{
	if ( !isdefined( level.spawn_funcs ) )
	{
		level.spawn_funcs = [];
	}
	
    if ( !isdefined( level.spawn_funcs[archetype] ) )
    {
        level.spawn_funcs[archetype] = [];
    }
    
	func = [];
	func[ "function" ] = spawn_func;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	func[ "param5" ] = param5;
	
	if ( !isdefined( level.spawn_funcs[ archetype ] ) ) level.spawn_funcs[ archetype ] = []; else if ( !IsArray( level.spawn_funcs[ archetype ] ) ) level.spawn_funcs[ archetype ] = array( level.spawn_funcs[ archetype ] ); level.spawn_funcs[ archetype ][level.spawn_funcs[ archetype ].size]=func;;
}

/@
"Name: remove_global_spawn_function( <team> , <func> )"
"Summary: Remove this function from the global spawn functions for this team."
"Module: Utility"
"MandatoryArg: <team> : The team of the spawners that will no longer run this function."
"MandatoryArg: <func> : The function to remove."
"Example: remove_global_spawn_function( "allies",&do_the_amazing_thing );"
"SPMP: singleplayer"
@/

function remove_global_spawn_function( team,func )
{
	if ( isdefined( level.spawn_funcs ) && isdefined( level.spawn_funcs[team] ) )
	{
		array = [];
		for( i = 0; i < level.spawn_funcs[ team ].size; i++ )
		{
			if( level.spawn_funcs[ team ][ i ][ "function" ] !=func )
			{
				array[ array.size ] = level.spawn_funcs[ team ][ i ];
			}
		}
	
		level.spawn_funcs[ team ] = array;
	}
}

/@
"Name: add_spawn_function( <func> , [param1], [param2], [param3], [param4], [param5] )"
"Summary: Anything that spawns from this spawner will run this function. Anything."
"MandatoryArg: <func1> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"OptionalArg: <param5> : An optional parameter."
"Example: spawner add_spawn_function(&do_the_amazing_thing, some_amazing_parameter );"
"SPMP: singleplayer"
@/
function add_spawn_function( spawn_func, param1, param2, param3, param4, param5 )
{
	assert( !isdefined( level._loadStarted ) || !IsAlive( self ), "Tried to add_spawn_function to a living guy." );

	func = [];
	func[ "function" ] =spawn_func;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	func[ "param5" ] = param5;

	if (!isdefined(self.spawn_funcs))
	{
		self.spawn_funcs = [];
	}

	self.spawn_funcs[ self.spawn_funcs.size ] = func;
}

/@
"Name: remove_spawn_function( <func> )"
"Summary: Remove a previously added spawn function."
"MandatoryArg: <func1> : The function to run."
"Example: spawner remove_spawn_function(&do_the_amazing_thing, some_amazing_parameter );"
"SPMP: singleplayer"
@/
function remove_spawn_function( func )
{
	assert( !isdefined( level._loadStarted ) || !IsAlive( self ), "Tried to remove_spawn_function to a living guy." );

	if ( isdefined( self.spawn_funcs ) )
	{
		array = [];
		for ( i = 0; i < self.spawn_funcs.size; i++ )
		{
			if ( self.spawn_funcs[ i ][ "function" ] != func )
			{
				array[ array.size ] = self.spawn_funcs[ i ];
			}
		}
	
		assert( self.spawn_funcs.size != array.size, "Tried to remove a function from level.spawn_funcs, but that function didn't exist!" );
		self.spawn_funcs = array;
	}
}


/@
"Name: add_spawn_function_group( <str_value>, <str_key>, <func_spawn>, [param_1], [param_2], [param_3], [param_4], [param_5] )"
"Summary: Gets all spawners with specified KVP, then adds spawn function to entire group with up to 5 input arguments."
"Module: Entity"
"CallOn: self unused"
"MandatoryArg: <str_value> Name of the spawners to find"
"MandatoryArg: <str_key> Key of the spawner to find; "targetname", "script_noteworthy", etc"
"MandatoryArg: <func_spawn> Spawn function to add to the spawners"
"OptionalArg: <param_1> Input parameter to function"
"OptionalArg: <param_2> Input parameter to function"
"OptionalArg: <param_3> Input parameter to function"
"OptionalArg: <param_4> Input parameter to function"
"OptionalArg: <param_5> Input parameter to function"
"Example: add_spawn_function_group( "physics_launch_guys", "targetname",&set_ignoreall, true );"
"SPMP: singleplayer"
@/
function add_spawn_function_group( str_value, str_key = "targetname", func_spawn, param_1, param_2, param_3, param_4, param_5 )
{
	Assert( isdefined( str_value ), "str_value is a required parameter for add_spawn_function_group" );
	Assert( isdefined( func_spawn ), "func_spawn is a required parameter for add_spawn_function_group" );
	
	a_spawners = GetSpawnerArray( str_value, str_key );
	array::run_all( a_spawners, &add_spawn_function, func_spawn, param_1, param_2, param_3, param_4, param_5 );
}

/@
"Name: add_spawn_function_ai_group( <str_aigroup>, <func_spawn>, [param_1], [param_2], [param_3], [param_4], [param_5] )"
"Summary: Gets all spawners with specified ai group, then adds spawn function to entire group with up to 5 input arguments."
"Module: Entity"
"CallOn: self unused"
"MandatoryArg: <str_aigroup> ai group to add the spawn function to"
"MandatoryArg: <func_spawn> Spawn function to add to the spawners"
"OptionalArg: <param_1> Input parameter to function"
"OptionalArg: <param_2> Input parameter to function"
"OptionalArg: <param_3> Input parameter to function"
"OptionalArg: <param_4> Input parameter to function"
"OptionalArg: <param_5> Input parameter to function"
"Example: add_spawn_function_ai_group( "physics_launch_guys",&set_ignoreall, true );"
"SPMP: singleplayer"
@/
function add_spawn_function_ai_group( str_aigroup, func_spawn, param_1, param_2, param_3, param_4, param_5 )
{
	assert( isdefined( str_aigroup ), "str_aigroup is a required parameter for add_spawn_function_ai_group" );
	assert( isdefined( func_spawn ), "func_spawn is a required parameter for add_spawn_function_ai_group" );
	
	a_spawners = GetSpawnerArray( str_aigroup, "script_aigroup" );
	array::run_all( a_spawners, &add_spawn_function, func_spawn, param_1, param_2, param_3, param_4, param_5 );
}

/@
"Name: remove_spawn_function_ai_group( <str_aigroup>, <func_spawn> )"
"Summary: Gets all spawners with specified ai group, then removes spawn function to entire group."
"Module: Entity"
"CallOn: self unused"
"MandatoryArg: <str_aigroup> ai group to add the spawn function to"
"MandatoryArg: <func_spawn> Spawn function to add to the spawners"
"Example: remove_spawn_function_ai_group( "physics_launch_guys",&set_ignoreall );"
"SPMP: singleplayer"
@/
function remove_spawn_function_ai_group( str_aigroup, func_spawn, param_1, param_2, param_3, param_4, param_5 )
{
	assert( isdefined( str_aigroup ), "str_aigroup is a required parameter for remove_spawn_function_ai_group" );
	assert( isdefined( func_spawn ), "func_spawn is a required parameter for remove_spawn_function_ai_group" );
	
	a_spawners = GetSpawnerArray( str_aigroup, "script_aigroup" );
	array::run_all( a_spawners, &remove_spawn_function, func_spawn );
}

/@
"Name: simple_flood_spawn( <name>, <spawn_func>, <spawn_func_2>)"
"Module: Spawner"
"Summary: Simple way to floodspawn guys, with targetname 'name'"
"MandatoryArg: <name> : targetname of spawners to spawn"
"OptionalArg: <spawn_func> : function pointer to a spawn function"
"OptionalArg: <spawn_func_2> : function pointer to an additional spawn function"
"Example: spawner::simple_flood_spawn( "defend_guys",&defend_guys_strategy,&defend_guys_retreat_strategy );"
"SPMP: singleplayer"
@/
function simple_flood_spawn( name, spawn_func, spawn_func_2 )
{
	spawners = getEntArray( name, "targetname" );
	assert( spawners.size, "no spawners with targetname " + name + " found!" );

	// add spawn function to each spawner if specified
	if( isdefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}

	if( isdefined( spawn_func_2 ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func_2 );
		}
	}

	for( i = 0; i < spawners.size; i++ )
	{
		if( i % 2 )
		{
			//wait for a new network frame to be sent out before spawning in another guy
			util::wait_network_frame();
		}

		// same behavior in _spawner's spawner::flood_spawner_scripted() function
		spawners[i] thread flood_spawner_init();
		spawners[i] thread flood_spawner_think();
	}
}

/@
"Name: simple_spawn( <name_or_spawners>, <spawn_func>, <param1>, <param2>, <param3>, <param4>, <param5>, <bforce>)"
"Module: Spawner"
"Summary: Simple way to spawn guys, with targetname or by passing in the spawners, just once (no floodspawning). Returns an array of the spawned ai."
"MandatoryArg: <name_or_spawners> : targetname of spawners or the spawners themselves"
"OptionalArg: <spawn_func> : function pointer to a spawn function"
"OptionalArg: <param1> : argument to pass to the spawn function"
"OptionalArg: <param2> : argument to pass to the spawn function"
"OptionalArg: <param3> : argument to pass to the spawn function"
"OptionalArg: <param4> : argument to pass to the spawn function"
"OptionalArg: <param5> : argument to pass to the spawn function"
"OptionalArg: <bForce> : true/false if you want to force the spawn"
"Example: spawner::simple_spawn( "bunker_guys",&bunker_guys_strategy );"
"SPMP: singleplayer"
@/
function simple_spawn( name_or_spawners, spawn_func, param1, param2, param3, param4, param5, bForce )
{
	spawners = [];
	
	if ( IsString( name_or_spawners ) )
	{
		spawners = GetEntArray( name_or_spawners, "targetname" );
		assert( spawners.size, "no spawners with targetname " + name_or_spawners + " found!" );
	}
	else
	{
		if ( !isdefined( name_or_spawners ) ) name_or_spawners = []; else if ( !IsArray( name_or_spawners ) ) name_or_spawners = array( name_or_spawners );;
		spawners = name_or_spawners;
	}

	a_spawned = [];

	foreach ( sp in spawners )
	{
		e_spawned = sp spawner::spawn( bForce );
		
		if ( isdefined( e_spawned ) )
		{
			if ( isdefined( spawn_func ) )
			{
				util::single_thread( e_spawned, spawn_func, param1, param2, param3, param4, param5 );
			}
			
			if ( !isdefined( a_spawned ) ) a_spawned = []; else if ( !IsArray( a_spawned ) ) a_spawned = array( a_spawned ); a_spawned[a_spawned.size]=e_spawned;;
		}
	}

	return a_spawned;
}

/@
"Name: simple_spawn_single( <name_or_spawner>, <spawn_func>, <param1>, <param2>, <param3>, <param4>, <param5>, <bforce>)"
"Module: Spawner"
"Summary: Simple way to spawn just one guy, with targetname or by passing in the spawner, just once. Returns the spawned ai entity."
"MandatoryArg: <name_or_spawner> : targetname of spawner or the spawner"
"OptionalArg: <spawn_func> : function pointer to a spawn function"
"OptionalArg: <param1> : argument to pass to the spawn function"
"OptionalArg: <param2> : argument to pass to the spawn function"
"OptionalArg: <param3> : argument to pass to the spawn function"
"OptionalArg: <param4> : argument to pass to the spawn function"
"OptionalArg: <param5> : argument to pass to the spawn function"
"OptionalArg: <bforce> : true/false to force spawn"
"Example: spawner::simple_spawn_single( "ambush_guy",&ambush_guy_strategy );"
"SPMP: singleplayer"
@/
function simple_spawn_single( name_or_spawner, spawn_func, param1, param2, param3, param4, param5, bforce )
{
	ai = simple_spawn( name_or_spawner, spawn_func, param1, param2, param3, param4, param5, bforce );
	assert( ai.size <= 1, "simple_spawn called from simple_spawn_single somehow spawned more than one guy!" );
	
	if ( ai.size )
	{
		return ai[0];
	}
}


/@
"Name: set_targets(<spawner_target_names>)"
"Summary: Gives an AI new script_spawner_targets node(s) to go to. Overrides previously set script_spawner_targets. Seperate sets by spaces."
"Module: Utility"
"Example: guy spawner::set_targets("balcony1 balcony2");"
"SPMP: SP"
@/
function set_targets(spawner_targets)
{
	self thread spawner::go_to_spawner_target(StrTok(spawner_targets," "));
}

/#
	
// Copied from rank_shared minus the autoexec bloat.
function getScoreInfoXP( type )
{
	if ( isdefined( level.scoreInfo[type] ) )
	{
		n_xp = level.scoreInfo[type]["xp"];
		if ( isdefined( level.xpModifierCallback ) && isdefined( n_xp ) )
		{
			n_xp = [[level.xpModifierCallback]]( type, n_xp );
		}

		return n_xp;
	}
}
	
function autoexec Init_NPCDeathTracking()
{
	// Keeps track of all NPC deaths.
	level.a_NPCDeaths = [];
	
	// Output string to report NPC deaths in a neatly formatted block.
	level.str_KillsOutput = "";
	
	// Script to perform when an NPC dies.
	callback::add_callback( #"on_actor_killed", &Track_NPC_Deaths);
	
	// We'll need this for vehicles, too, because some enemies are technically vehicles.
	callback::add_callback( #"on_vehicle_killed", &Track_Vehicle_Deaths);
	
	// Display damage to enemy actors.
	callback::add_callback( #"on_actor_damage", &show_actor_damage);
	
	// Display damage to vehicle enemies.
	callback::add_callback( #"on_vehicle_damage", &show_vehicle_damage);
	
	// Show XP Popups
	SetDvar("ShowXPForKills", 0);
	
	// Tracking how many of which type of enemy died
	SetDvar("EnableNPCDeathTracking", 0);
	SetDvar("ResetNPCDeathTracking", 0);
	
	level thread ListenForNPCDeaths();
}

function Track_Vehicle_Deaths( params )
{
	// Did the player kill this guy?
	b_killed_by_player = false;
	
	if( isdefined( params ) && IsPlayer( params.eAttacker ) )
	{
		b_killed_by_player = true;
		
		
		// Are we showing FF style XP popups?
		if (GetDvarInt("ShowXPForKills"))
		{
			n_xp_value = getScoreInfoXP("kill" + self.scoretype);
			v_death_position = self.origin;
			n_print_height = 50;
			
			if (isdefined(self.height))
			{
				n_print_height = self.height;
			}
			
			v_death_position += (0,0,n_print_height);
			
			show_xp_popup_for_enemy(n_xp_value, v_death_position);
		}
	}
	
	AddDeadNPCToList(b_killed_by_player);
}

function Track_NPC_Deaths( params )	
{	
	// Did the player kill this guy?
	b_killed_by_player = false;
	
	if (IsPlayer(params.eAttacker))
	{
		b_killed_by_player = true;
		
		// Are we showing FF style XP popups?
		if (GetDvarInt("ShowXPForKills"))
		{
			n_xp_value = getScoreInfoXP("kill" + self.scoretype);
			v_death_position = self.origin;
			n_print_height = 72;
			
			if (isdefined(self.goalheight))
			{
				n_print_height = self.goalheight - 12;
			}
			
			v_death_position += (0,0,n_print_height);
			
			show_xp_popup_for_enemy(n_xp_value, v_death_position);
		}
	}
		
	AddDeadNPCToList(b_killed_by_player);
}


// Show damage events for NPCs.
function show_actor_damage(params)
{
	// Where the damage debug text is displayed.
	v_print_pos = (0,0,0);
	n_damage_value = params.iDamage;
	
	
	// Are we showing NPC health?
	if( GetDvarString( "debug_health" ) == "on" )
	{
		// Try to put this above the guy's head.
		if (isdefined(self gettagorigin( "tag_eye" )))
		{
			v_position = self gettagorigin( "tag_eye" ) + ( 0, 0, 18 );
		}
		else
		{
			// Otherwise, pick an arbitrary height just so we can show something.
			v_position = self getorigin() + ( 0, 0, 78 );
		}
		
		level thread show_number_popup(n_damage_value, v_position, "-", "!", (0.96, 0.12, 0.12), 1, 0.6);
	}
}


// Show damage events for NPCs.
function show_vehicle_damage(params)
{
	// Where the damage debug text is displayed.
	v_print_pos = (0,0,0);
	n_damage_value = params.iDamage;
	
	
	// Are we showing NPC health?
	if( GetDvarString( "debug_health" ) == "on" )
	{
		v_print_pos = self.origin;
		n_print_height = 50;
		
		if (isdefined(self.height))
		{
			n_print_height = self.height;
		}
		
		v_print_pos += (0,0,n_print_height);
		
		level thread show_number_popup(n_damage_value, v_print_pos, "-", "!", (0.96, 0.12, 0.12), 1, 0.6);
	}
}


// Pop up an XP value over an enemy's head final fantasy style
function show_xp_popup_for_enemy(n_xp_value, v_position)
{
	level thread show_number_popup(n_xp_value, v_position, "+", "xp", (0.83, 0.18, 0.76), 1, 0.7);
}


// Pops up a number of an enemy's head.
// The number will float up, then fade away over time.
function show_number_popup(n_value, v_pos, string_prefix, string_suffix, color, n_alpha, n_size)
{
	n_current_tick = 0;
	n_current_alpha = n_alpha;
	v_print_position = v_pos;
	
	while (n_current_tick < 40)
	{
		v_print_position += (0,0, (45/40));
		Print3d(v_print_position, string_prefix + n_value + string_suffix, color, n_current_alpha, n_size, 1);
		
		if (n_current_tick >= 20)
		{
			n_current_alpha -= 1 / (40 - 20);
		}
			
		{wait(.05);};
		n_current_tick++;
	}
}


function AddDeadNPCToList(b_killed_by_player)
{
	if( !isdefined( self ) )
		return;
	// Make sure this guy was actually an enemy.
	if (self.team == "axis")
	{
		/*if (self.attacker)
		{
			IPrintLn("Reset NPC Death Type Counter");
		}*/
		
		// Add this kill to the list of NPC kills by type.
		// First find out if there's an entry for this scoretype.
		bEntryExists = false;
		for (i = 0; i < level.a_NPCDeaths.size; i++)
		{
			// Does this guy's scoretype match an existing scoretype?
			if (level.a_NPCDeaths[i].strScoreType == Self.scoretype)
			{
				level.a_NPCDeaths[i].iCount += 1;
				
				if (b_killed_by_player)
				{
					level.a_NPCDeaths[i].iKilledByPlayerCount += 1;
				}
				
				bEntryExists = true;
			}
		}
		
		// If this guy wasn't in the list of tracked NPC deaths, add him in.
		if (!bEntryExists)
		{
			// Data for a single NPC death.
			s_NPCDeath = SpawnStruct();
			s_NPCDeath.strScoretype = Self.scoretype;
			s_NPCDeath.iCount = 1;
			s_NPCDeath.iKilledByPlayerCount = 0;
			
			if (b_killed_by_player)
			{
				s_NPCDeath.iKilledByPlayerCount = 1;
			}
		
			iTypesOfNPCsKilled = level.a_NPCDeaths.size;
			level.a_NPCDeaths[iTypesOfNPCsKilled] = s_NPCDeath;
		}
	}
}

// Updates the NPC Death By Type Tracker
function ListenForNPCDeaths()
{
	while(1)
	{
		// Are we trying to reset the counter?
		CheckForDeathTrackingReset();
		
		if (GetDvarInt("EnableNPCDeathTracking") == 1)
		{
			// If we don't have the HUD element for this made yet, create it.
			if(!isdefined(level.NPC_Death_Tracking_HUD_Text))
			{
				// Create the HUD element to display all NPC deaths.
				if(!isdefined(level.NPC_Death_Tracking_HUD_Text))
				{
					level.NPC_Death_Tracking_HUD_Text = NewHudElem();
					level.NPC_Death_Tracking_HUD_Text.alignX = "left";
					level.NPC_Death_Tracking_HUD_Text.x = 50;
					level.NPC_Death_Tracking_HUD_Text.y = 60;
					level.NPC_Death_Tracking_HUD_Text.fontScale = 1.5;
					level.NPC_Death_Tracking_HUD_Text.color = (1,1,1);
					//level.spawn_manager_debug_hud_title.font = "bigfixed";
				}
			}
			else
			{
				// Show the number of NPCs killed by type.
				level.s_KillsOutput = "Num Enemies Alive: " + GetAITeamArray("axis").size + "\nNum Allies Alive: " + GetAITeamArray("allies").size + "\n\n";
				level.s_KillsOutput += "Kills by Type:\n";
				
				if (level.a_NPCDeaths.size == 0)
				{
					level.s_KillsOutput = level.s_KillsOutput + "No NPCs Killed";
				}
				else
				{
					// Append the output string for each NPC death by type.
					foreach ( DeadNPCTypeCount in level.a_NPCDeaths )
					{
						level.s_KillsOutput = level.s_KillsOutput + DeadNPCTypeCount.strScoretype + ": " + DeadNPCTypeCount.iCount + " -- (plr): " + DeadNPCTypeCount.iKilledByPlayerCount + "\n";
					}
				}
				
				level.NPC_Death_Tracking_HUD_Text SetText(level.s_KillsOutput);
			}
		}
		else
		{
			// Get rid of the HUD element when we turn off tracking.
			if( isdefined( level.NPC_Death_Tracking_HUD_Text ) )
			{
				level.NPC_Death_Tracking_HUD_Text Destroy();
			}
		}
		
		wait(0.25);
	}
}


// Are we getting a signal to reset the death tracking counter?
function CheckForDeathTrackingReset()
{
	if (GetDvarInt("ResetNPCDeathTracking") == 1)
	{
		// Clear the array. This won't leak memory so I'm told! Crazy!
		level.a_NPCDeaths = [];

		IPrintLn("Reset NPC Death Type Counter");
		
		// Signal received and dealt with. Reset the value so we can signal again.
		SetDvar("ResetNPCDeathTracking", 0);
	}
}
#/
	
function autoexec init_female_spawn()
{
	level.female_mapping_table = [];
	level.female_percent = 0;

	mapname = toLower( GetDvarString( "mapname" ) );
	switch ( mapname )
	{
	case "cp_mi_eth_prologue":
	case "cp_mi_cairo_infection":
	case "cp_mi_cairo_infection2":
	case "cp_mi_cairo_infection3":
	case "cp_mi_cairo_lotus":
	case "cp_mi_cairo_lotus2":
	case "cp_mi_cairo_lotus3":	
	case "cp_mi_cairo_ramses":
	case "cp_mi_cairo_ramses2":
	case "cp_mi_cairo_ramses3":
		set_female_percent( 30 );
		add_to_female_table( "actor_spawner_enemy_54i_human_assault_smg", "actor_spawner_enemy_54i_human_assault_smgf" );
		add_to_female_table( "actor_spawner_enemy_54i_human_assault_ar", "actor_spawner_enemy_54i_human_assault_arf" );
		add_to_female_table( "actor_spawner_enemy_54i_human_cqb_shotgun", "actor_spawner_enemy_54i_human_cqb_shotgunf" );
		add_to_female_table( "actor_spawner_enemy_54i_human_suppressor_ar", "actor_spawner_enemy_54i_human_suppressor_arf" );
		add_to_female_table( "actor_spawner_enemy_54i_human_suppressor_mg", "actor_spawner_enemy_54i_human_suppressor_mgf" );
		add_to_female_table( "actor_spawner_enemy_nrc_human_assault_smg", "actor_spawner_enemy_nrc_human_assault_smgf" );
		add_to_female_table( "actor_spawner_enemy_nrc_human_assault_ar", "actor_spawner_enemy_nrc_human_assault_arf" );
		add_to_female_table( "actor_spawner_enemy_nrc_human_cqb_juicedshotgun", "actor_spawner_enemy_nrc_human_cqb_juicedshotgunf" );
		add_to_female_table( "actor_spawner_enemy_nrc_human_cqb_shotgun", "actor_spawner_enemy_nrc_human_cqb_shotgunf" );
		add_to_female_table( "actor_spawner_enemy_nrc_human_suppressor_ar", "actor_spawner_enemy_nrc_human_suppressor_arf" );
		add_to_female_table( "actor_spawner_enemy_nrc_human_suppressor_mg", "actor_spawner_enemy_nrc_human_suppressor_mgf" );
		break;
		
	}
}

/@
"Name: add_to_female_table(<classname_original>, <classname_female>)"
"Summary: Adds an entry to the mapping table to allow the female classname to override the default"
"Module: Utility"
"Example: spawner::add_to_female_table("actor_spawner_bo3_sniper_enemy_tool", "actor_spawner_enemy_nrc_human_cqb_shotgunf");"
"SPMP: SP"
@/
function add_to_female_table( classname_original, classname_female )
{
	original_spawner = getentarray( classname_original, "classname" );
	if ( !isdefined( original_spawner ) || original_spawner.size == 0 )
	{
		/# println( "Warning: " + classname_original + " doesn't exist in the level!" ); #/
		return;
	}

	spawner = getentarray( classname_female, "classname" );
	if ( !isdefined( spawner ) || spawner.size == 0 )
	{
		/# println( "Warning: " + classname_female + " doesn't exist in the level!" ); #/
		return;
	}

	if ( isdefined( original_spawner ) && original_spawner.size > 0 && isdefined( spawner ) && spawner.size > 0 )
	{
		level.female_mapping_table[ classname_original ] = classname_female;
	}
}

/@
"Name: set_female_percent(<percent>)"
"Summary: Specify the chance that a spawner in the female mapping table will override the default"
"Module: Utility"
"Example: guy spawner::set_female_percent(50);"
"SPMP: SP"
@/
function set_female_percent( percent )
{
	level.female_percent = percent;
}