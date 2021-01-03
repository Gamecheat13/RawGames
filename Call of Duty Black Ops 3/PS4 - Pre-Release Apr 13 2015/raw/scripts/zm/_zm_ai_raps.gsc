#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_raps;
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

                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
   	

#precache( "fx", "zombie/fx_meatball_trail_sky_zod_zmb" );
#precache( "fx", "zombie/fx_meatball_impact_ground_tell_zod_zmb" );
#precache( "fx", "zombie/fx_meatball_portal_sky_zod_zmb" );
//#precache( "fx", "zombie/fx_raps_eyes_zmb" );
#precache( "fx", "zombie/fx_meatball_impact_ground_zod_zmb" );
#precache( "fx", "zombie/fx_meatball_trail_ground_zod_zmb" );
#precache( "fx", "zombie/fx_meatball_explo_zod_zmb" );

#namespace zm_ai_raps;

function init()
{
	level.raps_enabled = true;
	level.raps_rounds_enabled = false;
	level.raps_round_count = 1;

	level.raps_spawners = [];
	level.enemy_raps_spawns = [];
	level.enemy_raps_locations = [];
	//utility::flag_init( "raps_round" );
	level flag::init( "raps_clips" );

	if ( GetDvarString( "zombie_raps_animset" ) == "" )
	{
		SetDvar( "zombie_raps_animset", "zombie" );
	}

	if ( GetDvarString( "scr_raps_health_walk_multiplier" ) == "" )
	{
		SetDvar( "scr_raps_health_walk_multiplier", "4.0" );
	}

	if ( GetDvarString( "scr_raps_run_distance" ) == "" )
	{
		SetDvar( "scr_raps_run_distance", "500" );
	}

	level.melee_range_sav  = GetDvarString( "ai_meleeRange" );
	level.melee_width_sav = GetDvarString( "ai_meleeWidth" );
	level.melee_height_sav  = GetDvarString( "ai_meleeHeight" );

	zombie_utility::set_zombie_var( "raps_fire_trail_percent", 50 );

	level._effect[ "raps_meteor_fire" ]		= "zombie/fx_meatball_trail_sky_zod_zmb";
	level._effect[ "raps_ground_spawn" ]	= "zombie/fx_meatball_impact_ground_tell_zod_zmb";
	level._effect[ "raps_portal" ]			= "zombie/fx_meatball_portal_sky_zod_zmb";
//	level._effect[ "raps_eye_glow" ]		= "zombie/fx_raps_eyes_zmb";
	level._effect[ "raps_gib" ]				= "zombie/fx_meatball_explo_zod_zmb";
	level._effect[ "raps_trail_blood" ]		= "zombie/fx_meatball_trail_ground_zod_zmb";
	level._effect[ "raps_impact" ]			= "zombie/fx_meatball_impact_ground_zod_zmb";
	
	if ( !IsDefined( level.vsmgr_prio_overlay_zm_raps_round ) )
	{
		level.vsmgr_prio_overlay_zm_raps_round = 21;
	}

	
	visionset_mgr::register_info( "overlay", "zm_raps_round", 1, level.vsmgr_prio_overlay_zm_raps_round, 7, false, &visionset_mgr::duration_lerp_thread, false );

	// Init raps targets - mainly for testing purposes.
	//	If you spawn a raps without having a raps round, you'll get SREs on hunted_by.
	raps_spawner_init();

	level thread raps_clip_monitor();
}


//
//	If you want to enable raps rounds, then call this.
//	Specify an override func if needed.
function enable_raps_rounds()
{
	level.raps_rounds_enabled = true;

	if( !isdefined( level.raps_round_track_override ) )
	{
		level.raps_round_track_override =&raps_round_tracker;
	}

	level thread [[level.raps_round_track_override]]();
}


function raps_spawner_init()
{
	level.raps_spawners = getEntArray( "zombie_raps_spawner", "script_noteworthy" ); 
	later_raps = getentarray("later_round_raps_spawners", "script_noteworthy" );
	level.raps_spawners = ArrayCombine( level.raps_spawners, later_raps, true, false );
	
	if( level.raps_spawners.size == 0 )
	{
		return;
	}
	
	for( i = 0; i < level.raps_spawners.size; i++ )
	{
		if ( zm_spawner::is_spawner_targeted_by_blocker( level.raps_spawners[i] ) )
		{
			level.raps_spawners[i].is_enabled = false;
		}
		else
		{
			level.raps_spawners[i].is_enabled = true;
			level.raps_spawners[i].script_forcespawn = true;
		}
	}

	assert( level.raps_spawners.size > 0 );
	level.raps_health = 100;

	//array::thread_all( level.raps_spawners,&spawner::add_spawn_function,&raps_init );
	
	vehicle::add_main_callback( "spawner_enemy_zombie_vehicle_raps_suicide", &raps_init );
	
	//level.enemy_raps_spawns = getnodearray( "zombie_spawner_raps_init", "script_noteworthy" ); 
	level.enemy_raps_spawns = getEntArray( "zombie_spawner_raps_init", "targetname" );
}

function get_current_raps_count()
{
	raps = GetEntArray( "zombie_raps", "targetname" );
	num_alive_raps = raps.size;
	foreach( rapsAI in raps )
	{
		if( !IsAlive( rapsAI ) )
		{
			num_alive_raps--;
		}
	}
	return num_alive_raps;
}

function raps_round_spawning()
{
	level endon( "intermission" );
	
	level.raps_targets = getplayers();
	for( i = 0 ; i < level.raps_targets.size; i++ )
	{
		level.raps_targets[i].hunted_by = 0;
	}


	//assert( level.enemy_raps_spawns.size > 0 );

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

	level.raps_intermission = true;
	level thread raps_round_aftermath();
	players = GetPlayers();
	array::thread_all( players,&play_raps_round );	
	wait(1);
	PlaySoundAtPosition( "vox_zmba_event_rapsstart_0", ( 0, 0, 0 ) );
	
	visionset_mgr::activate( "overlay", "zm_raps_round", undefined, 3, 3 );
	
	wait(6);
	
	if( level.raps_round_count < 3 )
	{
		max = players.size * 6;
	}
	else
	{
		max = players.size * 8;
	}
	

 /#
 	if( GetDvarString( "force_raps" ) != "" )
 	{
 		max = GetDvarInt( "force_raps" );
 	}
 #/		

	level.zombie_total = max;
	raps_health_increase();



	count = 0; 
	while( count < max )
	{
		num_player_valid = zm_utility::get_number_of_valid_players();
	
		while( get_current_raps_count() >= num_player_valid * 2 )
		{
			wait( 2 );
			num_player_valid = zm_utility::get_number_of_valid_players();
		}
		
		//update the player array.
		players = GetPlayers();
		favorite_enemy = get_favorite_enemy();

		if ( isdefined( level.raps_spawn_func ) )
		{
			spawn_point = [[level.raps_spawn_func]]( favorite_enemy );
		}
		else
		{
			// Default method
			spawn_point = raps_spawn_logic( favorite_enemy );
		}

		ai = zombie_utility::spawn_zombie( level.raps_spawners[0] );
		if( isdefined( ai ) ) 	
		{
			ai.favoriteenemy = favorite_enemy;
			spawn_point thread raps_spawn_fx( ai, spawn_point );
			level.zombie_total--;
			count++;
		}
		
		waiting_for_next_raps_spawn( count, max );
	}
}

function waiting_for_next_raps_spawn( count, max )
{
	default_wait = 1.5;

	if( level.raps_round_count == 1)
	{
		default_wait = 3;
	}
	else if( level.raps_round_count == 2)
	{
		default_wait = 2.5;
	}
	else if( level.raps_round_count == 3)
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


function raps_round_aftermath()
{

	level waittill( "last_raps_down" );
	
	level thread zm_audio::sndMusicSystem_PlayState( "meatball_over" );
	
	power_up_origin = level.last_raps_origin;
	trace = GroundTrace(power_up_origin + (0, 0, 100), power_up_origin + (0, 0, -1000), false, undefined);
	power_up_origin = trace["position"];

	if( isdefined( power_up_origin ) )
	{
		level thread zm_powerups::specific_powerup_drop( "full_ammo", power_up_origin );
	}
	
	wait(2);
	util::clientNotify( "raps_stop" );
	visionset_mgr::deactivate( "overlay", "zm_raps_round", undefined );
	wait(6);
	level.raps_intermission = false;

	//level thread raps_round_aftermath();

}

//	there's a single spawner and the struct is passed in as the second argument.
function raps_spawn_fx( ai, ent )
{
	ai endon( "death" );
	
	if ( !IsDefined(ent) )
	{
		ent = self;
	}
	
	//find the nearest spot on the ground below the struct, since wasps and raps use the same structs and they are floating
	trace = bullettrace( ent.origin, ent.origin + (0,0,-720), false, ai );
	raps_impact_location = trace[ "position" ];
	
	// face the enemy
	angle = VectorToAngles( ai.favoriteenemy.origin - ent.origin );
	angles = ( ai.angles[0], angle[1], ai.angles[2] );


	//look for ceiling height
	pos = raps_impact_location + (0 , 0, 720 );
	if ( !bullettracepassed( ent.origin, pos, false, ai) )
	{
		trace = bullettrace( ent.origin, pos, false, ai );
		pos = trace["position"];
		portal_fx_location = spawn( "script_model" , pos );
		portal_fx_location SetModel( "tag_origin" );
		playfxontag( level._effect["raps_portal"], portal_fx_location, "tag_origin" );
	}
	
	ground_tell_location = spawn( "script_model" , raps_impact_location );
	ground_tell_location SetModel( "tag_origin" );
	playfxontag( level._effect["raps_ground_spawn"], ground_tell_location, "tag_origin" );	
	
	Wait 1.5;

	raps_meteor = spawn( "script_model", pos);
	model = ai.model;
	raps_meteor SetModel( model );
	raps_meteor.angles = angles;
	

	playfxontag( level._effect[ "raps_meteor_fire" ], raps_meteor, "tag_origin" );
	
	fall_dist = sqrt( DistanceSquared( pos, raps_impact_location ));
	fall_time = fall_dist / 480;  //keeps velocity constant, even for short fall distances, such as inside

	raps_meteor MoveTo(raps_impact_location, fall_time);
	wait(fall_time);
	raps_meteor delete();
	
	if( isDefined (portal_fx_location ))
	{
		portal_fx_location delete();
	}
	
	ground_tell_location delete();


	//DCS 080714: this should work for an ai vehicle but currently doesn't. Support should be added soon.
	//ai ForceTeleport( ent.origin, angles );
	ai.origin = raps_impact_location;
	ai.angles = angles;
	Playfx( level._effect[ "raps_impact" ], raps_impact_location );
	
	Earthquake( 0.5, 0.75, raps_impact_location, 1000);

	assert( isdefined( ai ), "Ent isn't defined." );
	assert( IsAlive( ai ), "Ent is dead." );

	ai zombie_setup_attack_properties_raps();

	//wait( 0.1 ); 
	ai SetVisibleToAll();
	ai.ignoreme = false; // don't let attack raps give chase until the wolf is visible
	ai notify( "visible" );
}


function create_global_raps_spawn_locations_list()
{
	if( !isdefined(level.enemy_raps_global_locations) )
	{
		level.enemy_raps_global_locations = [];	
		keys = GetArrayKeys( level.zones );
		for( i=0; i<keys.size; i++ )
		{
			zone = level.zones[keys[i]];
	
			// add raps_spawn locations
			for(x=0; x<zone.raps_locations.size; x++)
			{
				level.enemy_raps_global_locations[ level.enemy_raps_global_locations.size ] = zone.raps_locations[x];
			}
		}
	}
}
	
function raps_find_closest_in_global_pool( favorite_enemy )
{
	index_to_use = 0;
	closest_distance_squared = DistanceSquared( level.enemy_raps_global_locations[index_to_use].origin, favorite_enemy.origin );
	for( i = 0; i < level.enemy_raps_global_locations.size; i++ )
	{
		if( level.enemy_raps_global_locations[i].is_enabled )
		{
			dist_squared = DistanceSquared( level.enemy_raps_global_locations[i].origin, favorite_enemy.origin );
			if( dist_squared<closest_distance_squared )
			{
				index_to_use = i;
				closest_distance_squared = dist_squared;
			}
		}
	}
	return level.enemy_raps_global_locations[index_to_use];
}


//
//	Makes use of the _zm_zone_manager and specially named structs for each zone to
//	indicate raps spawn locations instead of constantly using ents.
//	
function raps_spawn_logic( favorite_enemy )
{
	raps_locs = array::randomize( level.enemy_raps_locations );
	//assert( raps_locs.size > 0, "Dog Spawner locs array is empty." );
	
	if( raps_locs.size == 0 )
	{
		//none - use backup global pool - just find first within range
		create_global_raps_spawn_locations_list();
		return raps_find_closest_in_global_pool( favorite_enemy );
	}

	for( i = 0; i < raps_locs.size; i++ )
	{
		if( isdefined( level.old_raps_spawn ) && level.old_raps_spawn == raps_locs[i] )
		{
			continue;
		}

		dist_squared = DistanceSquared( raps_locs[i].origin, favorite_enemy.origin );
		if(  dist_squared > ( 400 * 400 ) && dist_squared < ( 1000 * 1000 ) )
		{
			level.old_raps_spawn = raps_locs[i];
			return raps_locs[i];
		}	
	}

	return raps_locs[0];
}


function get_favorite_enemy()
{
	raps_targets = getplayers();
	least_hunted = raps_targets[0];
	for( i = 0; i < raps_targets.size; i++ )
	{
		if ( !isdefined( raps_targets[i].hunted_by ) )
		{
			raps_targets[i].hunted_by = 0;
		}

		if( !zm_utility::is_player_valid( raps_targets[i] ) )
		{
			continue;
		}

		if( !zm_utility::is_player_valid( least_hunted ) )
		{
			least_hunted = raps_targets[i];
		}
			
		if( raps_targets[i].hunted_by < least_hunted.hunted_by )
		{
			least_hunted = raps_targets[i];
		}

	}
	
	least_hunted.hunted_by += 1;

	return least_hunted;	


}


function raps_health_increase()
{
	players = getplayers();

	if( level.raps_round_count == 1 )
	{
		level.raps_health = 400;
	}
	else if( level.raps_round_count == 2 )
	{
		level.raps_health = 900;
	}
	else if( level.raps_round_count == 3 )
	{
		level.raps_health = 1300;
	}
	else if( level.raps_round_count == 4 )
	{
		level.raps_health = 1600;
	}

	if( level.raps_health > 1600 )
	{
		level.raps_health = 1600;
	}
}

function raps_round_wait_func()
{
	if( level flag::get("raps_round" ) )
	{
		wait(7);
		
		while( level.raps_intermission )
		{
			wait(0.5);
		}	
		//increment_dog_round_stat("finished");	
	}
	
	level.sndMusicSpecialRound = false;
}

function raps_round_tracker()
{	
	level.raps_round_count = 1;
	
	// PI_CHANGE_BEGIN - JMA - making raps rounds random between round 5 thru 7
	// NOTE:  RandomIntRange returns a random integer r, where min <= r < max
	
	level.next_raps_round = 0; //alt wasp then raps, etc
	// PI_CHANGE_END
	
	old_spawn_func = level.round_spawn_func;
	old_wait_func  = level.round_wait_func;

	while ( 1 )
	{
		level waittill ( "between_round_over" );

		/#
			if( GetDvarInt( "force_raps" ) > 0 )
			{
				level.next_raps_round = level.round_number; 
			}
		#/

		if ( level.round_number == level.next_raps_round )
		{
			level.sndMusicSpecialRound = true;
			old_spawn_func = level.round_spawn_func;
			old_wait_func  = level.round_wait_func;
			raps_round_start();
			level.round_spawn_func =&raps_round_spawning;
			level.round_wait_func = &raps_round_wait_func;

			//Wasps are next
			level.next_wasp_round = level.round_number + randomintrange( 4, 6 );
			/#
				GetPlayers()[0] iprintln( "Next raps round: " + level.next_raps_round );
			#/
		}
		else if ( level flag::get( "raps_round" ) )
		{
			raps_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func  = old_wait_func;
            level.music_round_override = false;
			level.raps_round_count += 1;
		}
	}	
}


function raps_round_start()
{
	level flag::set( "raps_round" );
	level flag::set( "special_round" );
	level flag::set( "raps_clips" );
	
	if(!isdefined (level.rapsround_nomusic))
	{
		level.rapsround_nomusic = 0;
	}
	level.rapsround_nomusic = 1;
	level notify( "raps_round_starting" );
	level thread zm_audio::sndMusicSystem_PlayState( "meatball_start" );
	util::clientNotify( "raps_start" );

	if(isdefined(level.raps_melee_range))
	{
	 	SetDvar( "ai_meleeRange", level.raps_melee_range ); 
	}
	else
	{
	 	SetDvar( "ai_meleeRange", 100 ); 
	}
}


function raps_round_stop()
{
	level flag::clear( "raps_round" );
	level flag::clear( "special_round" );
	level flag::clear( "raps_clips" );
	
	//zm_utility::play_sound_2D( "mus_zombie_raps_end" );	
	if(!isdefined (level.rapsround_nomusic))
	{
		level.rapsround_nomusic = 0;
	}
	level.rapsround_nomusic = 0;
	level notify( "raps_round_ending" );
	util::clientNotify( "raps_stop" );

 	SetDvar( "ai_meleeRange", level.melee_range_sav ); 
 	SetDvar( "ai_meleeWidth", level.melee_width_sav );
 	SetDvar( "ai_meleeHeight", level.melee_height_sav );
}


function play_raps_round()
{
	self playlocalsound( "zmb_raps_round_start" );
	variation_count =5;
	
	wait(4.5);

	players = getplayers();
	num = randomintrange(0,players.size);
	players[num] zm_audio::create_and_play_dialog( "general", "raps_spawn" );
}



function raps_init()
{
	self.targetname = "zombie_raps";
	self.script_noteworthy = undefined;
	self.animname = "zombie_raps"; 		
	self.ignoreall = true; 
	self.ignoreme = true; // don't let attack raps give chase until the wolf is visible
	self.allowdeath = true; 			// allows death during animscripted calls
	self.allowpain = false;
	self.no_gib = true; //gibbing disabled
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
/*
	self AllowPitchAngle( 1 );
	self setPitchOrient();
	self setAvoidanceMask( "avoid none" );

	self PushActors( true );
*/
	health_multiplier = 1.0;
	if ( GetDvarString( "scr_raps_health_walk_multiplier" ) != "" )
	{
		health_multiplier = GetDvarFloat( "scr_raps_health_walk_multiplier" );
	}

	self.maxhealth = int( level.raps_health * health_multiplier );
	self.health = int( level.raps_health * health_multiplier );
/*
	self.freezegun_damage = 0;
	
	self.zombie_move_speed = "sprint";
*/
	self thread raps_run_think();
//	self thread raps_stalk_audio();

	self SetInvisibleToAll();
//	self thread util::magic_bullet_shield();
//	self raps_fx_eye_glow();
//	self raps_fx_trail();

	self thread raps_death();
	self thread raps_timeout_after_xsec( 100.0 );
	
	level thread zm_spawner::zombie_death_event( self ); 
	self thread zm_spawner::enemy_death_detection();
	
/*
	self.a.disablePain = true;
	self zm_utility::disable_react(); // SUMEET - zombies dont use react feature.
	self ClearGoalVolume();

	self.flame_damage_time = 0;
	self.meleeDamage = 40;

	self.thundergun_knockdown_func =&raps_thundergun_knockdown;
*/
	self zm_spawner::zombie_history( "zombie_raps_spawn_init -> Spawned = " + self.origin );
	
	if ( isdefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}
	
	
	raps::raps_initialize();
}

function raps_timeout_after_xsec( timeout )
{
	self endon( "death" );
	wait( timeout );
	self DoDamage( self.health + 100, self.origin );
}

function raps_fx_eye_glow()
{
	self.fx_raps_eye = spawn( "script_model", self GetTagOrigin( "J_EyeBall_LE" ) );
	assert( isdefined( self.fx_raps_eye ) );

	self.fx_raps_eye.angles = self GetTagAngles( "J_EyeBall_LE" );
	self.fx_raps_eye SetModel( "tag_origin" );
	self.fx_raps_eye LinkTo( self, "j_eyeball_le" );
}


function raps_fx_trail()
{
	//fire raps will explode during death	
	self.a.nodeath = true;

	self.fx_raps_trail_type = level._effect[ "raps_trail_blood" ];
	self.fx_raps_trail_sound = "zmb_hellhound_loop_fire";


	self.fx_raps_trail = spawn( "script_model", self GetTagOrigin( "tag_origin" ) );
	assert( isdefined( self.fx_raps_trail ) );

	self.fx_raps_trail.angles = self GetTagAngles( "tag_origin" );
	self.fx_raps_trail SetModel( "tag_origin" );
	self.fx_raps_trail LinkTo( self, "tag_origin" );
}

function raps_death()
{
	self waittill( "death", attacker );

	if( get_current_raps_count() == 0 && level.zombie_total == 0 )
	{

		level.last_raps_origin = self.origin;
		level notify( "last_raps_down" );

	}

	// score
	if( IsPlayer( attacker ) )
	{
		event = "death";
		self.damagelocation = "head";
		self.damagemod = "MOD_UNKNOWN";
		attacker zm_score::player_add_points( "death", self.damagemod, self.damagelocation, true );
	    
	    if( RandomIntRange(0,100) >= 80 )
	    {
	        attacker zm_audio::create_and_play_dialog( "kill", "hellhound" );
	    }
	    
	    //stats
		attacker zm_stats::increment_client_stat( "zraps_killed" );
		attacker zm_stats::increment_player_stat( "zraps_killed" );		    

	}

	// switch to inflictor when SP DoDamage supports it
	if( isdefined( attacker ) && isai( attacker ) )
	{
		attacker notify( "killed", self );
	}

	// sound
	self stoploopsound();

	self thread raps_explode_fx( self.origin );

}


function raps_explode_fx( origin )
{
	PlayFX( level._effect["raps_gib"], origin );
	
	players = GetPlayers();
	foreach(player in players)
	{
		if(distance(player.origin, self.origin) < 16 )
		{	
			player shellShock( "explosion", 1.5 );
		}
	}
}


// this is where zombies go into attack mode, and need different attributes set up
function zombie_setup_attack_properties_raps()
{
	self zm_spawner::zombie_history( "zombie_setup_attack_properties()" );
	
	//self thread raps_behind_audio();

	// allows zombie to attack again
	self.ignoreall = false; 

	//self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;

	// turn off transition anims
	self.disableArrivals = true; 
	self.disableExits = true; 

}


//COLLIN'S Audio Scripts
function stop_raps_sound_on_death()
{
	self waittill("death");
	self stopsounds();
}

function raps_behind_audio()
{
	self thread stop_raps_sound_on_death();

	self endon("death");
	self util::waittill_any( "raps_running", "raps_combat" );
	
	wait( 3 );

	while(1)
	{
		players = GetPlayers();
		for(i=0;i<players.size;i++)
		{
			rapsAngle = AngleClamp180( vectorToAngles( self.origin - players[i].origin )[1] - players[i].angles[1] );
		
			if(isAlive(players[i]) && !isdefined(players[i].revivetrigger))
			{
				if ((abs(rapsAngle) > 90) && distance2d(self.origin,players[i].origin) > 100)
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
//	Keeps raps_clips up if there is a raps running around in the level.
function raps_clip_monitor()
{
	clips_on = false;
	level.raps_clips = GetEntArray( "raps_clips", "targetname" );
	while (1)
	{
		for ( i=0; i<level.raps_clips.size; i++ )
		{
	//		level.raps_clips[i] TriggerEnable( false );
			level.raps_clips[i] ConnectPaths();
		}

		level flag::wait_till( "raps_clips" );
		
		if(isdefined(level.no_raps_clip) && level.no_raps_clip == true)
		{
			return;
		}
		
		for ( i=0; i<level.raps_clips.size; i++ )
		{
	//		level.raps_clips[i] TriggerEnable( true );
			level.raps_clips[i] DisconnectPaths();
			util::wait_network_frame();
		}

		raps_is_alive = true;
		while ( raps_is_alive || level flag::get( "raps_round" ) )
		{
			raps_is_alive = false;
			raps = GetEntArray( "zombie_raps", "targetname" );
			for ( i=0; i<raps.size; i++ )
			{
				if ( IsAlive(raps[i]) )
				{
					raps_is_alive = true;
				}
			}
			wait( 1 );
		}

		level flag::clear( "raps_clips" );
		wait(1);
	}
}


//	Allows raps to be spawned independent of the round spawning
function special_raps_spawn( location, num_to_spawn, fn_on_spawned )
{
	raps = GetEntArray( "zombie_raps", "targetname" );

	if ( isdefined( raps ) && raps.size >= 9 )
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

		if ( isdefined( level.raps_spawn_func ) )
		{
			spawn_point = [[level.raps_spawn_func]]( favorite_enemy );
		}
		else
		{
			if(IsDefined(location))
			{
				spawn_point = location;
			}
			else
			{
				spawn_point = raps_spawn_logic( favorite_enemy );
			}
		}

		ai = zombie_utility::spawn_zombie( level.raps_spawners[0] );
			
		if( IsDefined( ai ) ) 	
		{
			ai.favoriteenemy = favorite_enemy;
			spawn_point thread raps_spawn_fx( ai, spawn_point );
			count++;
			level flag::set( "raps_clips" );
			
			if ( isdefined( fn_on_spawned ) )
			{
				ai thread [[fn_on_spawned]]();
			}
		}

		waiting_for_next_raps_spawn( count, num_to_spawn );
	}

	return true;
}


function raps_run_think()
{
	self endon( "death" );

	// these should go back in when the stalking stuff is put back in, the visible check will do for now
	//self util::waittill_any( "raps_running", "raps_combat" );
	//self playsound( "zraps_close" );
	self waittill( "visible" );
	
	// decrease health
	if ( self.health > level.raps_health )
	{
		self.maxhealth = level.raps_health;
		self.health = level.raps_health;
	}
	
	// start glowing eyes
	//assert( isdefined( self.fx_raps_eye ) );
	//zm_net::network_safe_play_fx_on_tag( "raps_fx", 2, level._effect["raps_eye_glow"], self.fx_raps_eye, "tag_origin" );

	// start trail
	//assert( isdefined( self.fx_raps_trail ) );
	//zm_net::network_safe_play_fx_on_tag( "raps_fx", 2, self.fx_raps_trail_type, self.fx_raps_trail, "tag_origin" );
	//self playloopsound( self.fx_raps_trail_sound );

	//Check to see if the enemy is not valid anymore
	while( 1 )
	{
		if( !zm_utility::is_player_valid(self.favoriteenemy) )
		{
			//We are targetting an invalid player - select another one
			self.favoriteenemy = get_favorite_enemy();
		}
		wait( 0.2 );
	}
}

function raps_stalk_audio()
{
	self endon( "death" );
	self endon( "raps_running" );
	self endon( "raps_combat" );
	
	while(1)
	{
		self playsound( "zmb_hellhound_vocals_amb" );
		wait randomfloatrange(3,6);		
	}
}

function raps_thundergun_knockdown( player, gib )
{
	self endon( "death" );

	damage = int( self.maxhealth * 0.5 );
	self DoDamage( damage, player.origin, player );
}
