#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\mp\zombies\_zm_utility.gsh;

init()
{
	level.dogs_enabled = true;
	level.dog_rounds_enabled = false;
	level.dog_round_count = 1;

	level.dog_spawners = [];
	level.enemy_dog_spawns = [];
	level.enemy_dog_locations = [];
	//flag_init( "dog_round" );
	flag_init( "dog_clips" );

	PreCacheRumble( "explosion_generic" );
	PrecacheShellshock( "dog_bite" );

	if ( GetDvar( "zombie_dog_animset" ) == "" )
	{
		SetDvar( "zombie_dog_animset", "zombie" );
	}

	if ( GetDvar( "scr_dog_health_walk_multiplier" ) == "" )
	{
		SetDvar( "scr_dog_health_walk_multiplier", "4.0" );
	}

	if ( GetDvar( "scr_dog_run_distance" ) == "" )
	{
		SetDvar( "scr_dog_run_distance", "500" );
	}

	level.melee_range_sav  = GetDvar( "ai_meleeRange" );
	level.melee_height_sav = GetDvar( "ai_meleeWidth" );
	level.melee_width_sav  = GetDvar( "ai_meleeHeight" );

	// this gets rounded down to 40 damage after the dvar 'player_meleeDamageMultiplier' runs its calculation
	SetDvar( "dog_MeleeDamage", "100" );
	set_zombie_var( "dog_fire_trail_percent", 50 );

	level._effect[ "lightning_dog_spawn" ]	= Loadfx( "maps/zombie/fx_zombie_dog_lightning_buildup" );
	level._effect[ "dog_eye_glow" ]			= Loadfx( "maps/zombie/fx_zombie_dog_eyes" );
	level._effect[ "dog_gib" ]				= Loadfx( "maps/zombie/fx_zombie_dog_explosion" );
	level._effect[ "dog_trail_fire" ]		= Loadfx( "maps/zombie/fx_zombie_dog_fire_trail" );
	level._effect[ "dog_trail_ash" ]		= Loadfx( "maps/zombie/fx_zombie_dog_ash_trail" );

	// Init dog targets - mainly for testing purposes.
	//	If you spawn a dog without having a dog round, you'll get SREs on hunted_by.
	dog_spawner_init();

	level thread dog_clip_monitor();
}


//
//	If you want to enable dog rounds, then call this.
//	Specify an override func if needed.
enable_dog_rounds()
{
	level.dog_rounds_enabled = true;

	if( !isdefined( level.dog_round_track_override ) )
	{
		level.dog_round_track_override = ::dog_round_tracker;
	}

	level thread [[level.dog_round_track_override]]();
}


dog_spawner_init()
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
		if ( maps\mp\zombies\_zm_spawner::is_spawner_targeted_by_blocker( level.dog_spawners[i] ) )
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

	array_thread( level.dog_spawners, ::add_spawn_function, ::dog_init );

	//level.enemy_dog_spawns = getnodearray( "zombie_spawner_dog_init", "script_noteworthy" ); 
	level.enemy_dog_spawns = getEntArray( "zombie_spawner_dog_init", "targetname" );
}


dog_round_spawning()
{
	level endon( "intermission" );
	
	level.dog_targets = getplayers();
	for( i = 0 ; i < level.dog_targets.size; i++ )
	{
		level.dog_targets[i].hunted_by = 0;
	}


	//assert( level.enemy_dog_spawns.size > 0 );

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
	players = get_players();
	array_thread( players, ::play_dog_round );	
	wait(7);
	
	if( level.dog_round_count < 3 )
	{
		max = players.size * 6;
	}
	else
	{
		max = players.size * 8;
	}
	

 /#
 	if( GetDvar( "force_dogs" ) != "" )
 	{
 		max = GetDvarInt( "force_dogs" );
 	}
 #/		

	level.zombie_total = max;
	dog_health_increase();



	count = 0; 
	while( count < max )
	{
		num_player_valid = get_number_of_valid_players();
	
		while( get_enemy_count() >= num_player_valid * 2 )
		{
			wait( 2 );
			num_player_valid = get_number_of_valid_players();
		}
		
		//update the player array.
		players = get_players();
		favorite_enemy = get_favorite_enemy();

		if ( IsDefined( level.dog_spawn_func ) )
		{
			spawn_loc = [[level.dog_spawn_func]]( level.dog_spawners, favorite_enemy );

			ai = spawn_zombie( level.dog_spawners[0] );
			if( IsDefined( ai ) ) 	
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
			spawn_point = dog_spawn_factory_logic( level.enemy_dog_spawns, favorite_enemy );
			ai = spawn_zombie( level.dog_spawners[0] );

			if( IsDefined( ai ) ) 	
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx( ai, spawn_point );
				level.zombie_total--;
				count++;
				flag_set( "dog_clips" );
			}
				/*
			// Old method
			spawn_point = dog_spawn_sumpf_logic( level.dog_spawners, favorite_enemy );
			ai = spawn_zombie( spawn_point );

			if( IsDefined( ai ) ) 	
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
waiting_for_next_dog_spawn( count, max )
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


dog_round_aftermath()
{

	level waittill( "last_dog_down" );
	
	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "dog_end" );

	power_up_origin = level.last_dog_origin;

	if( IsDefined( power_up_origin ) )
	{
		level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( "full_ammo", power_up_origin );
	}
	
	wait(2);
	clientnotify( "dog_stop" );
	wait(6);
	level.dog_intermission = false;

	//level thread dog_round_aftermath();

}


//
//	In Sumpf, the dog spawner targets a struct to spawn from.
//	In Factory, there's a single spawner and the struct is passed in as the second argument.
dog_spawn_fx( ai, ent )
{
	/*if ( !IsDefined(ent) )
	{
		ent = GetStruct( self.target, "targetname" );
	}*/

//	if ( isdefined( ent ) )
	{
		Playfx( level._effect["lightning_dog_spawn"], ent.origin );
		playsoundatposition( "zmb_hellhound_prespawn", ent.origin );
		wait( 1.5 );
		playsoundatposition( "zmb_hellhound_bolt", ent.origin );

		Earthquake( 0.5, 0.75, ent.origin, 1000);
		PlayRumbleOnPosition("explosion_generic", ent.origin);
		playsoundatposition( "zmb_hellhound_spawn", ent.origin );

		// face the enemy
		angle = VectorToAngles( ai.favoriteenemy.origin - ent.origin );
		angles = ( ai.angles[0], angle[1], ai.angles[2] );
		ai ForceTeleport( ent.origin, angles );
	}

	assert( IsDefined( ai ), "Ent isn't defined." );
	assert( IsAlive( ai ), "Ent is dead." );
	assert( ai.isdog, "Ent isn't a dog;" );
	assert( is_magic_bullet_shield_enabled( ai ), "Ent doesn't have a magic bullet shield." );

	ai zombie_setup_attack_properties_dog();
	ai stop_magic_bullet_shield();

	wait( 0.1 ); // dog should come out running after this wait
	ai show();
	ai.ignoreme = false; // don't let attack dogs give chase until the wolf is visible
	ai notify( "visible" );
}


//
//	Dog spawning logic for swamp
dog_spawn_sumpf_logic( dog_array, favorite_enemy)
{

	assert( dog_array.size > 0, "Dog Spawner array is empty." );
	dog_array = array_randomize( dog_array );
	for( i = 0; i < dog_array.size; i++ )
	{
		if( IsDefined( level.old_dog_spawn ) && level.old_dog_spawn == dog_array[i] )
		{
			continue;
		}

		if( DistanceSquared( dog_array[i].origin, favorite_enemy.origin ) > ( 400 * 400 ) && DistanceSquared( dog_array[i].origin, favorite_enemy.origin ) < ( 800 * 800 ) )			
		{

			if(distanceSquared( ( 0, 0, dog_array[i].origin[2] ), ( 0, 0, favorite_enemy.origin[2] ) ) > 100 * 100 )
			{
				continue;
			}
			else
			{
				level.old_dog_spawn = dog_array[i];
				return dog_array[i];
			}

		}	

	}

	return dog_array[0];

}


//
//	Dog spawning logic for Factory.  
//	Makes use of the maps\mp\zombies\_zm_zone_manager and specially named structs for each zone to
//	indicate dog spawn locations instead of constantly using ents.
//	
dog_spawn_factory_logic( dog_array, favorite_enemy)
{
	dog_locs = array_randomize( level.enemy_dog_locations );
	//assert( dog_locs.size > 0, "Dog Spawner locs array is empty." );

	for( i = 0; i < dog_locs.size; i++ )
	{
		if( IsDefined( level.old_dog_spawn ) && level.old_dog_spawn == dog_locs[i] )
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


get_favorite_enemy()
{
	dog_targets = getplayers();
	least_hunted = dog_targets[0];
	for( i = 0; i < dog_targets.size; i++ )
	{
		if ( !IsDefined( dog_targets[i].hunted_by ) )
		{
			dog_targets[i].hunted_by = 0;
		}

		if( !is_player_valid( dog_targets[i] ) )
		{
			continue;
		}

		if( !is_player_valid( least_hunted ) )
		{
			least_hunted = dog_targets[i];
		}
			
		if( dog_targets[i].hunted_by < least_hunted.hunted_by )
		{
			least_hunted = dog_targets[i];
		}

	}
	
	least_hunted.hunted_by += 1;

	return least_hunted;	


}


dog_health_increase()
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


dog_round_tracker()
{	
	level.dog_round_count = 1;
	
	// PI_CHANGE_BEGIN - JMA - making dog rounds random between round 5 thru 7
	// NOTE:  RandomIntRange returns a random integer r, where min <= r < max
	level.next_dog_round = randomintrange( 5, 8 );	
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
			level.music_round_override = true;
			old_spawn_func = level.round_spawn_func;
			old_wait_func  = level.round_wait_func;
			dog_round_start();
			level.round_spawn_func = ::dog_round_spawning;

			level.next_dog_round = level.round_number + randomintrange( 4, 6 );
			/#
				get_players()[0] iprintln( "Next dog round: " + level.next_dog_round );
			#/
		}
		else if ( flag( "dog_round" ) )
		{
			dog_round_stop();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func  = old_wait_func;
            level.music_round_override = false;
			level.dog_round_count += 1;
		}			
	}	
}


dog_round_start()
{
	flag_set( "dog_round" );
	flag_set( "dog_clips" );

	level thread maps\mp\zombies\_zm_audio::change_zombie_music( "dog_start" );
	
	if(!IsDefined (level.doground_nomusic))
	{
		level.doground_nomusic = 0;
	}
	level.doground_nomusic = 1;
	level notify( "dog_round_starting" );
	clientnotify( "dog_start" );

	level.melee_range_sav  = 100;
	level.melee_height_sav = 0;
	level.melee_width_sav  = 0;
	
	if(IsDefined(level.dog_melee_range))
	{
	 	SetDvar( "ai_meleeRange", level.dog_melee_range ); 
	}
	else
	{
	 	SetDvar( "ai_meleeRange", "100" ); 
 	}
 	SetDvar( "ai_meleeWidth", "0" );
 	SetDvar( "ai_meleeHeight", "0" );
}


dog_round_stop()
{
	flag_clear( "dog_round" );
	flag_clear( "dog_clips" );
	
	//level thread maps\mp\zombies\_zm_audio::change_zombie_music( "dog_end" );
	
	//play_sound_2D( "mus_zombie_dog_end" );	
	if(!IsDefined (level.doground_nomusic))
	{
		level.doground_nomusic = 0;
	}
	level.doground_nomusic = 0;
	level notify( "dog_round_ending" );
	clientnotify( "dog_stop" );

 	SetDvar( "ai_meleeRange", level.melee_range_sav ); 
 	SetDvar( "ai_meleeWidth", level.melee_width_sav );
 	SetDvar( "ai_meleeHeight", level.melee_height_sav );
}


play_dog_round()
{
	self playlocalsound( "zmb_dog_round_start" );
	variation_count =5;
	
	wait (1);
	play_sound_2D( "zmb_vox_ann_dogstart" );

	wait(3.5);

	players = getplayers();
	num = randomintrange(0,players.size);
	players[num] maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "dog_spawn" );
}


dog_init()
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
	self.has_legs = true; 			// Sumeet - This tells the zombie that he is allowed to stand anymore or not, gibbing can take 
	// out both legs and then the only allowed stance should be prone.
	self.gibbed = false; 
	self.head_gibbed = false;
	self.default_goalheight = 40; 

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

	self.team = "axis";

	health_multiplier = 1.0;
	if ( GetDvar( "scr_dog_health_walk_multiplier" ) != "" )
	{
		health_multiplier = GetDvarFloat( "scr_dog_health_walk_multiplier" );
	}

	self.maxhealth = int( level.dog_health * health_multiplier );
	self.health = int( level.dog_health * health_multiplier );

	self.freezegun_damage = 0;
	
	self.zombie_move_speed = "sprint";

	self thread dog_run_think();
	self thread dog_stalk_audio();

	self thread maps\mp\zombies\_zm::round_spawn_failsafe();
	self hide();
	self thread magic_bullet_shield();
	self dog_fx_eye_glow();
	self dog_fx_trail();

	self thread dog_death();

	self.a.disablePain = true;
	self disable_react(); // SUMEET - zombies dont use react feature.
	self ClearEnemy();
	self ClearGoalVolume();

	self.flame_damage_time = 0;
	self.meleeDamage = 40;

	self.thundergun_knockdown_func = ::dog_thundergun_knockdown;

	self maps\mp\zombies\_zm_spawner::zombie_history( "zombie_dog_spawn_init -> Spawned = " + self.origin );
	
	if ( isDefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}
}


dog_fx_eye_glow()
{
	self.fx_dog_eye = Spawn( "script_model", self GetTagOrigin( "J_EyeBall_LE" ) );
	assert( IsDefined( self.fx_dog_eye ) );

	self.fx_dog_eye.angles = self GetTagAngles( "J_EyeBall_LE" );
	self.fx_dog_eye SetModel( "tag_origin" );
	self.fx_dog_eye LinkTo( self, "J_EyeBall_LE" );
}


dog_fx_trail()
{
	if( !is_mature() || randomint( 100 ) > level.zombie_vars["dog_fire_trail_percent"] )
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

	self.fx_dog_trail = Spawn( "script_model", self GetTagOrigin( "tag_origin" ) );
	assert( IsDefined( self.fx_dog_trail ) );

	self.fx_dog_trail.angles = self GetTagAngles( "tag_origin" );
	self.fx_dog_trail SetModel( "tag_origin" );
	self.fx_dog_trail LinkTo( self, "tag_origin" );
}

dog_death()
{
	self waittill( "death" );

	if( get_enemy_count() == 0 && level.zombie_total == 0 )
	{

		level.last_dog_origin = self.origin;
		level notify( "last_dog_down" );

	}

	// score
	if( IsPlayer( self.attacker ) )
	{
		event = "death";
		if ( issubstr( self.damageweapon, "knife_ballistic_" ) )
		{
			event = "ballistic_knife_death";
		}

		self.attacker maps\mp\zombies\_zm_score::player_add_points( event, self.damagemod, self.damagelocation, true );
	    
	    if( RandomIntRange(0,100) >= 80 )
	    {
	        self.attacker maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "hellhound" );
	    }
	}

	// switch to inflictor when SP DoDamage supports it
	if( isdefined( self.attacker ) && isai( self.attacker ) )
	{
		self.attacker notify( "killed", self );
	}

	// sound
	self stoploopsound();

	// fx
	assert( IsDefined( self.fx_dog_eye ) );
	self.fx_dog_eye delete();

	assert( IsDefined( self.fx_dog_trail ) );
	self.fx_dog_trail delete();

	if ( IsDefined( self.a.nodeath ) )
	{
		level thread dog_explode_fx( self.origin );
		self delete();
	}
	else
	{
	    self PlaySound( "zmb_hellhound_vocals_death" );
	}
}


dog_explode_fx( origin )
{
	fx = maps\mp\zombies\_zm_net::network_safe_spawn( "dog_death_fx", 2, "script_model", origin );
	assert( IsDefined( fx ) );

	fx SetModel( "tag_origin" );
	PlayFxOnTag( level._effect["dog_gib"], fx, "tag_origin" );
	fx playsound( "zmb_hellhound_explode" );

	wait( 5 );
	fx delete();
}


// this is where zombies go into attack mode, and need different attributes set up
zombie_setup_attack_properties_dog()
{
	self maps\mp\zombies\_zm_spawner::zombie_history( "zombie_setup_attack_properties()" );
	
	self thread dog_behind_audio();

	// allows zombie to attack again
	self.ignoreall = false; 

	self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;

	// turn off transition anims
	self.disableArrivals = true; 
	self.disableExits = true; 

}


//COLLIN'S Audio Scripts
stop_dog_sound_on_death()
{
	self waittill("death");
	self stopsounds();
}

dog_behind_audio()
{
	self thread stop_dog_sound_on_death();

	self endon("death");
	self waittill_any( "dog_running", "dog_combat" );
	
	self PlaySound( "zmb_hellhound_vocals_close" );
	wait( 3 );

	while(1)
	{
		players = get_players();
		for(i=0;i<players.size;i++)
		{
			dogAngle = AngleClamp180( vectorToAngles( self.origin - players[i].origin )[1] - players[i].angles[1] );
		
			if(isAlive(players[i]) && !isDefined(players[i].revivetrigger))
			{
				if ((abs(dogAngle) > 90) && distance2d(self.origin,players[i].origin) > 100)
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
//	Keeps dog_clips up if there is a dog running around in the level.
dog_clip_monitor()
{
	clips_on = false;
	level.dog_clips = GetEntArray( "dog_clips", "targetname" );
	while (1)
	{
		for ( i=0; i<level.dog_clips.size; i++ )
		{
			level.dog_clips[i] trigger_off();
			level.dog_clips[i] ConnectPaths();
		}

		flag_wait( "dog_clips" );
		
		if(IsDefined(level.no_dog_clip) && level.no_dog_clip == true)
		{
			return;
		}
		
		for ( i=0; i<level.dog_clips.size; i++ )
		{
			level.dog_clips[i] trigger_on();
			level.dog_clips[i] DisconnectPaths();
			wait_network_frame();
		}

		dog_is_alive = true;
		while ( dog_is_alive || flag( "dog_round" ) )
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

		flag_clear( "dog_clips" );
		wait(1);
	}
}

//
//	Allows dogs to be spawned independent of the round spawning
special_dog_spawn( spawners, num_to_spawn )
{
	dogs = GetAISpeciesArray( "all", "zombie_dog" );

	if ( IsDefined( dogs ) && dogs.size >= 9 )
	{
		return false;
	}
	
	if ( !IsDefined(num_to_spawn) )
	{
		num_to_spawn = 1;
	}

	spawn_point = undefined;
	count = 0;
	while ( count < num_to_spawn )
	{
		//update the player array.
		players = get_players();
		favorite_enemy = get_favorite_enemy();

		if ( IsDefined( spawners ) )
		{
			spawn_point = spawners[ RandomInt(spawners.size) ];
			ai = spawn_zombie( spawn_point );

			if( IsDefined( ai ) ) 	
			{
				ai.favoriteenemy = favorite_enemy;
				spawn_point thread dog_spawn_fx( ai );
				//					level.zombie_total--;
				count++;
				flag_set( "dog_clips" );
			}
		}
		else
		{
			if ( IsDefined( level.dog_spawn_func ) )
			{
				spawn_loc = [[level.dog_spawn_func]]( level.dog_spawners, favorite_enemy );

				ai = spawn_zombie( level.dog_spawners[0] );
				if( IsDefined( ai ) ) 	
				{
					ai.favoriteenemy = favorite_enemy;
					spawn_loc thread dog_spawn_fx( ai, spawn_loc );
//					level.zombie_total--;
					count++;
					flag_set( "dog_clips" );
				}
			}
			else
			{
				// Default method
				spawn_point = dog_spawn_factory_logic( level.enemy_dog_spawns, favorite_enemy );
				ai = spawn_zombie( level.dog_spawners[0] );

				if( IsDefined( ai ) ) 	
				{
					ai.favoriteenemy = favorite_enemy;
					spawn_point thread dog_spawn_fx( ai, spawn_point );
//					level.zombie_total--;
					count++;
					flag_set( "dog_clips" );
				}
			}
		}

		waiting_for_next_dog_spawn( count, num_to_spawn );
	}

	return true;
}

dog_run_think()
{
	self endon( "death" );

	// these should go back in when the stalking stuff is put back in, the visible check will do for now
	//self waittill_any( "dog_running", "dog_combat" );
	//self playsound( "zdog_close" );
	self waittill( "visible" );
	
	// decrease health
	if ( self.health > level.dog_health )
	{
		self.maxhealth = level.dog_health;
		self.health = level.dog_health;
	}
	
	// start glowing eyes
	assert( IsDefined( self.fx_dog_eye ) );
	network_safe_play_fx_on_tag( "dog_fx", 2, level._effect["dog_eye_glow"], self.fx_dog_eye, "tag_origin" );

	// start trail
	assert( IsDefined( self.fx_dog_trail ) );
	network_safe_play_fx_on_tag( "dog_fx", 2, self.fx_dog_trail_type, self.fx_dog_trail, "tag_origin" );
	self playloopsound( self.fx_dog_trail_sound );
}

dog_stalk_audio()
{
	self endon( "death" );
	self endon( "dog_running" );
	self endon( "dog_combat" );
	
	while(1)
	{
		self playsound( "zmb_hellhound_vocals_amb" );
		wait randomfloatrange(3,6);		
	}
}

dog_thundergun_knockdown( player, gib )
{
	self endon( "death" );

	damage = int( self.maxhealth * 0.5 );
	self DoDamage( damage, player.origin, player );
}
