#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

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

                                                                                                                               

#precache( "fx", "zombie/fx_dog_lightning_buildup_zmb" );
#precache( "fx", "zombie/fx_dog_eyes_zmb" );
#precache( "fx", "zombie/fx_dog_explosion_zmb" );
#precache( "fx", "zombie/fx_dog_fire_trail_zmb" );
#precache( "fx", "zombie/fx_dog_ash_trail_zmb" );

#namespace zm_ai_dogs;

function init()
{
	level.dogs_enabled = true;
	level.dog_rounds_enabled = false;
	level.dog_round_count = 1;

	level.dog_spawners = [];

	//utility::flag_init( "dog_round" );
	level flag::init( "dog_clips" );

	if ( GetDvarString( "zombie_dog_animset" ) == "" )
	{
		SetDvar( "zombie_dog_animset", "zombie" );
	}

	if ( GetDvarString( "scr_dog_health_walk_multiplier" ) == "" )
	{
		SetDvar( "scr_dog_health_walk_multiplier", "4.0" );
	}

	if ( GetDvarString( "scr_dog_run_distance" ) == "" )
	{
		SetDvar( "scr_dog_run_distance", "500" );
	}

	level.melee_range_sav  = GetDvarString( "ai_meleeRange" );
	level.melee_width_sav = GetDvarString( "ai_meleeWidth" );
	level.melee_height_sav  = GetDvarString( "ai_meleeHeight" );

	zombie_utility::set_zombie_var( "dog_fire_trail_percent", 50 );

	level._effect[ "lightning_dog_spawn" ]	= "zombie/fx_dog_lightning_buildup_zmb";
	level._effect[ "dog_eye_glow" ]			= "zombie/fx_dog_eyes_zmb";
	level._effect[ "dog_gib" ]				= "zombie/fx_dog_explosion_zmb";
	level._effect[ "dog_trail_fire" ]		= "zombie/fx_dog_fire_trail_zmb";
	level._effect[ "dog_trail_ash" ]		= "zombie/fx_dog_ash_trail_zmb";

	// Init dog targets - mainly for testing purposes.
	//	If you spawn a dog without having a dog round, you'll get SREs on hunted_by.
	dog_spawner_init();

	level thread dog_clip_monitor();
}


//
//	If you want to enable dog rounds, then call this.
//	Specify an override func if needed.
function enable_dog_rounds()
{
	level.dog_rounds_enabled = true;

	if( !isdefined( level.dog_round_track_override ) )
	{
		level.dog_round_track_override =&dog_round_tracker;
	}

	level thread [[level.dog_round_track_override]]();
}


function dog_spawner_init()
{
	level.dog_spawners = getEntArray( "zombie_dog_spawner", "script_noteworthy" ); 
	later_dogs = getentarray("later_round_dog_spawners", "script_noteworthy" );
	level.dog_spawners = ArrayCombine( level.dog_spawners, later_dogs, true, false );
	
	if( level.dog_spawners.size == 0 )
	{
		return;
	}
	
	for( i = 0; i < level.dog_spawners.size; i++ )
	{
		if ( zm_spawner::is_spawner_targeted_by_blocker( level.dog_spawners[i] ) )
		{
			level.dog_spawners[i].is_enabled = false;
		}
		else
		{
			level.dog_spawners[i].is_enabled = true;
			level.dog_spawners[i].script_forcespawn = true;
		}
	}

	assert( level.dog_spawners.size > 0 );
	level.dog_health = 100;

	array::thread_all( level.dog_spawners,&spawner::add_spawn_function,&dog_init );
}


function dog_round_spawning()
{
	level endon( "intermission" );
	
	level.dog_targets = getplayers();
	for( i = 0 ; i < level.dog_targets.size; i++ )
	{
		level.dog_targets[i].hunted_by = 0;
	}

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

	level.dog_intermission = true;
	level thread dog_round_aftermath();
	players = GetPlayers();
	array::thread_all( players,&play_dog_round );	
	wait(1);
	level thread zm_audio::sndAnnouncerPlayVox("dogstart");
	wait(6);
	
	if( level.dog_round_count < 3 )
	{
		max = players.size * 6;
	}
	else
	{
		max = players.size * 8;
	}
	

 /#
 	if( GetDvarString( "force_dogs" ) != "" )
 	{
 		max = GetDvarInt( "force_dogs" );
 	}
 #/		

	level.zombie_total = max;
	dog_health_increase();



	count = 0; 
	while( count < max )
	{
		num_player_valid = zm_utility::get_number_of_valid_players();
	
		while( zombie_utility::get_current_zombie_count() >= num_player_valid * 2 )
		{
			wait( 2 );
			num_player_valid = zm_utility::get_number_of_valid_players();
		}
		
		//update the player array.
		players = GetPlayers();
		favorite_enemy = get_favorite_enemy();

		if ( isdefined( level.dog_spawn_func ) )
		{
			spawn_loc = [[level.dog_spawn_func]]( level.dog_spawners, favorite_enemy );

			ai = zombie_utility::spawn_zombie( level.dog_spawners[0] );
			if( isdefined( ai ) ) 	
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_loc thread dog_spawn_fx( ai, spawn_loc );
				level.zombie_total--;
				count++;
			}
		}
		else
		{
			// Default method
			spawn_point = dog_spawn_factory_logic( favorite_enemy );
			ai = zombie_utility::spawn_zombie( level.dog_spawners[0] );

			if( isdefined( ai ) ) 	
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx( ai, spawn_point );
				level.zombie_total--;
				count++;
				level flag::set( "dog_clips" );
			}
				/*
			// Old method
			spawn_point = dog_spawn_sumpf_logic( level.dog_spawners, favorite_enemy );
			ai = zombie_utility::spawn_zombie( spawn_point );

			if( isdefined( ai ) ) 	
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx( ai );
				level.zombie_total--;
				count++;

			}*/
		}

		
		waiting_for_next_dog_spawn( count, max );
	}




	

}
function waiting_for_next_dog_spawn( count, max )
{
	default_wait = 1.5;

	if( level.dog_round_count == 1)
	{
		default_wait = 3;
	}
	else if( level.dog_round_count == 2)
	{
		default_wait = 2.5;
	}
	else if( level.dog_round_count == 3)
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


function dog_round_aftermath()
{

	level waittill( "last_dog_down" );

	level thread zm_audio::sndMusicSystem_PlayState( "dog_end" );
	
	power_up_origin = level.last_dog_origin;

	if( isdefined( power_up_origin ) )
	{
		level thread zm_powerups::specific_powerup_drop( "full_ammo", power_up_origin );
	}
	
	wait(2);
	util::clientNotify( "dog_stop" );
	wait(6);
	level.dog_intermission = false;

	//level thread dog_round_aftermath();

}


//
//	In Sumpf, the dog spawner targets a struct to spawn from.
//	In Factory, there's a single spawner and the struct is passed in as the second argument.
function dog_spawn_fx( ai, ent )
{
	ai endon( "death" );
	
	/*if ( !IsDefined(ent) )
	{
		ent = struct::get( self.target, "targetname" );
	}*/

	ai SetFreeCameraLockOnAllowed( false );
//	if ( isdefined( ent ) )
	{
		Playfx( level._effect["lightning_dog_spawn"], ent.origin );
		playsoundatposition( "zmb_hellhound_prespawn", ent.origin );
		wait( 1.5 );
		playsoundatposition( "zmb_hellhound_bolt", ent.origin );

		Earthquake( 0.5, 0.75, ent.origin, 1000);
		//PlayRumbleOnPosition("explosion_generic", ent.origin);
		playsoundatposition( "zmb_hellhound_spawn", ent.origin );

		// face the enemy
		if ( IsDefined( ai.favoriteenemy ) )
		{
			angle = VectorToAngles( ai.favoriteenemy.origin - ent.origin );
			angles = ( ai.angles[0], angle[1], ai.angles[2] );
		}
		else
		{
			angles = ent.angles;
		}
		ai ForceTeleport( ent.origin, angles );
	}

	assert( isdefined( ai ), "Ent isn't defined." );
	assert( IsAlive( ai ), "Ent is dead." );
	assert( ai.isdog, "Ent isn't a dog;" );
	assert( zm_utility::is_magic_bullet_shield_enabled( ai ), "Ent doesn't have a magic bullet shield." );

	ai zombie_setup_attack_properties_dog();
	ai util::stop_magic_bullet_shield();

	wait( 0.1 ); // dog should come out running after this wait
	ai show();
	ai SetFreeCameraLockOnAllowed( true );
	ai.ignoreme = false; // don't let attack dogs give chase until the wolf is visible
	ai notify( "visible" );
}


//
//	Dog spawning logic for Factory.  
//	Makes use of the _zm_zone_manager and specially named structs for each zone to
//	indicate dog spawn locations instead of constantly using ents.
//	
function dog_spawn_factory_logic( favorite_enemy)
{
	dog_locs = array::randomize( level.zm_loc_types[ "dog_location" ] );
	//assert( dog_locs.size > 0, "Dog Spawner locs array is empty." );

	for( i = 0; i < dog_locs.size; i++ )
	{
		if( isdefined( level.old_dog_spawn ) && level.old_dog_spawn == dog_locs[i] )
		{
			continue;
		}

		dist_squared = DistanceSquared( dog_locs[i].origin, favorite_enemy.origin );
		if(  dist_squared > ( 400 * 400 ) && dist_squared < ( 1000 * 1000 ) )
		{
			level.old_dog_spawn = dog_locs[i];
			return dog_locs[i];
		}	
	}

	return dog_locs[0];
}


function get_favorite_enemy()
{
	dog_targets = getplayers();
	least_hunted = dog_targets[0];
	for( i = 0; i < dog_targets.size; i++ )
	{
		if ( !isdefined( dog_targets[i].hunted_by ) )
		{
			dog_targets[i].hunted_by = 0;
		}

		if( !zm_utility::is_player_valid( dog_targets[i] ) )
		{
			continue;
		}

		if( !zm_utility::is_player_valid( least_hunted ) )
		{
			least_hunted = dog_targets[i];
		}
			
		if( dog_targets[i].hunted_by < least_hunted.hunted_by )
		{
			least_hunted = dog_targets[i];
		}

	}
	// do not return the default first player if he is invalid
	if( !zm_utility::is_player_valid( least_hunted ) )
	{
		return undefined;
	}
	else
	{
		least_hunted.hunted_by += 1;

		return least_hunted;
	}

}


function dog_health_increase()
{
	players = getplayers();

	if( level.dog_round_count == 1 )
	{
		level.dog_health = 400;
	}
	else if( level.dog_round_count == 2 )
	{
		level.dog_health = 900;
	}
	else if( level.dog_round_count == 3 )
	{
		level.dog_health = 1300;
	}
	else if( level.dog_round_count == 4 )
	{
		level.dog_health = 1600;
	}

	if( level.dog_health > 1600 )
	{
		level.dog_health = 1600;
	}
}

function dog_round_wait_func()
{
	if( level flag::get("dog_round" ) )
	{
		wait(7);
		while( level.dog_intermission )
		{
			wait(0.5);
		}	
		zm::increment_dog_round_stat("finished");	
	}
	
	level.sndMusicSpecialRound = false;
}

function dog_round_tracker()
{	
	level.dog_round_count = 1;
	
	// PI_CHANGE_BEGIN - JMA - making dog rounds random between round 5 thru 7
	// NOTE:  RandomIntRange returns a random integer r, where min <= r < max
	
	level.next_dog_round = level.round_number + randomintrange( 4, 7 );	
	// PI_CHANGE_END
	
	old_spawn_func = level.round_spawn_func;
	old_wait_func  = level.round_wait_func;

	while ( 1 )
	{
		level waittill ( "between_round_over" );

		/#
			if( GetDvarInt( "force_dogs" ) > 0 )
			{
				level.next_dog_round = level.round_number; 
			}
		#/

		if ( level.round_number == level.next_dog_round )
		{
			level.sndMusicSpecialRound = true;
			old_spawn_func = level.round_spawn_func;
			old_wait_func  = level.round_wait_func;
			dog_round_start();
			level.round_spawn_func = &dog_round_spawning;
			level.round_wait_func = &dog_round_wait_func;

			level.next_dog_round = level.round_number + randomintrange( 4, 6 );
			/#
				GetPlayers()[0] iprintln( "Next dog round: " + level.next_dog_round );
			#/
		}
		else if ( level flag::get( "dog_round" ) )
		{
			dog_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func  = old_wait_func;
			level.dog_round_count += 1;
		}
	}	
}


function dog_round_start()
{
	level flag::set( "dog_round" );
	level flag::set( "special_round" );
	level flag::set( "dog_clips" );
	
	level notify( "dog_round_starting" );
	level thread zm_audio::sndMusicSystem_PlayState( "dog_start" );
	util::clientNotify( "dog_start" );

	if(isdefined(level.dog_melee_range))
	{
	 	SetDvar( "ai_meleeRange", level.dog_melee_range ); 
	}
	else
	{
	 	SetDvar( "ai_meleeRange", 100 ); 
	}
}


function dog_round_stop()
{
	level flag::clear( "dog_round" );
	level flag::clear( "special_round" );
	level flag::clear( "dog_clips" );
	
	level notify( "dog_round_ending" );
	util::clientNotify( "dog_stop" );
	
 	SetDvar( "ai_meleeRange", level.melee_range_sav ); 
 	SetDvar( "ai_meleeWidth", level.melee_width_sav );
 	SetDvar( "ai_meleeHeight", level.melee_height_sav );
}


function play_dog_round()
{
	self playlocalsound( "zmb_dog_round_start" );
	variation_count =5;
	
	wait(4.5);

	players = getplayers();
	num = randomintrange(0,players.size);
	players[num] zm_audio::create_and_play_dialog( "general", "dog_spawn" );
}


function dog_init()
{
	self.targetname = "zombie_dog";
	self.script_noteworthy = undefined;
	self.animname = "zombie_dog"; 		
	self.ignoreall = true; 
	self.ignoreme = true; // don't let attack dogs give chase until the wolf is visible
	self.allowdeath = true; 			// allows death during animscripted calls
	self.allowpain = false;
	self.force_gib = true; 		// needed to make sure this guy does gibs
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	// out both legs and then the only allowed stance should be prone.
	self.gibbed = false; 
	self.head_gibbed = false;
	self.default_goalheight = 40;
	self.ignore_inert = true;	

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

	self.team = level.zombie_team;

	self AllowPitchAngle( 1 );
	self setPitchOrient();
	self setAvoidanceMask( "avoid none" );

	self PushActors( true );

	health_multiplier = 1.0;
	if ( GetDvarString( "scr_dog_health_walk_multiplier" ) != "" )
	{
		health_multiplier = GetDvarFloat( "scr_dog_health_walk_multiplier" );
	}

	self.maxhealth = int( level.dog_health * health_multiplier );
	self.health = int( level.dog_health * health_multiplier );

	self.freezegun_damage = 0;
	
	self.zombie_move_speed = "sprint";

	self thread dog_run_think();
	self thread dog_stalk_audio();

	self thread zombie_utility::round_spawn_failsafe();
	self ghost();
	self thread util::magic_bullet_shield();
	self dog_fx_eye_glow();
	self dog_fx_trail();

	self thread dog_death();
	
	level thread zm_spawner::zombie_death_event( self ); 
	self thread zm_spawner::enemy_death_detection();
	self thread zm_audio::zmbAIVox_NotifyConvert();

	self.a.disablePain = true;
	self zm_utility::disable_react(); // SUMEET - zombies dont use react feature.
	self ClearGoalVolume();

	self.flame_damage_time = 0;
	self.meleeDamage = 40;

	self.thundergun_knockdown_func =&dog_thundergun_knockdown;

	self zm_spawner::zombie_history( "zombie_dog_spawn_init -> Spawned = " + self.origin );
	
	if ( isdefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}
}


function dog_fx_eye_glow()
{
	self.fx_dog_eye = spawn( "script_model", self GetTagOrigin( "J_EyeBall_LE" ) );
	assert( isdefined( self.fx_dog_eye ) );

	self.fx_dog_eye.angles = self GetTagAngles( "J_EyeBall_LE" );
	self.fx_dog_eye SetModel( "tag_origin" );
	self.fx_dog_eye LinkTo( self, "j_eyeball_le" );
}


function dog_fx_trail()
{
	if( !util::is_mature() || randomint( 100 ) > level.zombie_vars["dog_fire_trail_percent"] )
	{
		self.fx_dog_trail_type = level._effect[ "dog_trail_ash" ];
		self.fx_dog_trail_sound = "zmb_hellhound_loop_breath";
	}
	else
	{
		//fire dogs will explode during death	
		self.a.nodeath = true;

		self.fx_dog_trail_type = level._effect[ "dog_trail_fire" ];
		self.fx_dog_trail_sound = "zmb_hellhound_loop_fire";
	}

	self.fx_dog_trail = spawn( "script_model", self GetTagOrigin( "tag_origin" ) );
	assert( isdefined( self.fx_dog_trail ) );

	self.fx_dog_trail.angles = self GetTagAngles( "tag_origin" );
	self.fx_dog_trail SetModel( "tag_origin" );
	self.fx_dog_trail LinkTo( self, "tag_origin" );
}

function dog_death()
{
	self waittill( "death" );

	if( zombie_utility::get_current_zombie_count() == 0 && level.zombie_total == 0 )
	{

		level.last_dog_origin = self.origin;
		level notify( "last_dog_down" );

	}

	// score
	if( IsPlayer( self.attacker ) )
	{
		event = "death";
		if ( self.damageweapon.isBallisticKnife )
		{
			event = "ballistic_knife_death";
		}
		
		

		self.attacker zm_score::player_add_points( event, self.damagemod, self.damagelocation, true );
	    
	    if( RandomIntRange(0,100) >= 80 )
	    {
	        self.attacker zm_audio::create_and_play_dialog( "kill", "hellhound" );
	    }
	    
	    //stats
		self.attacker zm_stats::increment_client_stat( "zdogs_killed" );
		self.attacker zm_stats::increment_player_stat( "zdogs_killed" );		    

	}

	// switch to inflictor when SP DoDamage supports it
	if( isdefined( self.attacker ) && isai( self.attacker ) )
	{
		self.attacker notify( "killed", self );
	}

	// sound
	self stoploopsound();

	// fx
	assert( isdefined( self.fx_dog_eye ) );
	self.fx_dog_eye delete();

	assert( isdefined( self.fx_dog_trail ) );
	self.fx_dog_trail delete();

	if ( isdefined( self.a.nodeath ) )
	{
		level thread dog_explode_fx( self.origin );
		self delete();
	}
	else
	{
	    self notify( "bhtn_action_notify", "death" );
	}
}


function dog_explode_fx( origin )
{
	PlayFX( level._effect["dog_gib"], origin );
	PlaySoundAtPosition( "zmb_hellhound_explode", origin );
}


// this is where zombies go into attack mode, and need different attributes set up
function zombie_setup_attack_properties_dog()
{
	self zm_spawner::zombie_history( "zombie_setup_attack_properties()" );
	
	self thread dog_behind_audio();

	// allows zombie to attack again
	self.ignoreall = false; 

	//self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;

	// turn off transition anims
	self.disableArrivals = true; 
	self.disableExits = true; 

}


//COLLIN'S Audio Scripts
function stop_dog_sound_on_death()
{
	self waittill("death");
	self stopsounds();
}

function dog_behind_audio()
{
	self thread stop_dog_sound_on_death();

	self endon("death");
	self util::waittill_any( "dog_running", "dog_combat" );
	
	self notify( "bhtn_action_notify", "close" );
	wait( 3 );

	while(1)
	{
		players = GetPlayers();
		for(i=0;i<players.size;i++)
		{
			dogAngle = AngleClamp180( vectorToAngles( self.origin - players[i].origin )[1] - players[i].angles[1] );
		
			if(isAlive(players[i]) && !isdefined(players[i].revivetrigger))
			{
				if ((abs(dogAngle) > 90) && distance2d(self.origin,players[i].origin) > 100)
				{
					self notify( "bhtn_action_notify", "close" );
					wait( 3 );
				}
			}
		}
		
		wait(.75);
	}
}


//
//	Keeps dog_clips up if there is a dog running around in the level.
function dog_clip_monitor()
{
	clips_on = false;
	level.dog_clips = GetEntArray( "dog_clips", "targetname" );
	while (1)
	{
		for ( i=0; i<level.dog_clips.size; i++ )
		{
	//		level.dog_clips[i] TriggerEnable( false );
			level.dog_clips[i] ConnectPaths();
		}

		level flag::wait_till( "dog_clips" );
		
		if(isdefined(level.no_dog_clip) && level.no_dog_clip == true)
		{
			return;
		}
		
		for ( i=0; i<level.dog_clips.size; i++ )
		{
	//		level.dog_clips[i] TriggerEnable( true );
			level.dog_clips[i] DisconnectPaths();
			util::wait_network_frame();
		}

		dog_is_alive = true;
		while ( dog_is_alive || level flag::get( "dog_round" ) )
		{
			dog_is_alive = false;
			dogs = GetEntArray( "zombie_dog", "targetname" );
			for ( i=0; i<dogs.size; i++ )
			{
				if ( IsAlive(dogs[i]) )
				{
					dog_is_alive = true;
				}
			}
			wait( 1 );
		}

		level flag::clear( "dog_clips" );
		wait(1);
	}
}

//
//	Allows dogs to be spawned independent of the round spawning
function special_dog_spawn( num_to_spawn, spawners, spawn_point )
{
	dogs = GetAISpeciesArray( "all", "zombie_dog" );

	if ( isdefined( dogs ) && dogs.size >= 9 )
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

		if ( isdefined( spawners ) )
		{
			if ( !isdefined( spawn_point ) )
			{
				spawn_point = spawners[ RandomInt(spawners.size) ];
			}
			ai = zombie_utility::spawn_zombie( spawn_point );

			if( isdefined( ai ) ) 	
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx( ai );
				count++;
				level flag::set( "dog_clips" );
			}
		}
		else
		{
			if ( isdefined( level.dog_spawn_func ) )
			{
				spawn_loc = [[level.dog_spawn_func]]( level.dog_spawners, favorite_enemy );

				ai = zombie_utility::spawn_zombie( level.dog_spawners[0] );
				if( isdefined( ai ) ) 	
				{
					ai.favoriteenemy = favorite_enemy;
					spawn_loc thread dog_spawn_fx( ai, spawn_loc );
					count++;
					level flag::set( "dog_clips" );
				}
			}
			else
			{
				// Default method
				spawn_point = dog_spawn_factory_logic( favorite_enemy );
				ai = zombie_utility::spawn_zombie( level.dog_spawners[0] );

				if( isdefined( ai ) ) 	
				{
					ai.favoriteenemy = favorite_enemy;
					spawn_point thread dog_spawn_fx( ai, spawn_point );
					count++;
					level flag::set( "dog_clips" );
				}
			}
		}

		waiting_for_next_dog_spawn( count, num_to_spawn );
	}

	return true;
}

function dog_run_think()
{
	self endon( "death" );

	// these should go back in when the stalking stuff is put back in, the visible check will do for now
	//self util::waittill_any( "dog_running", "dog_combat" );
	//self playsound( "zdog_close" );
	self waittill( "visible" );
	
	// decrease health
	if ( self.health > level.dog_health )
	{
		self.maxhealth = level.dog_health;
		self.health = level.dog_health;
	}
	
	// start glowing eyes
	assert( isdefined( self.fx_dog_eye ) );
	zm_net::network_safe_play_fx_on_tag( "dog_fx", 2, level._effect["dog_eye_glow"], self.fx_dog_eye, "tag_origin" );

	// start trail
	assert( isdefined( self.fx_dog_trail ) );
	zm_net::network_safe_play_fx_on_tag( "dog_fx", 2, self.fx_dog_trail_type, self.fx_dog_trail, "tag_origin" );
	self playloopsound( self.fx_dog_trail_sound );

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

function dog_stalk_audio()
{
	self endon( "death" );
	self endon( "dog_running" );
	self endon( "dog_combat" );
	
	while(1)
	{
		self notify( "bhtn_action_notify", "ambient" );
		wait randomfloatrange(3,6);		
	}
}

function dog_thundergun_knockdown( player, gib )
{
	self endon( "death" );

	damage = int( self.maxhealth * 0.5 );
	self DoDamage( damage, player.origin, player );
}
