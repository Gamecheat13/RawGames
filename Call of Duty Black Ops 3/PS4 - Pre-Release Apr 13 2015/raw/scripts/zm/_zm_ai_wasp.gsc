#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_parasite;
#using scripts\shared\clientfield_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_net;
#using scripts\zm\_zm_powerups;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_spawner;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;

#using scripts\shared\ai\zombie_utility;

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   	

#precache( "fx", "zombie/fx_wasp_lightning_buildup_zmb" );
#precache( "fx", "zombie/fx_wasp_eyes_zmb" );
#precache( "fx", "zombie/fx_wasp_explosion_zmb" );
#precache( "fx", "zombie/fx_wasp_fire_trail_zmb" );
#precache( "fx", "zombie/fx_wasp_ash_trail_zmb" );


#namespace zm_ai_wasp;

function init()
{
	level.wasp_enabled = true;
	level.wasp_rounds_enabled = false;
	level.wasp_round_count = 1;

	level.wasp_spawners = [];
	level.enemy_wasp_spawns = [];
	level.enemy_wasp_locations = [];
	//utility::flag_init( "wasp_round" );
	level flag::init( "wasp_clips" );

	if ( GetDvarString( "zombie_wasp_animset" ) == "" )
	{
		SetDvar( "zombie_wasp_animset", "zombie" );
	}

	if ( GetDvarString( "scr_wasp_health_walk_multiplier" ) == "" )
	{
		SetDvar( "scr_wasp_health_walk_multiplier", "0.5" );
	}

	if ( GetDvarString( "scr_wasp_run_distance" ) == "" )
	{
		SetDvar( "scr_wasp_run_distance", "500" );
	}

	level.melee_range_sav  = GetDvarString( "ai_meleeRange" );
	level.melee_width_sav = GetDvarString( "ai_meleeWidth" );
	level.melee_height_sav  = GetDvarString( "ai_meleeHeight" );

	zombie_utility::set_zombie_var( "wasp_fire_trail_percent", 50 );
	
	if ( !IsDefined( level.vsmgr_prio_overlay_zm_wasp_round ) )
	{
		level.vsmgr_prio_overlay_zm_wasp_round = 22;
	}
	
	clientfield::register( "world",		"toggle_on_parasite_fog",	1, 2, "int" );
	visionset_mgr::register_info( "overlay", "zm_wasp_round", 1, level.vsmgr_prio_overlay_zm_wasp_round, 7, false, &visionset_mgr::duration_lerp_thread, false );

	level._effect[ "lightning_wasp_spawn" ]	= "zombie/fx_wasp_lightning_buildup_zmb";
	level._effect[ "wasp_eye_glow" ]			= "zombie/fx_wasp_eyes_zmb";
	level._effect[ "wasp_gib" ]				= "zombie/fx_wasp_explosion_zmb";
	level._effect[ "wasp_trail_fire" ]		= "zombie/fx_raps_fire_trail_zmb";
	level._effect[ "wasp_trail_ash" ]		= "zombie/fx_wasp_ash_trail_zmb";

	// Init wasp targets - mainly for testing purposes.
	//	If you spawn a wasp without having a wasp round, you'll get SREs on hunted_by.
	wasp_spawner_init();

	level thread wasp_clip_monitor();

	//level.zombie_death_event_callbacks
	if(( isdefined( level.zombie_gut_wasps ) && level.zombie_gut_wasps ))
	{
		zm_spawner::register_zombie_death_event_callback( &wasp_random_watcher );
	}
}


//
//	If you want to enable wasp rounds, then call this.
//	Specify an override func if needed.
function enable_wasp_rounds()
{
	level.wasp_rounds_enabled = true;

	if( !isdefined( level.wasp_round_track_override ) )
	{
		level.wasp_round_track_override =&wasp_round_tracker;
	}

	level thread [[level.wasp_round_track_override]]();
}


function wasp_random_watcher()
{
		if(level.round_number <= 3)
		{
			return;
		}
			
		if( level flag::get( "special_round" ) )
		{
			return;
		}
		
		if( !IsActor( self ) || IsVehicle(self))
		{
			return;
		}	
					
		if(RandomInt(100) <= 10)
		{
			//self = dying zombie.
			self thread zombie_utility::zombie_gut_explosion();
			
			loc = spawnstruct();
			loc.origin = self.origin;
			loc.angles = self.angles;
			
			ai = special_wasp_spawn( loc, 1 );

			loc struct::delete();
		}	
}	

function wasp_spawner_init()
{
	level.wasp_spawners = getEntArray( "zombie_wasp_spawner", "script_noteworthy" ); 
	later_wasp = getentarray("later_round_wasp_spawners", "script_noteworthy" );
	level.wasp_spawners = ArrayCombine( level.wasp_spawners, later_wasp, true, false );
	
	if( level.wasp_spawners.size == 0 )
	{
		return;
	}
	
	for( i = 0; i < level.wasp_spawners.size; i++ )
	{
		if ( zm_spawner::is_spawner_targeted_by_blocker( level.wasp_spawners[i] ) )
		{
			level.wasp_spawners[i].is_enabled = false;
		}
		else
		{
			level.wasp_spawners[i].is_enabled = true;
			level.wasp_spawners[i].script_forcespawn = true;
		}
	}

	assert( level.wasp_spawners.size > 0 );
	level.wasp_health = 100;

	//array::thread_all( level.wasp_spawners,&spawner::add_spawn_function,&wasp_init );
	vehicle::add_main_callback( "spawner_bo3_parasite_enemy_tool", &wasp_init );

	//level.enemy_wasp_spawns = getnodearray( "zombie_spawner_wasp_init", "script_noteworthy" ); 
	level.enemy_wasp_spawns = getEntArray( "zombie_spawner_wasp_init", "targetname" );
}

function get_current_wasp_count()
{
	wasps = GetEntArray( "zombie_wasp", "targetname" );
	num_alive_wasps = wasps.size;
	foreach( wasp in wasps )
	{
		if( !IsAlive( wasp ) )
		{
			num_alive_wasps--;
		}
	}
	return num_alive_wasps;
}



function wasp_round_spawning()
{
	level endon( "intermission" );
	
	level.wasp_targets = level.players;
	for( i = 0 ; i < level.wasp_targets.size; i++ )
	{
		level.wasp_targets[i].hunted_by = 0;
	}

	//assert( level.enemy_wasp_spawns.size > 0 );

/#
	level endon( "kill_round" );

	if ( GetDvarInt( "zombie_cheat" ) == 2 || GetDvarInt( "zombie_cheat" ) >= 4 ) 
	{
		return;
	}
#/

	if( level.intermission )
	{
		return;
	}

	level.wasp_intermission = true;
	level thread wasp_round_aftermath();

	array::thread_all( level.players, &play_wasp_round );
	
	wait 1;
	
	level clientfield::set( "toggle_on_parasite_fog", 1 );
	visionset_mgr::activate( "overlay", "zm_wasp_round", undefined, 3, 3 );
	PlaySoundAtPosition( "vox_zmba_event_waspstart_0", ( 0, 0, 0 ) );
	
	wait 6;
	
	const n_players_min	= 1;
	const n_players_max	= 4;
	
	/* every 2 rounds, add some more wasps */
	n_spawn_add = Int( Ceil( level.wasp_round_count / 2 ) );
	
	n_wave_count = 1 + n_spawn_add;
	n_swarm_size = Int( MapFloat( n_players_min, n_players_max, 1 + n_spawn_add, 3 + n_spawn_add, level.players.size ) );
 
	wasp_health_increase();
	
	level.zombie_total = Int( n_wave_count * n_swarm_size * level.players.size );

	for ( n_wave = 0; n_wave < n_wave_count; n_wave++ )
	{
		// wait until we are down to 1 wasps per player before spawning the next wave
		while ( get_current_wasp_count() > zm_utility::get_number_of_valid_players() )
		{
			wait 2;
		}
			
		for ( n_swarm_count = 0; n_swarm_count < level.players.size; n_swarm_count++ )
		{
			b_swarm_spawned = false;
			
			while ( !b_swarm_spawned )
			{
				/* Find the base spawn position for the swarm */
				
				spawn_point = undefined;
				
				while ( !isdefined( spawn_point ) )
				{
					favorite_enemy = get_favorite_enemy();
					
					if ( isdefined( level.wasp_spawn_func ) )
					{
						spawn_point = [[ level.wasp_spawn_func ]]( favorite_enemy );
					}
					else
					{
						// Default method
						spawn_point = wasp_spawn_logic( favorite_enemy );
					}
					
					if ( !isdefined( spawn_point ) )
					{
						wait randomfloatrange(1-1/3,1+1/3);  // try again after wait
					}
				}
				
				/* Query the navvolume for valid spawn points around base spawn point */
				
				v_spawn_origin = spawn_point.origin;
				
				v_ground = (bullettrace(spawn_point.origin + ( 0, 0, 60 ),(spawn_point.origin + ( 0, 0, 60 ) + ( 0, 0, -100000 ) ), 0, undefined )[ "position" ]);
				if ( DistanceSquared( v_ground, spawn_point.origin ) < ( 60 * 60 ) )
				{
					v_spawn_origin = v_ground + ( 0, 0, 60 );
				}
			
				queryResult = PositionQuery_Source_Navigation( v_spawn_origin, 0, 80, 80, 15, "navvolume_small" );
				a_points = array::randomize( queryResult.data );
				
				/* Extra bullettrace to be sure. Save only points that pass test */
				
				a_spawn_origins = [];
			
				foreach ( point in a_points )
				{
					if ( BulletTracePassed( point.origin, spawn_point.origin, false, favorite_enemy ) )
					{
						if ( !isdefined( a_spawn_origins ) ) a_spawn_origins = []; else if ( !IsArray( a_spawn_origins ) ) a_spawn_origins = array( a_spawn_origins ); a_spawn_origins[a_spawn_origins.size]=point.origin;;
					}
				}
				
				/* Spawn the swarm only if we have found enough safe points for the whole swarm */
				
				if ( a_spawn_origins.size >= n_swarm_size )
				{
					n_spawn = 0;
					
					while ( n_spawn < n_swarm_size )
					{
						for ( i = a_spawn_origins.size - 1; i >= 0; i-- )
						{
							v_origin = a_spawn_origins[ i ];
							
							level.wasp_spawners[ 0 ].origin = v_origin;
							
							ai = zombie_utility::spawn_zombie( level.wasp_spawners[ 0 ] );
					
							if ( isdefined( ai ) )
							{
								n_spawn++;
								level.zombie_total--;
								
								ai.favoriteenemy = favorite_enemy;
								
								level thread wasp_spawn_fx( ai, v_origin );
								
								level flag::set( "wasp_clips" );
								
								ArrayRemoveIndex( a_spawn_origins, i );
								
								wait randomfloatrange(.1-.1/3,.1+.1/3); // a little seperation between spawns
								break;
							}
							
							wait randomfloatrange(.1-.1/3,.1+.1/3); // a little wait if spawn failed
						}
					}
					
					b_swarm_spawned = true;
				}
				
				util::wait_network_frame(); // wait network frame between swarms
			}
		}
	}
}

function waiting_for_next_wasp_spawn( count, max )
{
	default_wait = 1.5;

	if( level.wasp_round_count == 1)
	{
		default_wait = 3;
	}
	else if( level.wasp_round_count == 2)
	{
		default_wait = 2.5;
	}
	else if( level.wasp_round_count == 3)
	{
		default_wait = 2;
	}
	else 
	{
		default_wait = 1.5;
	}

	default_wait = default_wait - ( count / max );

	wait( default_wait );
}

function wasp_round_aftermath()
{
	level waittill( "last_wasp_down", e_wasp );

	level thread zm_audio::sndMusicSystem_PlayState( "parasite_over" );

	power_up_origin = level.last_wasp_origin;
	trace = GroundTrace( power_up_origin + (0, 0, 100), power_up_origin + (0, 0, -1000), false, e_wasp );
	power_up_origin = trace["position"];

	if( isdefined( power_up_origin ) )
	{
		level thread zm_powerups::specific_powerup_drop( "full_ammo", power_up_origin );
	}
	
	wait(2);
	level clientfield::set( "toggle_on_parasite_fog", 2 );
	visionset_mgr::deactivate( "overlay", "zm_wasp_round", undefined );
	util::clientNotify( "wasp_stop" );
	
	wait(6);
	level.wasp_intermission = false;

	//level thread wasp_round_aftermath();
}

//
//	In Sumpf, the wasp spawner targets a struct to spawn from.
//	In Factory, there's a single spawner and the struct is passed in as the second argument.
function wasp_spawn_fx( ai, origin )
{
	ai endon( "death" );
	
	ai SetInvisibleToAll();
	
	if ( IsDefined( origin ) )
	{
		v_origin = origin;
	}
	else
	{
		v_origin = self.origin;
	}

//	ai SetFreeCameraLockOnAllowed( false );

	Playfx( level._effect["lightning_dog_spawn"], v_origin );
	playsoundatposition( "zmb_hellhound_prespawn", v_origin );
	wait( 1.5 );
	playsoundatposition( "zmb_hellhound_bolt", v_origin );

	Earthquake( 0.5, 0.75, v_origin, 1000);
	//PlayRumbleOnPosition("explosion_generic", v_origin);
	playsoundatposition( "zmb_hellhound_spawn", v_origin );

	// face the enemy
	angle = VectorToAngles( ai.favoriteenemy.origin - v_origin );
	angles = ( ai.angles[0], angle[1], ai.angles[2] );
		
	//DCS 080714: this should work for an ai vehicle but currently doesn't. Support should be added soon.
	//ai ForceTeleport( v_origin, angles );
	ai.origin = v_origin;
	ai.angles = angles;

	assert( isdefined( ai ), "Ent isn't defined." );
	assert( IsAlive( ai ), "Ent is dead." );
	//assert( ai.iswasp, "Ent isn't a wasp;" );
	//assert( zm_utility::is_magic_bullet_shield_enabled( ai ), "Ent doesn't have a magic bullet shield." );

	ai thread zombie_setup_attack_properties_wasp();
	///ai util::stop_magic_bullet_shield();

	//wait( 0.1 ); // wasp should come out running after this wait
	ai SetVisibleToAll();
//	ai SetFreeCameraLockOnAllowed( true );
	ai.ignoreme = false; // don't let attack wasp give chase until the wolf is visible
	ai notify( "visible" );
}

//
//	Dog spawning logic for Factory.  
//	Makes use of the _zm_zone_manager and specially named structs for each zone to
//	indicate wasp spawn locations instead of constantly using ents.
//	

function create_global_wasp_spawn_locations_list()
{
	if( !isdefined(level.enemy_wasp_global_locations) )
	{
		level.enemy_wasp_global_locations = [];	
		keys = GetArrayKeys( level.zones );
		for( i=0; i<keys.size; i++ )
		{
			zone = level.zones[keys[i]];
	
			// add wasp_spawn locations
			for(x=0; x<zone.wasp_locations.size; x++)
			{
				level.enemy_wasp_global_locations[ level.enemy_wasp_global_locations.size ] = zone.wasp_locations[x];
			}
		}
	}
}
	
function wasp_find_closest_in_global_pool( favorite_enemy )
{
	index_to_use = 0;
	closest_distance_squared = DistanceSquared( level.enemy_wasp_global_locations[index_to_use].origin, favorite_enemy.origin );
	for( i = 0; i < level.enemy_wasp_global_locations.size; i++ )
	{
		if( level.enemy_wasp_global_locations[i].is_enabled )
		{
			dist_squared = DistanceSquared( level.enemy_wasp_global_locations[i].origin, favorite_enemy.origin );
			if( dist_squared<closest_distance_squared )
			{
				index_to_use = i;
				closest_distance_squared = dist_squared;
			}
		}
	}
	return level.enemy_wasp_global_locations[index_to_use];
}



	
function wasp_spawn_logic( favorite_enemy )
{
	if ( !GetDvarInt( "zm_wasp_open_spawning", 0 ) )
	{
		wasp_locs = level.enemy_wasp_locations;
		
		if ( wasp_locs.size == 0 )
		{
			//none - use backup global pool - just find first within range
			create_global_wasp_spawn_locations_list();
			return wasp_find_closest_in_global_pool( favorite_enemy );
		}
		
		// if the old one is in the desired range, return it so we get bigger swarms
		if ( isdefined( level.old_wasp_spawn ) )
		{
			dist_squared = DistanceSquared( level.old_wasp_spawn.origin, favorite_enemy.origin );
			if ( dist_squared > ( 400 * 400 ) && dist_squared < ( 600 * 600 ) )
			{
				return level.old_wasp_spawn;
			}
		}
	
		// Find a spawn point that's in the min/max range and use that
		foreach ( loc in wasp_locs )
		{
			dist_squared = DistanceSquared( loc.origin, favorite_enemy.origin );
			if ( dist_squared > ( 400 * 400 ) && dist_squared < ( 600 * 600 ) )
			{
				level.old_wasp_spawn = loc;
				return loc;
			}
		}
	}
	
	/* If we still haven't found a valid spot or we are using open spawing, find something suitable using the navvolume */
	
	const spawn_height_min	= 40;
	const spawn_height_max	= 100;
	const spawn_dist_min	= 100;
	const spawn_dist_max	= 1200;
	
	queryResult = PositionQuery_Source_Navigation(
		favorite_enemy.origin + ( 0, 0, RandomIntRange( spawn_height_min, spawn_height_max ) ),
		spawn_dist_min,
		spawn_dist_max,
		10,
		10,
		"navvolume_small"
	);
	
	a_points = array::randomize( queryResult.data );
	
	foreach ( point in a_points )
	{
		if ( BulletTracePassed( point.origin, favorite_enemy.origin, false, favorite_enemy ) )
		{
			level.old_wasp_spawn = point;
			return point;
		}
	}
}

function get_favorite_enemy()
{
	wasp_targets = level.players;
	least_hunted = wasp_targets[ 0 ];
	
	foreach ( target in wasp_targets )
	{
		if(!isdefined(target.hunted_by))target.hunted_by=0;
		
		if ( IsPlayer( target ) && !zm_utility::is_player_valid( target ) )
		{
			continue;
		}
		
		if ( target.hunted_by < least_hunted.hunted_by )
		{
			least_hunted = target;
		}
	}
	
	least_hunted.hunted_by += 1;

	return least_hunted;	
}


function wasp_health_increase()
{
	players = getplayers();

	if( level.wasp_round_count == 1 )
	{
		level.wasp_health = 400;
	}
	else if( level.wasp_round_count == 2 )
	{
		level.wasp_health = 900;
	}
	else if( level.wasp_round_count == 3 )
	{
		level.wasp_health = 1300;
	}
	else if( level.wasp_round_count == 4 )
	{
		level.wasp_health = 1600;
	}

	if( level.wasp_health > 1600 )
	{
		level.wasp_health = 1600;
	}
}

function wasp_round_wait_func()
{
	if( level flag::get("wasp_round" ) )
	{
		wait(7);
		
		while( level.wasp_intermission )
		{
			wait(0.5);
		}	
		//increment_dog_round_stat("finished");	
	}
	
	level.sndMusicSpecialRound = false;
}

function wasp_round_tracker()
{	
	level.wasp_round_count = 1;
	
	// PI_CHANGE_BEGIN - JMA - making wasp rounds random between round 5 thru 7
	// NOTE:  RandomIntRange returns a random integer r, where min <= r < max
		
	level.next_wasp_round = level.round_number + randomintrange( 4, 7 );	
	// PI_CHANGE_END
	
	old_spawn_func = level.round_spawn_func;
	old_wait_func  = level.round_wait_func;

	while ( 1 )
	{
		level waittill ( "between_round_over" );

		/#
			if( GetDvarInt( "force_wasp" ) > 0 )
			{
				level.next_wasp_round = level.round_number; 
			}
		#/

		if ( level.round_number == level.next_wasp_round )
		{
			level.sndMusicSpecialRound = true;
			old_spawn_func = level.round_spawn_func;
			old_wait_func  = level.round_wait_func;
			wasp_round_start();
			level.round_spawn_func =&wasp_round_spawning;
			level.round_wait_func = &wasp_round_wait_func;

			//Raps are next
			level.next_raps_round = level.round_number + randomintrange( 4, 6 );
			/#
				GetPlayers()[0] iprintln( "Next wasp round: " + level.next_wasp_round );
			#/
		}
		else if ( level flag::get( "wasp_round" ) )
		{
			wasp_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func  = old_wait_func;
            level.music_round_override = false;
			level.wasp_round_count += 1;
		}
	}	
}


function wasp_round_start()
{
	level flag::set( "wasp_round" );
	level flag::set( "special_round" );
	level flag::set( "wasp_clips" );
	
	if(!isdefined (level.waspround_nomusic))
	{
		level.waspround_nomusic = 0;
	}
	level.waspround_nomusic = 1;
	level notify( "wasp_round_starting" );
	level thread zm_audio::sndMusicSystem_PlayState( "parasite_start" );
	util::clientNotify( "wasp_start" );

	if(isdefined(level.wasp_melee_range))
	{
	 	SetDvar( "ai_meleeRange", level.wasp_melee_range ); 
	}
	else
	{
	 	SetDvar( "ai_meleeRange", 100 ); 
	}
}


function wasp_round_stop()
{
	level flag::clear( "wasp_round" );
	level flag::clear( "special_round" );
	level flag::clear( "wasp_clips" );
	
	if(!isdefined (level.waspround_nomusic))
	{
		level.waspround_nomusic = 0;
	}
	level.waspround_nomusic = 0;
	level notify( "wasp_round_ending" );
	util::clientNotify( "wasp_stop" );

 	SetDvar( "ai_meleeRange", level.melee_range_sav ); 
 	SetDvar( "ai_meleeWidth", level.melee_width_sav );
 	SetDvar( "ai_meleeHeight", level.melee_height_sav );
}


function play_wasp_round()
{
	self playlocalsound( "zmb_wasp_round_start" );
	variation_count =5;
	
	wait(4.5);

	players = getplayers();
	num = randomintrange(0,players.size);
	players[num] zm_audio::create_and_play_dialog( "general", "wasp_spawn" );
}



function wasp_init()
{
	self.targetname = "zombie_wasp";
	self.script_noteworthy = undefined;
	self.animname = "zombie_wasp"; 		
	self.ignoreall = true; 
	self.ignoreme = true; // don't let attack wasp give chase until the wolf is visible
	self.allowdeath = true; 			// allows death during animscripted calls
	self.allowpain = false;
	self.no_gib = true; //gibbing disabled for now
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	// out both legs and then the only allowed stance should be prone.
	self.gibbed = false; 
	self.head_gibbed = false;
	self.default_goalheight = 40;
	self.ignore_inert = true;	
	self.no_eye_glow = true;

	//	self.disableArrivals = true; 
	//	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;

	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;

	self.badplaceawareness = 0;
	self.chatInitialized = false;
	self.missingLegs = false;
	
	self SetGrapplableType( 2 );

	self.team = level.zombie_team;
	
	parasite::parasite_initialize();
/*
	self AllowPitchAngle( 1 );
	self setPitchOrient();
	self setAvoidanceMask( "avoid none" );

	self PushActors( true );
*/
	health_multiplier = 1.0;
	if ( GetDvarString( "scr_wasp_health_walk_multiplier" ) != "" )
	{
		health_multiplier = GetDvarFloat( "scr_wasp_health_walk_multiplier" );
	}

	self.maxhealth = int( level.wasp_health * health_multiplier );
	self.health = int( level.wasp_health * health_multiplier );
/*
	self.freezegun_damage = 0;
	
	self.zombie_move_speed = "sprint";
*/
	self thread wasp_run_think();
//	self thread wasp_stalk_audio();

	self SetInvisibleToAll();
//	self thread util::magic_bullet_shield();
//	self wasp_fx_eye_glow();
//	self wasp_fx_trail();

	self thread wasp_death();
	self thread wasp_timeout_after_xsec( 60.0 );
	
	
	level thread zm_spawner::zombie_death_event( self ); 
	self thread zm_spawner::enemy_death_detection();
	
/*
	self.a.disablePain = true;
	self zm_utility::disable_react(); // SUMEET - zombies dont use react feature.
	self ClearGoalVolume();

	self.flame_damage_time = 0;
	self.meleeDamage = 40;

	self.thundergun_knockdown_func =&wasp_thundergun_knockdown;
*/
	self zm_spawner::zombie_history( "zombie_wasp_spawn_init -> Spawned = " + self.origin );
	
	if ( isdefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}
}


function wasp_fx_eye_glow()
{
	self.fx_wasp_eye = spawn( "script_model", self GetTagOrigin( "J_EyeBall_LE" ) );
	assert( isdefined( self.fx_wasp_eye ) );

	self.fx_wasp_eye.angles = self GetTagAngles( "J_EyeBall_LE" );
	self.fx_wasp_eye SetModel( "tag_origin" );
	self.fx_wasp_eye LinkTo( self, "j_eyeball_le" );
}


function wasp_fx_trail()
{
	if( !util::is_mature() || randomint( 100 ) > level.zombie_vars["wasp_fire_trail_percent"] )
	{
		self.fx_wasp_trail_type = level._effect[ "wasp_trail_ash" ];
		self.fx_wasp_trail_sound = "zmb_hellhound_loop_breath";
	}
	else
	{
		//fire wasp will explode during death	
		self.a.nodeath = true;

		self.fx_wasp_trail_type = level._effect[ "wasp_trail_fire" ];
		self.fx_wasp_trail_sound = "zmb_hellhound_loop_fire";
	}

	self.fx_wasp_trail = spawn( "script_model", self GetTagOrigin( "tag_origin" ) );
	assert( isdefined( self.fx_wasp_trail ) );

	self.fx_wasp_trail.angles = self GetTagAngles( "tag_origin" );
	self.fx_wasp_trail SetModel( "tag_origin" );
	self.fx_wasp_trail LinkTo( self, "tag_origin" );
}

function wasp_timeout_after_xsec( timeout )
{
	self endon( "death" );
	wait( timeout );
	self DoDamage( self.health + 100, self.origin );
}

function wasp_death()
{
	self waittill( "death", attacker );

	if ( get_current_wasp_count() == 0 && level.zombie_total == 0 )
	{
		level.last_wasp_origin = self.origin;
		level notify( "last_wasp_down", self );
	}

	// score
	if( IsPlayer( attacker ) )
	{
		event = "death";
		self.damagelocation = "head";
		self.damagemod = "MOD_UNKNOWN";
		attacker zm_score::player_add_points( event, self.damagemod, self.damagelocation, true );
	    
	    if( RandomIntRange(0,100) >= 80 )
	    {
	        attacker zm_audio::create_and_play_dialog( "kill", "hellhound" );
	    }
	    
	    //stats
		attacker zm_stats::increment_client_stat( "zwasp_killed" );
		attacker zm_stats::increment_player_stat( "zwasp_killed" );

	}

	// switch to inflictor when SP DoDamage supports it
	if( isdefined( attacker ) && isai( attacker ) )
	{
		attacker notify( "killed", self );
	}

	// sound
	self stoploopsound();

	// fx
	/*assert( isdefined( self.fx_wasp_eye ) );
	self.fx_wasp_eye delete();

	assert( isdefined( self.fx_wasp_trail ) );
	self.fx_wasp_trail delete();
*/
	//if ( isdefined( self.a.nodeath ) )
	//{
		//level thread wasp_explode_fx( self.origin );
	//}
	//else
	//{
	//    self PlaySound( "zmb_hellhound_vocals_death" );
	//}
}


function wasp_explode_fx( origin )
{
	PlayFX( level._effect["wasp_gib"], origin );
	PlaySoundAtPosition( "zmb_hellhound_explode", origin );
}


// this is where zombies go into attack mode, and need different attributes set up
function zombie_setup_attack_properties_wasp()
{
	self zm_spawner::zombie_history( "zombie_setup_attack_properties()" );
	
	self thread wasp_behind_audio();

	// allows zombie to attack again
	self.ignoreall = false; 

	//self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;

	// turn off transition anims
	self.disableArrivals = true; 
	self.disableExits = true; 

}


//COLLIN'S Audio Scripts
function stop_wasp_sound_on_death()
{
	self waittill("death");
	self stopsounds();
}

function wasp_behind_audio()
{
	self thread stop_wasp_sound_on_death();

	self endon("death");
	self util::waittill_any( "wasp_running", "wasp_combat" );
	
	self PlaySound( "zmb_hellhound_vocals_close" );
	wait( 3 );

	while(1)
	{
		players = GetPlayers();
		for(i=0;i<players.size;i++)
		{
			waspAngle = AngleClamp180( vectorToAngles( self.origin - players[i].origin )[1] - players[i].angles[1] );
		
			if(isAlive(players[i]) && !isdefined(players[i].revivetrigger))
			{
				if ((abs(waspAngle) > 90) && distance2d(self.origin,players[i].origin) > 100)
				{
					self playsound( "zmb_hellhound_vocals_close" );
					wait( 3 );
				}
			}
		}
		
		wait(.75);
	}
}


//
//	Keeps wasp_clips up if there is a wasp running around in the level.
function wasp_clip_monitor()
{
	clips_on = false;
	level.wasp_clips = GetEntArray( "wasp_clips", "targetname" );
	while (1)
	{
		for ( i=0; i<level.wasp_clips.size; i++ )
		{
	//		level.wasp_clips[i] TriggerEnable( false );
			level.wasp_clips[i] ConnectPaths();
		}

		level flag::wait_till( "wasp_clips" );
		
		if(isdefined(level.no_wasp_clip) && level.no_wasp_clip == true)
		{
			return;
		}
		
		for ( i=0; i<level.wasp_clips.size; i++ )
		{
	//		level.wasp_clips[i] TriggerEnable( true );
			level.wasp_clips[i] DisconnectPaths();
			util::wait_network_frame();
		}

		wasp_is_alive = true;
		while ( wasp_is_alive || level flag::get( "wasp_round" ) )
		{
			wasp_is_alive = false;
			wasp = GetEntArray( "zombie_wasp", "targetname" );
			for ( i=0; i<wasp.size; i++ )
			{
				if ( IsAlive(wasp[i]) )
				{
					wasp_is_alive = true;
				}
			}
			wait( 1 );
		}

		level flag::clear( "wasp_clips" );
		wait(1);
	}
}

//
//	Allows wasp to be spawned independent of the round spawning
/@
"Name: special_wasp_spawn(<location>, <num_to_spawn>, <radius> , <half-height> )"
"Summary: Allows wasp to be spawned independent of the round spawning."
"Module: zm_ai_wasp"
"MandatoryArg: <location> - position where parasite will be spawned"	
"OptionalArg: <num_to_spawn> - Number to spawn, if left undefined, 1 will spawn."
"OptionalArg: <radius> - Radius horizontally that the parasite can spawn in from the spawn location.  Defaults to 32 units"
"OptionalArg: <half_height> - Vertical offset that the parasite can spawn in from the spawn location. Defaults to 32 units"
"Example: self zm_ai_wasp::special_wasp_spawn( s_temp, 1 );"
"SPMP: Zombie"
@/
function special_wasp_spawn( location, num_to_spawn, radius = 32, half_height = 32 )
{
	wasp = GetEntArray( "zombie_wasp", "targetname" );

	if ( isdefined( wasp ) && wasp.size >= 9 )
	{
		return false;
	}
	
	if ( !isdefined(num_to_spawn) )
	{
		num_to_spawn = 1;
	}

	spawn_point = undefined;
	count = 0;
	while ( count < num_to_spawn )
	{
		//update the player array.
		players = GetPlayers();
		favorite_enemy = get_favorite_enemy();

		if ( isdefined( level.wasp_spawn_func ) )
		{
			spawn_point = [[level.wasp_spawn_func]]( favorite_enemy );
		}
		else
		{
			if(IsDefined(location))
			{
				spawn_point = location;
			}
			else
			{
				spawn_point = wasp_spawn_logic( favorite_enemy );
			}
		}

		ai = zombie_utility::spawn_zombie( level.wasp_spawners[0] );
		
		v_spawn_origin = spawn_point.origin;
			
		if ( isdefined( ai ) )
		{
			// just try to path strait to a nearby position on the path
			queryResult = PositionQuery_Source_Navigation( v_spawn_origin, 0, radius, half_height, 15, "navvolume_small" );
			if( queryResult.data.size )
			{
				point = queryResult.data[ randomint( queryResult.data.size ) ];	
				v_spawn_origin = point.origin;
			}
			
			ai.favoriteenemy = favorite_enemy;
			level thread wasp_spawn_fx( ai, v_spawn_origin );
			count++;
			level flag::set( "wasp_clips" );
		}

		waiting_for_next_wasp_spawn( count, num_to_spawn );
	}

	return true;
}

function wasp_run_think()
{
	self endon( "death" );

	// these should go back in when the stalking stuff is put back in, the visible check will do for now
	//self util::waittill_any( "wasp_running", "wasp_combat" );
	//self playsound( "zwasp_close" );
	self waittill( "visible" );
	
	// decrease health
	if ( self.health > level.wasp_health )
	{
		self.maxhealth = level.wasp_health;
		self.health = level.wasp_health;
	}
	
	// start glowing eyes
//	assert( isdefined( self.fx_wasp_eye ) );
//	zm_net::network_safe_play_fx_on_tag( "wasp_fx", 2, level._effect["wasp_eye_glow"], self.fx_wasp_eye, "tag_origin" );

	// start trail
	//assert( isdefined( self.fx_wasp_trail ) );
	//zm_net::network_safe_play_fx_on_tag( "wasp_fx", 2, self.fx_wasp_trail_type, self.fx_wasp_trail, "tag_origin" );
	//self playloopsound( self.fx_wasp_trail_sound );

	//Check to see if the enemy is not valid anymore
	while( 1 )
	{
		if( !zm_utility::is_player_valid(self.favoriteenemy) )
		{
			//We are targetting an invalid player - select another one
			//self.favoriteenemy = get_favorite_enemy();
		}
		wait( 0.2 );
	}
}

function wasp_stalk_audio()
{
	self endon( "death" );
	self endon( "wasp_running" );
	self endon( "wasp_combat" );
	
	while(1)
	{
		self playsound( "zmb_hellhound_vocals_amb" );
		wait randomfloatrange(3,6);		
	}
}

function wasp_thundergun_knockdown( player, gib )
{
	self endon( "death" );

	damage = int( self.maxhealth * 0.5 );
	self DoDamage( damage, player.origin, player );
}
