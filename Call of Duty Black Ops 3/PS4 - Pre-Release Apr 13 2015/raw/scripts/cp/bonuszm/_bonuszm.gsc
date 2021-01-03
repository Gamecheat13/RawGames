#using scripts\codescripts\struct;

//TODO T7 - move gamewide shared files into load_shared once ZM gets a T7 pass
#using scripts\shared\ammo_shared;
#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientids_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\clientfield_shared;
#using scripts\shared\containers_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\gameskill_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\load_shared;
#using scripts\shared\math_shared;
#using scripts\shared\music_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\_oob;
#using scripts\shared\scene_shared;
#using scripts\shared\serverfaceanim_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;//DO NOT REMOVE - needed for system registration
#using scripts\shared\weapons\antipersonnelguidance;
#using scripts\shared\weapons\multilockapguidance;

#using scripts\shared\archetype_shared\archetype_shared;

#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\zombie_shared;
#using scripts\shared\ai\zombie_utility;
#using scripts\shared\ai\systems\blackboard;

           	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              	  	                                 	                 	    	                                      	      	      	       	                                                                   	          	  	                                                                               	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          	                                                                                                      	                                                                                                     	                                                                                                     	                                                                                                	     	                                                                                                                                                                                                                                                                                                                                                                                 	     	    	                                                                                                                                    	                      	              	  	               

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_load;
#using scripts\cp\_util;

#using scripts\cp\bonuszm\_bonuszm_dev;
#using scripts\cp\bonuszm\_bonuszm_data;
#using scripts\cp\bonuszm\_weaponboxzm;
#using scripts\cp\bonuszm\_bonuszm_spawner_shared;

#namespace bonuszm;


function autoexec __init__sytem__() {     system::register("bonuszm",&__init__,undefined,undefined);    }

function __init__()
{
	if( !GetDvarint("ai_spawn_only_zombies") == 1 )
		return;

	bonuszm::register_clientfields();
	level.run_custom_function_on_ai = &bonuszm::run_on_all_zombies;
	level.move_failsafe_override = &bonuszm::move_failsafe_override;
	level.customHeroSpawn = &bonuszm::customHeroSpawn;
	bonuszm_dev::SetupDevgui();
	level.allow_zombie_to_target_ai = true;

	level.override_ammo_caches = &_weaponboxzm::override_ammo_caches;

	init_defaults();
	level thread tweakzombies();
	
	_bonuszm_data::init();
	level thread watch_for_checkpoint_change();

	/#
		level thread _debug_tossers();		
    #/
    	
    // Add a callback for setting up player on connect
	callback::on_connect( &bonuszm_on_player_connect );
}

function private bonuszm_on_player_connect() // self = player
{
	
}

function customHeroSpawn()
{
	self.allow_zombie_to_target_ai = true;

	//hero was spawned and his check to all current zombies
	if( IsActor( self ) )
	{
		zombies = GetAiTeamArray( "axis" );
		if ( IsDefined( zombies ) )
		{
			foreach( zombie in zombies )
			{
				 if( IsActor( zombie ) )
				 {
				 	zombie thread waitfor_zombie_sees_player_or_hero( self );
				 }
			}
		} 
	}
	
	self thread force_hero_stealth_flags();
	self thread force_hero_attack_flags();
	self thread waitfor_hero_takes_damage();
}




function waitfor_hero_takes_damage()
{
	self endon( "death" );
	self endon("heros_go"); 

	//If zombie takes damage then GO
	self waittill("damage");
	self.ignoreall = false;
	self.pacifist = false;
	self.ignoreme = false; 
	self notify("heros_go"); 

}



function force_hero_stealth_flags()
{
	self endon( "death" );
	self endon( "heros_go" );

	while( 1 )
	{
		self.ignoreall = true;
		self.pacifist = true;
		self.ignoreme = false; 
		wait( 0.1 );
	}
}
	
	
function force_hero_attack_flags()
{
	self endon( "death" );

	level waittill("heros_go");	
	while( 1 )
	{
		self.ignoreall = false;
		self.pacifist = false;
		self.ignoreme = false; 
		wait( 0.1 );
	}
}
		

function move_failsafe_override( prevorigin )
{
	//Kill them if they are not close to the player

	if( isdefined( self.enemy ) )
	{
		if( DistanceSquared( self.origin, self.enemy.origin ) < (256*256) )
			return;	//close to player so don't timeout
	}

	//self.origin
	
	//self setgoal( self.origin );
	//self.stop_player_tracking = true;


	//add this to the stats even tho he really didn't 'die' 
	level.zombies_timeout_playspace++;
	
	// DEBUG HACK
	self dodamage( self.health + 100, (0,0,0) );
}

function checkpoint_change_thread( checkpointname )
{
	level endon( "objective_changed" );

	//Get any extra spawn points
	level.extra_spawn_points = struct::get_array( checkpointname + "_zm", "targetname" );

	if( isdefined( level.bonuszm_waittill_name ) )
	{
		//If this waittill gets hit then super extra spawn zombies based on extra added positions
		level waittill( level.bonuszm_waittill_name );

		superextra_spawn_points = struct::get_array( level.bonuszm_waittill_name + "_zm", "targetname" );
		for( i=0; i<superextra_spawn_points.size; i++ )
		{
			if( level.number_extra_zombies_spawned<level.bonuszm_max_number_extra_zombies )
			{
				level.zombie_spawners[0] thread spawn_extra_zombie2( 0, superextra_spawn_points[i], "superextra", true );
			}
		}	
	}
}


function watch_for_checkpoint_change()
{
	while(GetDvarint( "bonuszm_enable_tweaks" ) == 0 )
	{
		level waittill( "objective_changed", objectives );
		level.current_skipto = objectives[0];
		_bonuszm_data::fill_in_values_from_data_table( GetDvarString( "mapname" ), objectives[0] );
		level thread checkpoint_change_thread( objectives[0] );
		wait( 1.0 ); 
		
		//level flag::set( "limit_awareness_enemy_spotted" );
	}
}

function init_defaults()
{
	if( GetDvarString( "bonuszm_debug_tossers" ) == "" )
	{
		SetDvar( "bonuszm_debug_tossers", 0 ); 
	}
	if( GetDvarString( "bonuszm_debug_extras" ) == "" )
	{
		SetDvar( "bonuszm_debug_extras", 0 ); 
	}
	if( GetDvarString( "bonuszm_enable_tweaks" ) == "" )
	{
		SetDvar( "bonuszm_enable_tweaks", 0 ); 
	}
	if( GetDvarString( "bonuszm_extra_spawns" ) == "" )
	{
		SetDvar( "bonuszm_extra_spawns", 1 ); 
	}
	if( GetDvarString( "bonuszm_extra_spawn_gap" ) == "" )
	{
		SetDvar( "bonuszm_extra_spawn_gap", 2 ); 
	}
	if( GetDvarString( "bonuszm_max_threshold" ) == "" )
	{
		SetDvar( "bonuszm_max_threshold", 30 ); 
	}
	if( GetDvarString( "bonuszm_max_number_extra_zombies" ) == "" )
	{
		SetDvar( "bonuszm_max_number_extra_zombies", 1000 ); 
	}

	if( GetDvarString( "bonuszm_walk_percent" ) == "" )
	{
		SetDvar( "bonuszm_walk_percent", 80 ); 
	}
	if( GetDvarString( "bonuszm_run_percent" ) == "" )
	{
		SetDvar( "bonuszm_run_percent", 10 ); 
	}
	if( GetDvarString( "bonuszm_sprint_percent" ) == "" )
	{
		SetDvar( "bonuszm_sprint_percent", 10 ); 
	}


	if( GetDvarString( "bonuszm_lv1_percent" ) == "" )
	{
		SetDvar( "bonuszm_lv1_percent", 60 ); 
	}
	if( GetDvarString( "bonuszm_lv2_percent" ) == "" )
	{
		SetDvar( "bonuszm_lv2_percent", 20 ); 
	}
	if( GetDvarString( "bonuszm_lv3_percent" ) == "" )
	{
		SetDvar( "bonuszm_lv3_percent", 10 ); 
	}
	if( GetDvarString( "bonuszm_lv4_percent" ) == "" )
	{
		SetDvar( "bonuszm_lv4_percent", 10 ); 
	}
	if( GetDvarString( "bonuszm_zombify_enabled" ) == "" )
	{
		SetDvar( "bonuszm_zombify_enabled", 1 ); 
	}
	if( GetDvarString( "bonuszm_start_unaware" ) == "" )
	{
		SetDvar( "bonuszm_start_unaware", 1 ); 
	}

	zombie_utility::set_zombie_var( "zombie_use_failsafe", 				true );		// Will slowly kill zombies who are stuck
	zombie_utility::set_zombie_var( "below_world_check", 				-5000 );					//	Check height to see if a zombie has fallen through the world.
	level.zombie_team = "axis";
	level.zombie_spawners = GetEntArray( "zombie_spawner", "script_noteworthy" );
	level.failsafe_waittime = 15;
	level.zombies_timeout_playspace = 0;
	level.number_extra_zombies_spawned = 0;
	level.current_skipto = "unknown";
		
	//level.bonuszm_enable_tweaks = GetDvarInt( "bonuszm_enable_tweaks" );	
	level.bonuszm_extra_spawns = GetDvarInt( "bonuszm_extra_spawns" );	
	level.bonuszm_extra_spawn_gap = GetDvarFloat( "bonuszm_extra_spawn_gap" );	
	level.bonuszm_max_threshold = GetDvarInt( "bonuszm_max_threshold" );
	level.bonuszm_max_number_extra_zombies = GetDvarInt( "bonuszm_max_number_extra_zombies" );		

	level.bonuszm_walk_percent = GetDvarInt( "bonuszm_walk_percent" );
	level.bonuszm_run_percent = GetDvarInt( "bonuszm_run_percent" );
	level.bonuszm_sprint_percent = GetDvarInt( "bonuszm_sprint_percent" );

	level.bonuszm_lv1_percent = GetDvarInt( "bonuszm_lv1_percent" );
	level.bonuszm_lv2_percent = GetDvarInt( "bonuszm_lv2_percent" );
	level.bonuszm_lv3_percent = GetDvarInt( "bonuszm_lv3_percent" );
	level.bonuszm_lv4_percent = GetDvarInt( "bonuszm_lv4_percent" );

	level.bonuszm_zombify_enabled = GetDvarInt( "bonuszm_zombify_enabled" );
	level.bonuszm_start_unaware = GetDvarInt( "bonuszm_start_unaware" );
}

function tweakzombies()
{
	tweak_toggle = 1;	
	for( ;; )
	{
		while(GetDvarint( "bonuszm_enable_tweaks" ) == 0 )
		{
			tweak_toggle = 1;
			wait .05; 
		}
		
		if(tweak_toggle)
		{
			tweak_toggle = 0;
			//SetDvar( "bonuszm_enable_tweaks", level.bonuszm_enable_tweaks );
			SetDvar( "bonuszm_extra_spawns", level.bonuszm_extra_spawns );
			SetDvar( "bonuszm_extra_spawn_gap", level.bonuszm_extra_spawn_gap );
			SetDvar( "bonuszm_max_threshold", level.bonuszm_max_threshold );
			SetDvar( "bonuszm_max_number_extra_zombies", level.bonuszm_max_number_extra_zombies );

			SetDvar( "bonuszm_walk_percent", level.bonuszm_walk_percent );
			SetDvar( "bonuszm_run_percent", level.bonuszm_run_percent );
			SetDvar( "bonuszm_sprint_percent", level.bonuszm_sprint_percent );

			SetDvar( "bonuszm_lv1_percent", level.bonuszm_lv1_percent );
			SetDvar( "bonuszm_lv2_percent", level.bonuszm_lv2_percent );
			SetDvar( "bonuszm_lv3_percent", level.bonuszm_lv3_percent );
			SetDvar( "bonuszm_lv4_percent", level.bonuszm_lv4_percent );

			SetDvar( "bonuszm_zombify_enabled", level.bonuszm_zombify_enabled );
			SetDvar( "bonuszm_start_unaware", level.bonuszm_start_unaware );
		}

		//level.bonuszm_enable_tweaks = GetDvarInt( "bonuszm_enable_tweaks" );
		level.bonuszm_extra_spawns = GetDvarInt( "bonuszm_extra_spawns" );	
		level.bonuszm_extra_spawn_gap = GetDvarFloat( "bonuszm_extra_spawn_gap" );	
		level.bonuszm_max_threshold = GetDvarInt( "bonuszm_max_threshold" );
		level.bonuszm_max_number_extra_zombies = GetDvarInt( "bonuszm_max_number_extra_zombies" );		

		level.bonuszm_walk_percent = GetDvarInt( "bonuszm_walk_percent" );
		level.bonuszm_run_percent = GetDvarInt( "bonuszm_run_percent" );
		level.bonuszm_sprint_percent = GetDvarInt( "bonuszm_sprint_percent" );

		level.bonuszm_lv1_percent = GetDvarInt( "bonuszm_lv1_percent" );
		level.bonuszm_lv2_percent = GetDvarInt( "bonuszm_lv2_percent" );
		level.bonuszm_lv3_percent = GetDvarInt( "bonuszm_lv3_percent" );
		level.bonuszm_lv4_percent = GetDvarInt( "bonuszm_lv4_percent" );
		
		level.bonuszm_zombify_enabled = GetDvarInt( "bonuszm_zombify_enabled" );
		level.bonuszm_start_unaware = GetDvarInt( "bonuszm_start_unaware" );
		
		wait .1; 
	}
}         



function setup_zombie()
{
	//All zombies start walking
	self.zombie_move_speed = "walk";
	
/*
		//Speed

		total_percentage = level.bonuszm_walk_percent + level.bonuszm_run_percent + level.bonuszm_sprint_percent;
		rand_num =  randomint( total_percentage );

		if( rand_num > (level.bonuszm_walk_percent + level.bonuszm_run_percent) )
		{
			self.zombie_move_speed = "sprint";
		}
		else if( rand_num > level.bonuszm_walk_percent)
		{
			self.zombie_move_speed = "run"; 
		}
		else
		{
			self.zombie_move_speed = "walk";
		}
*/

	//Health
	total_percentage = level.bonuszm_lv1_percent + level.bonuszm_lv2_percent + level.bonuszm_lv3_percent + level.bonuszm_lv4_percent;
	rand_num =  randomint( total_percentage );


/*
round	health at round
1	150
2	250
3	350
4	450
5	550
6	650
7	750
8	850
9	950
10	1045
11	1149
12	1263
13	1389
14	1527
15	1679
16	1846
17	2030
18	2233
19	2456
20	2701
*/

	if( rand_num > (level.bonuszm_lv1_percent + level.bonuszm_lv2_percent + level.bonuszm_lv3_percent) )
	{
		//level 4
		self.bonuszmlevel = 3;
		self.health = 1045;	//round 10 (red)
	}
	else if( rand_num > level.bonuszm_lv1_percent + level.bonuszm_lv2_percent)
	{	
		//level 3
		self.bonuszmlevel = 2;
		self.health = 650;	//round 6 (green)
	}
	else if( rand_num > level.bonuszm_lv1_percent)
	{	
		//level 2 
		self.bonuszmlevel = 1;
		self.health = 350;	//round 3 (blue)
	}
	else
	{	
		//level 1
		self.bonuszmlevel = 0;
		self.health = 150;	//round 1 (orange)
	}

	if(GetDvarint( "bonuszm_debug_extras" ) == 0 )
	{
		self.rand_eye_col = self.bonuszmlevel;
	}

	self.disableAmmoDrop = true;
	//self.ignoreall = false;
		
	self thread zmbAIVox_NotifyConvert();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	
	//self.ignoreall = true; 
	//self.ignoreme = true;		// don't let attack dogs give chase until the zombie is in the playable area
	self.allowdeath = true; 	// allows death during animscripted calls
	self.force_gib = true; 		// needed to make sure this guy does gibs
	self.is_zombie = true; 		// needed for melee.gsc in the animscripts
	self allowedStances( "stand" ); 
	self.gibbed = false; 
	self.head_gibbed = false;
	
	self setPhysParams( 15, 0, 72 );
	self.goalradius = 32;
	
	self.disableArrivals = true; 
	self.disableExits = true; 
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;

	self.ignoreSuppression = true; 	
	self.suppressionThreshold = 1; 
	self.noDodgeMove = true; 
	self.dontShootWhileMoving = true;
	self.pathenemylookahead = 0;

	self.badplaceawareness = 0;
	self.chatInitialized = false; 

	self.a.disablepain = true;
	self.a.disableReact = true;
	self.allowReact = false;

	self PushActors( true );
	self SetAvoidanceMask( "avoid all" );
	
	
	//For SGEN
	self.old_maxsightdistsqrd = self.maxsightdistsqrd;
	self.old_fovcosine = self.fovcosine;
	
	
	self.ignoreall = true;
	self.pacifist = false;
	self.ignoreme = false; 
	
	self thread zombie_utility::zombie_gib_on_damage();
	level thread zombie_death_event( self );
	self thread update_zombie();
	self thread zombie_utility::round_spawn_failsafe();


	self.overrideActorDamage = &callback_cpzm_damage;
	self.closest_player_override = &closest_player_override;

	self clientfield::set("bonus_zombie_has_eyes", self.rand_eye_col);

	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		self thread zombie_utility::delayed_zombie_eye_glow();	// delayed eye glow for ground crawlers (the eyes floated above the ground before the anim started)
	}

	//self thread zombie_juke();
}

function private FindClosest( origin, entities )
{
	closest = SpawnStruct();

	if ( entities.size > 0 )
	{
		closest.distanceSquared = DistanceSquared( origin, entities[0].origin );
		closest.entity = entities[0];
		
		for ( index = 1; index < entities.size; index++ )
		{
			distanceSquared = DistanceSquared( origin, entities[index].origin );
			
			if ( distanceSquared < closest.distanceSquared )
			{
				closest.distanceSquared = distanceSquared;
				closest.entity = entities[index];
			}
		}
	}
	
	return closest;
}

function closest_player_override( origin, players )
{
	//Ok return closest player - or AI
	closestPlayer = FindClosest( origin, players );
	
	// Add AI's that are on different teams.	
	aiEnemies = [];
	ai = GetAiArray();
	foreach( index, value in ai )
	{
		// Throw out other AI's that are outside the entity's goalheight.
		// This prevents considering enemies on other floors.
		if ( value.team != level.zombie_team )//&& IsActor( value ) && !IsDefined( entity.favoriteenemy ) )
		{
			//Check to see how many zombies are attacking this AI already
			aiAttackCount = 0;
			zombies = GetAiTeamArray( "axis" );
			if ( IsDefined( zombies ) )
			{
				foreach( zombie in zombies )
				{
					if( zombie==self )
						continue;
					if( isdefined(zombie.currentenemy) && (value == zombie.currentenemy) )
						aiAttackCount++;
				}
			} 		

			addme = true;
			if( IsDefined( closestPlayer.entity ) )
			{
				//We have a player so only attack an AI
				if( aiAttackCount>0 )
				{
					addme = false;
				}
			}
			
			if( addme )
			{
				enemyPositionOnNavMesh = GetClosestPointOnNavMesh( value.origin, 200 );
		
				if( IsDefined( enemyPositionOnNavMesh ) )
				{
					aiEnemies[aiEnemies.size] = value;
				}
			}
		}
	}

	closestAI = FindClosest( origin, aiEnemies );

	if ( !IsDefined( closestPlayer.entity ) && !IsDefined( closestAI.entity ) )
	{
		// No player or actor to choose, bail out.
		//self.enemy = undefined;
		//self SetEntityTarget( undefined );
		self.currentenemy = undefined;
		return undefined;
	}
	else if ( !IsDefined( closestAI.entity ) )
	{
		// Only has a player to choose.
		//self.enemy = closestPlayer.entity;
		//self SetEntityTarget( closestPlayer.entity, 1 );
		self.currentenemy = closestPlayer.entity;
		return closestPlayer.entity;
	}
	else if ( !IsDefined( closestPlayer.entity ) )
	{
		// Only has an AI to choose.
		//self.enemy = closestAI.entity;
		//self SetEntityTarget( closestAI.entity, 1 );
		self.currentenemy = closestAI.entity;
		closestAI.entity.last_valid_position = closestAI.entity.origin;
		return closestAI.entity;
	}
	else if ( (closestAI.distanceSquared + 100) < closestPlayer.distanceSquared )
	{
		// AI is closer than a player, time for additional checks.
		//self.enemy = closestAI.entity;
		//self SetEntityTarget( closestAI.entity, 1 );
		self.currentenemy = closestAI.entity;
		closestAI.entity.last_valid_position = closestAI.entity.origin;
		return closestAI.entity;
	}
	else
	{
		// Player is closer, choose them.
		//self.enemy = closestPlayer.entity;
		//self SetEntityTarget( closestPlayer.entity, 1 );
		self.currentenemy = closestPlayer.entity;
		return closestPlayer.entity;
	}
}


function callback_cpzm_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if ( IsDefined(eAttacker) && IsAI(eAttacker) )
	{
		// AI do not do melee damage to teammates
		if( (sMeansOfDeath == "MOD_MELEE") || (sMeansOfDeath == "MOD_MELEE_WEAPON_BUTT") )
		{
			iDamage = 999;
		}
	}

	return( iDamage );
}

function zombie_juke()
{
	self endon( "death" );

	if ( !IsDefined( self.next_juke_time ) )
	{
		self.next_juke_time = 0;
	}

	while ( !self.missingLegs )
	{
		if ( GetTime() > self.next_juke_time )
		{
			if ( math::cointoss() )
			{
				self.juke = "left";
			}
			else
			{
				self.juke = "right";
			}

			while ( IsDefined( self.juke ) )
			{
				wait( 0.1 );
			}

			self.next_juke_time = GetTime() + RandomIntRange( 2000, 4000 );
		}

		wait( 0.1 );
	}
}

function wait_for_zombie_speed_change()
{
	self endon( "death" );
	
	//If the zombie sees a player then they run / sprint
	self waittill("start_running");

	self.ignoreall = false;
	self.pacifist = false;
	self.ignoreme = false; 
	self.meleeAttackDist = 64;
	//self.maxsightdistsqrd = 128 * 128;
	self.disableArrivals = true; 
	self.disableExits = true; 

	self.maxsightdistsqrd = self.old_maxsightdistsqrd;
	self.fovcosine = self.old_fovcosine;

	self thread force_flags();

	rand_num =  randomint( 100 );
	if( rand_num > 50 )
	{
		self.zombie_move_speed = "sprint";
	}
	else
	{
		self.zombie_move_speed = "run"; 
	}
}

function force_flags()
{
	self endon( "death" );
	
	while( 1 )
	{
		self.ignoreall = false;
		self.pacifist = false;
		self.ignoreme = false; 
		self.goalradius = 32;
		self.meleeAttackDist = 64;
		self.maxsightdistsqrd = 128 * 128;
		self.disableArrivals = true; 
		self.disableExits = true; 
		self util::stop_magic_bullet_shield();
		wait( 0.1 );
	}
}


function can_zombie_hear_player_or_hero( player_or_hero )
{
	self endon( "death" );
	player_or_hero endon( "death" );
	self endon( "start_running" );

//	750*750 == 562500
	n_noise_range_sq = 1500*1500;
	
	while( isdefined(player_or_hero) )
	{
		player_or_hero waittill( "weapon_fired" );
		level notify("heros_go");
		
		if( !isdefined(self.m_str_state) )
		{
			distanceSq = DistanceSquared( player_or_hero.origin, self.origin );
		
			//Can zombie hear player or hero?
			if( distanceSq < (n_noise_range_sq) )
			{
				self notify("start_running");
			}
		}

		wait( 0.1 );
	}
}

function can_zombie_see_player_or_hero( player_or_hero )
{
	self endon( "death" );
	player_or_hero endon( "death" );
	self endon( "start_running" );

//	750*750 == 562500
//	0.707 == cos(45) == 90 degree FOV
	n_sight_range_sq = 562500;
	n_fovcos = 0.707;

	self.old_maxsightdistsqrd = self.maxsightdistsqrd;
	self.old_fovcosine = self.fovcosine;

	self.maxsightdistsqrd = n_sight_range_sq;
	self.fovcosine = n_fovcos;

	while( isdefined(player_or_hero) )
	{
		if( !isdefined(self.m_str_state) )
		{
			if( self CanSee( player_or_hero) )
			{
				self notify("start_running");
			}

			self.ignoreall = true;		
			self.pacifist = true;
		}
		wait( 0.1 );
	}
}


function zombie_wander()
{
	self endon( "death" );
	self endon( "start_running" );

	self.badpathcount = 0;

	while( 1 )
	{
		//If ignore all if set and zombie does not have a path
		if( self.ignoreall && !(self HasPath()) )
		{
			//Only allow 3 bad paths in a row
			if( self.badpathcount<3 )
			{
				//Find a node to go to
				nodes = GetNodesInRadius( self.origin, 1024, 0 );
				if( isdefined( nodes ) && (nodes.size>0) )
				{
					nodes = array::randomize( nodes );

					//Go there
					pathfound = self FindPath( self.origin, nodes[0].origin );
					if( !pathfound )
					{
						self.badpathcount++;
					}
					else
					{
						self SetGoal( nodes[0] );
						self.badpathcount = 0;
					}
				}
				else
				{
					self.badpathcount++;
				}
			}

			wait( 3.0 );
		}

		wait( 0.1 );
	}
}

function zombie_dies_check()
{
	self waittill( "death" );
	death_point = self.origin;
	
	//Any zombies close to this one should start running!
	zombies = GetAiTeamArray( level.zombie_team );
	
	for( i = 0; i < zombies.size; i++ )
	{
		if( !IsAlive( zombies[i] ) )
		{
			continue;
		}

		distanceSq = DistanceSquared( death_point, zombies[i].origin );
		if( distanceSq < (300*300) )
		{
			zombies[i] notify( "start_running" );
		}
	}
}

//get all cover nodes within a radius

//rand pick one

// go there

// wait rand

//  repeat



function waitfor_zombie_takes_damage()
{
	self endon( "death" );
	self endon("start_running"); 

	//If zombie takes damage then GO
	while( 1 )
	{
		self waittill("damage");

		if( !isdefined(self.m_str_state) )
		{
			self.ignoreall = false;
			self.pacifist = false;
			self.ignoreme = false; 
			self notify("start_running"); 
		}
		wait( 1.0 );
	}
}

function waitfor_zombie_sees_player_or_hero( player_or_hero )
{
	self endon( "death" );
	self endon("start_running"); 

	//If player or hero gets close to Zombie then GO
	self thread can_zombie_see_player_or_hero( player_or_hero );
	self thread can_zombie_hear_player_or_hero( player_or_hero );
}

function update_zombie()
{
	self endon( "death" );

	self.distanceThreshold = 500 + randomint( 300 );
	
	self thread zombie_wander();
	self thread waitfor_zombie_takes_damage();				//If zombie takes damage then GO
	self thread wait_for_zombie_speed_change();



	//Run on each player and spawned hero
	//If player gets close to Zombie then GO
	players = GetPlayers();
	for(i = 0; i < players.size; i++)
	{
		self thread waitfor_zombie_sees_player_or_hero( players[i] );
	}

	//set ignore to heroes
	if( isdefined(level.heroes) )
	{
		foreach( e_hero in level.heroes )
		{
			if( isdefined(e_hero) )
			{
				self thread waitfor_zombie_sees_player_or_hero( e_hero );
			}
		}
	}

	if( level.bonuszm_start_unaware==0 )
	{
		self notify("start_running"); 
	}
}








// network optimization: space out zombie death event network traffic
function delay_showing_vulture_ent( v_moveto_pos, str_model )
{
	self.drop_time = GetTime();
	
	util::wait_network_frame();  
	util::wait_network_frame();
	
	self.origin = v_moveto_pos;
	
	util::wait_network_frame();
	
	if ( IsDefined( str_model ) )
	{
		self SetModel( str_model );
		self clientfield::set("powerup_on_fx", 1);
		playsoundatposition ( "zmb_spawn_powerup", self.origin );
		self playloopsound ( "zmb_spawn_powerup_loop" , .5);
 	}
	
	self Show();
}

// model is solid for half its life, then blinks slowly, medium, fast, and deletes
function _vulture_model_blink_timeout()
{
	self endon( "death" );
	self endon( "stop_vulture_behavior" );
	
	// three blinks: slow, medium, fast
	n_time_total = 12	;
	n_frames = ( n_time_total * 20 );
	n_section = Int( n_frames / 6 );
	
	// cutoff times
	n_flash_slow = n_section * 3;
	n_flash_medium = n_section * 4;
	n_flash_fast = n_section * 5;
	
	b_show = true;
	i = 0;
	
	while ( i < n_frames )
	{
		if ( i < n_flash_slow )
		{
			// solid full time
			n_multiplier = n_flash_slow;  // solid for first half of life
		}
		else if ( i < n_flash_medium )
		{
			// flash slowly
			n_multiplier = 10;  // 0.5 seconds
		}
		else if ( i < n_flash_fast )
		{
			// flash medium
			n_multiplier = 5;  // 0.25 seconds
		}
		else 
		{
			// flash quickly
			n_multiplier = 2;  // 0.1 seconds
		}
		
		if ( b_show )
		{
			self Show();
		}
		else 
		{
			self Ghost();
		}
		
		b_show = !b_show; // toggle
		i += n_multiplier;  // increment count
		wait 0.05 * n_multiplier;
	}
	
	self notify( "stop_vulture_behavior" );
}

function _delete_vulture_ent( n_delay = 0.1 )
{
	self clientfield::set("powerup_on_fx", 0);
	
	if ( n_delay > 0 )
	{
		self Ghost();
		wait n_delay;
	}
	
	self Delete();
}


function _play_vulture_drop_pickup_fx()
{
	//self.model clientfield::set("powerup_on_fx", 1);
	playsoundatposition ( "zmb_powerup_grabbed", self.origin );
}

function _vulture_drop_model_thread()  // self = script model
{
	self thread _vulture_model_blink_timeout();
	
	self util::waittill_any( "death_or_disconnect", "stop_vulture_behavior" );
	
	n_delete_delay = 0.1;  // needs 0.1 wait to make sure client has recieved appropriate field notification
	
	if ( ( isdefined( self.picked_up ) && self.picked_up ) )
	{
		self _play_vulture_drop_pickup_fx();
		n_delete_delay = 1;
	}
	
	self _delete_vulture_ent( n_delete_delay );	
}

function _vulture_drop_model( str_model, v_model_origin, v_offset = ( 0, 0, 0 ) )  // self = player
{
	if ( !IsDefined( self.perk_vulture_models ) )
	{
		self.perk_vulture_models = [];
	}
	
	e_temp = Spawn( "script_model", (0,0,0) );
	e_temp SetModel( "tag_origin" );	
	e_temp thread delay_showing_vulture_ent( v_model_origin + v_offset, str_model );


	e_temp thread _vulture_drop_model_thread();
	
	return e_temp;
}

function give_vulture_bonus( str_bonus )  // self = player
{	
	switch ( str_bonus )
	{
		case "ammo":
			self give_max_ammo();
			break;
		
		case "attachment":
			self give_weapon_attachment();
			break;
			
		default:
			Assert( "invalid bonus string '" + str_bonus + "' used in give_vulture_bonus()!" );
			break;
	}
}

function give_max_ammo()
{
	a_w_weapons = self GetWeaponsList();

	foreach ( w_weapon in a_w_weapons )
	{
		self GiveMaxAmmo( w_weapon );
		self SetWeaponAmmoClip( w_weapon, w_weapon.clipSize );
	}

	self notify ( "ammo_refilled" );
}

function give_weapon_attachment()
{
	weapon = self GetCurrentWeapon();
	
	attachment = array::random( weapon.supportedattachments );
	
	if( isdefined(attachment) )
	{
		new_weapon = GetWeapon( weapon.rootweapon.name, attachment );
		
		self TakeWeapon( weapon );
		self GiveWeapon( new_weapon );
		self SwitchToWeapon( new_weapon );		
	}
}

/*=============================================================================
Use distance check around point where zombie died to figure out when player has
'collected' vulture bonus. Note that 'zombie stink' is unique and doesn't get
handled the same way.
=============================================================================*/

function check_vulture_drop_pickup( e_temp, str_identifier, str_bonus )
{
	if ( !IsDefined( e_temp ) )
	{
		return;  // _vulture_drop_model couldn't find model, so don't run logic 
	}	
	
	e_temp endon( "death" );
	e_temp endon( "stop_vulture_behavior" );
	
	util::wait_network_frame();  // make sure all threads have a chance to get ready
	
	n_times_to_check = Int( 12 / 0.15 );
	
	for ( i = 0; i < n_times_to_check; i++ )
	{
		//Run on each player and spawned hero
		//If player gets close to Zombie then GO
		players = GetPlayers();
		for(i = 0; i < players.size; i++)
		{
			b_player_inside_radius =  ( DistanceSquared( e_temp.origin, players[i].origin ) < 32 * 32 );
				
			if ( ( isdefined( b_player_inside_radius ) && b_player_inside_radius ) )
			{
				e_temp.picked_up = true;

				players[i] notify( str_identifier );
				players[i] give_vulture_bonus( str_bonus );
				
				e_temp notify( "stop_vulture_behavior" );

				break;
			}
		}
		
		wait 0.15;
	}
}

function drop_stuff_on_death()
{
	chance = RandomInt( 100 );
	
	if( chance > 50 )
	{	
		str_identifier = "max_ammo";
		str_bonus = "ammo";
		e_temp = self _vulture_drop_model( "p7_zm_power_up_max_ammo", self.origin, ( 0, 0, 15 ) );
	}
	else
	{	
		str_identifier = "weapon_attachment";
		str_bonus = "attachment";
		e_temp = self _vulture_drop_model( "p7_zm_power_up_carpenter", self.origin, ( 0, 0, 15 ) );
	}

	//Run thread on
	self thread check_vulture_drop_pickup( e_temp, str_identifier, str_bonus );	
}


function zombie_death_event( zombie )
{
	zombie.marked_for_recycle = 0;

	force_explode = 0;
	force_head_gib = 0;
	
	zombie waittill( "death", attacker);
	time_of_death = gettime();
	
	if(isDefined(zombie))
	{
		zombie StopSounds();
	}

	// The Insta Kill Upgrade - Forces melee deaths on close proximity
	if( IsDefined(zombie) && IsDefined(zombie.marked_for_insta_upgraded_death) )
	{
		force_head_gib = 1;
	}

	if ( !isdefined( zombie.damagehit_origin ) && isdefined( attacker ) && IsAlive( attacker ) && IsActor( attacker ) )
	{
		zombie.damagehit_origin = attacker GetWeaponMuzzlePoint();
	}

	// Need to check in case he got deleted earlier
	if ( !IsDefined( zombie ) )
	{
		return;
	}
	
	//Track all zombies killed
	//level.total_zombies_killed++;

	name = zombie.animname;
	if( isdefined( zombie.sndname ) )
	{
		name = zombie.sndname;
	}
	
	zombie thread zombie_utility::zombie_eye_glow_stop();

	if( IsActor( zombie ) )
	{
		if( (zombie.damagemod == "MOD_GRENADE") || (zombie.damagemod == "MOD_GRENADE_SPLASH") || (zombie.damagemod == "MOD_EXPLOSIVE") || (force_explode == 1) )
		{
			splode_dist = 12 * 15;
			if ( isdefined(zombie.damagehit_origin) && distancesquared(zombie.origin,zombie.damagehit_origin) < splode_dist * splode_dist )
			{
				tag = "J_SpineLower";
				
				
				if (!( isdefined( zombie.is_on_fire ) && zombie.is_on_fire ) && !( isdefined( zombie.guts_explosion ) && zombie.guts_explosion ))
				{
					zombie thread zombie_utility::zombie_gut_explosion();
				}
			}
		}
	}
	
	if( RandomInt( 100 ) > 85 ) //15% of the time
	{	
		zombie thread drop_stuff_on_death();
	}
	
	if(isdefined (zombie.attacker) && isplayer(zombie.attacker) )
	{
		zombie.attacker notify( "zom_kill", zombie );
	}

		
	level notify( "zom_kill" );
	//level.total_zombies_killed++;
}

function cpzombie_rise_fx(zombie)
{
	zombie endon("death");
	self endon("stop_zombie_rise_fx");
	self endon("rise_anim_finished");
	
	// this needs to have "level.riser_type = "snow" set in the level script to work properly in snow levels!
	zombie clientfield::set("zombie_riser_fx", 1);
}

function do_cpzombie_rise(spot)
{	
	self endon("death");

	self.in_the_ground = true;

	if ( IsDefined( self.anchor ) )
	{
		self.anchor Delete();
	}
	
	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);

	if( !isDefined( spot.angles ) )
	{
		spot.angles = (0, 0, 0);
	}

	anim_org = spot.origin;
	anim_ang = spot.angles;

	anim_org = anim_org + (0, 0, 0);	// start the animation 45 units below the ground

	self Ghost();
	self.anchor moveto(anim_org, .05);
	self.anchor waittill("movedone");

	// face goal
	target_org = zombie_utility::get_desired_origin();
	if (IsDefined(target_org))
	{
		anim_ang = VectorToAngles(target_org - self.origin);
	}
	self.anchor RotateTo((0, anim_ang[1], 0), .05);
	self.anchor waittill("rotatedone");

	self unlink();
	
	if(isDefined(self.anchor))
	{
		self.anchor delete();
	}

	self thread zombie_utility::hide_pop();	// hack to hide the pop when the zombie gets to the start position before the anim starts

	level thread zombie_utility::zombie_rise_death(self, spot);
	spot thread cpzombie_rise_fx(self);


	self OrientMode( "face default" );
	
	self AnimScripted( "rise_anim", self.origin, self.angles, "ai_zombie_traverse_ground_climbout_fast" );		
	self zombie_shared::DoNoteTracks( "rise_anim", &zombie_utility::handle_rise_notetracks, spot );

	self notify("rise_anim_finished");
	spot notify("stop_zombie_rise_fx");
	self.in_the_ground = false;
	
	self notify("risen", spot.script_string );
}


function spawn_extra_zombie( time_to_wait, position, angle, str_targetname, force_spawn )
{
	self endon( "death" );
	
	wait( time_to_wait );
	
	//if( (self.alertlevel == "noncombat") && (IsDefined(self.target)) )
	//if( self.ignoreall )//|| !(self HasPath()) )
	//	return;
	
	extra_time = randomFloatRange(0.1, 0.4);
	wait( extra_time );


	//Spawn
	spawner = level.zombie_spawners[0];
	ai = zombie_utility::spawn_zombie( spawner, spawner.targetname );
	if( IsDefined( ai ) )
	{
		spot = SpawnStruct();
		spot struct::init();
		spot.origin = position;
		spot.angles = angle;
		ai thread do_cpzombie_rise( spot );
		ai waittill("rise_anim_finished");
		
		//ai ForceTeleport( position );
		if(GetDvarint( "bonuszm_debug_extras" ) == 1 )
		{
			ai.rand_eye_col = 3;
		}
		ai setup_zombie();
		level.number_extra_zombies_spawned++;
	}
}

function spawn_extra_zombie2( time_to_wait, spot, str_targetname, force_spawn )
{
	self endon( "death" );
	
	wait( time_to_wait );
	
	//if( (self.alertlevel == "noncombat") && (IsDefined(self.target)) )
	//if( self.ignoreall )//|| !(self HasPath()) )
	//	return;
	
	extra_time = randomFloatRange(0.1, 0.4);
	wait( extra_time );


	//Spawn
	spawner = level.zombie_spawners[0];
	ai = zombie_utility::spawn_zombie( spawner, spawner.targetname );
	if( IsDefined( ai ) )
	{
	
		ai thread do_cpzombie_rise( spot );
		ai waittill("rise_anim_finished");
		
		if(GetDvarint( "bonuszm_debug_extras" ) == 1 )
		{
			ai.rand_eye_col = 3;
		}
		ai setup_zombie();
		level.number_extra_zombies_spawned++;
	}
}


function spawn_extra_zombies_iff_alerted( str_targetname, force_spawn )
{
	spawner = level.zombie_spawners[0];
	position_to_use = self.origin;
	angle_to_use = self.angles;
	
	self util::waittill_any( "death", "start_running");
	
	if( level.number_extra_zombies_spawned<level.bonuszm_max_number_extra_zombies )
	{
		//Spawn an extra zombie
		if( GetAICount() < level.bonuszm_max_threshold )
		{
			for( i=0; i<level.bonuszm_extra_spawns; i++ )
			{
				if( isdefined(level.extra_spawn_points) && level.extra_spawn_points.size>0 )
				{
					//Find closest to original spawner
					currentDistSQ = 9999999.0;
					currentIndex = 0;
					for( i=0; i<level.extra_spawn_points.size; i++ )
					{
						distSqr = DistanceSquared( level.extra_spawn_points[i].origin, position_to_use );

						if( distSqr<currentDistSQ )
						{
							currentDistSQ = distSqr;
							currentIndex = i;
						}
					}
					//position_to_use = level.extra_spawn_points[randomint(level.extra_spawn_points.size)].origin;
					position_to_use = level.extra_spawn_points[currentIndex].origin;
					angle_to_use = level.extra_spawn_points[currentIndex].angles;
				}		

				if( !isdefined( angle_to_use ) )
				{
					angle_to_use = (0,0,0);
				}
				
				if( IsDefined( spawner ) )
				{
					spawner thread spawn_extra_zombie( level.bonuszm_extra_spawn_gap * (i+1), position_to_use, angle_to_use, str_targetname, force_spawn );
				}
			}
		}
	}
}


function run_on_all_zombies( spawner, str_targetname, force_spawn )
{
	if ( !isActor(self) )
		return;
	
	if ( self IsInScriptedState() )
		return;
	

	//Check this is a zombie	
	if( isdefined(self.aitype) && (self.aitype == "spawner_bo3_zombie") )
	{	
		if( level.bonuszm_extra_spawns>0 )
		{
			self thread spawn_extra_zombies_iff_alerted( str_targetname, force_spawn );		
		}
		
		if(GetDvarint( "bonuszm_debug_extras" ) == 1 )
		{
			self.rand_eye_col = 0;
		}
		self setup_zombie();
	}
	else if( !( isdefined( self.is_hero ) && self.is_hero ) )
	{
		//is not a hero - allow death!
		//self util::stop_magic_bullet_shield();
	}
}



function register_clientfields()
{
	clientfield::register("actor", "zombie_riser_fx", 1, 1, "int" );
	clientfield::register("actor", "zombie_has_eyes", 1, 1, "int" );
	clientfield::register("actor", "bonus_zombie_has_eyes", 1, 3, "int" );
	clientfield::register("actor", "zombie_gut_explosion", 1, 1, "int" );
	clientfield::register("scriptmover", "powerup_on_fx", 1, 1, "int" );
}

function _create_debug_entry_pair( label, label_index )
{
/#
	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index] SetText( label );
	level.debug_hud_tossers[label_index].alignX = "right";
	level.debug_hud_tossers[label_index].x = 50;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;

	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index].alignX = "left";
	level.debug_hud_tossers[label_index].x = 60;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;

	level.current_y = level.current_y + 10;
#/
	return label_index;
}

function _create_debug_entry_4( label, label_index )
{
/#
	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index] SetText( label );
	level.debug_hud_tossers[label_index].alignX = "right";
	level.debug_hud_tossers[label_index].x = 50;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;

	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index].alignX = "left";
	level.debug_hud_tossers[label_index].x = 60;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;
	
	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index].alignX = "right";
	level.debug_hud_tossers[label_index].x = 100;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;
	
	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index].alignX = "left";
	level.debug_hud_tossers[label_index].x = 130;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;

	level.current_y = level.current_y + 10;
#/
	return label_index;
}

	/*xloc = [];
	xloc[0] = 50;
	xloc[1] = 60;
	xloc[2] = 100;
	xloc[3] = 130;
	xloc[4] = 170;
	xloc[5] = 250;*/
	
function _create_debug_entry_5( label, label_index )
{
/#
	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index] SetText( label );
	level.debug_hud_tossers[label_index].alignX = "right";
	level.debug_hud_tossers[label_index].x = 50;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;

	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index].alignX = "left";
	level.debug_hud_tossers[label_index].x = 60;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;

	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index].alignX = "right";
	level.debug_hud_tossers[label_index].x = 100;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;
	
	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index].alignX = "left";
	level.debug_hud_tossers[label_index].x = 130;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;
	
	level.debug_hud_tossers[label_index] = NewDebugHudElem();
	level.debug_hud_tossers[label_index].alignX = "right";
	level.debug_hud_tossers[label_index].x = 170;
	level.debug_hud_tossers[label_index].y = level.current_y;
	label_index++;
	
	level.current_y = level.current_y + 10;
#/
	return label_index;
}

function _set_debug_entry_pair( value, label_index )
{
	level.debug_hud_tossers[label_index+1] SetText( value );
	label_index = label_index + 2;
	return label_index;
}

function _set_debug_entry_4( value1, value2, value3, label_index )
{
	level.debug_hud_tossers[label_index+1] SetText( value1 );
	level.debug_hud_tossers[label_index+2] SetText( value2 );
	level.debug_hud_tossers[label_index+3] SetText( value3 );
	label_index = label_index + 4;
	return label_index;
}

function _set_debug_entry_5( value1, value2, value3, value4, label_index )
{
	level.debug_hud_tossers[label_index+1] SetText( value1 );
	level.debug_hud_tossers[label_index+2] SetText( value2 );
	level.debug_hud_tossers[label_index+3] SetText( value3 );
	level.debug_hud_tossers[label_index+4] SetText( value4 );
	label_index = label_index + 5;
	return label_index;
}

function _init_debug_tossers()
{
	level.current_y = 30;
	level.debug_hud_tossers = [];

/#		
	debug_hud_tossers_count = 0;
	debug_hud_tossers_count = _create_debug_entry_pair( "current_skipto", debug_hud_tossers_count );
	debug_hud_tossers_count = _create_debug_entry_pair( "enable_tweaks", debug_hud_tossers_count );
	debug_hud_tossers_count = _create_debug_entry_pair( "extra_spawns", debug_hud_tossers_count );
	debug_hud_tossers_count = _create_debug_entry_pair( "extra_spawn_gap", debug_hud_tossers_count );
	debug_hud_tossers_count = _create_debug_entry_pair( "max_threshold", debug_hud_tossers_count );
	debug_hud_tossers_count = _create_debug_entry_pair( "max_number_extra_zombies", debug_hud_tossers_count );
	debug_hud_tossers_count = _create_debug_entry_4( "walk/run/sprint_percent", debug_hud_tossers_count );
	debug_hud_tossers_count = _create_debug_entry_5( "lv1/lv2/lv3/lv4_percent", debug_hud_tossers_count );
	debug_hud_tossers_count = _create_debug_entry_pair( "start_unaware", debug_hud_tossers_count );
#/
}

function _destroy_debug_tossers()
{
	for ( i = 0; i < level.debug_hud_tossers.size; i++ )
	{
		level.debug_hud_tossers[i] Destroy();
		level.debug_hud_tossers[i] = undefined;
	}
}

function _debug_tossers()
{
	enabled = false;
	if ( GetDvarString("bonuszm_debug_tossers") == "" ) 
	{
		SetDvar("bonuszm_debug_tossers", "0");
	}

	while ( true )
	{
		wasEnabled = enabled;
		enabled = GetDvarInt("bonuszm_debug_tossers");
		if ( enabled && !wasEnabled )
		{
			_init_debug_tossers();
		}
		else if ( !enabled && wasEnabled )
		{
			_destroy_debug_tossers();
		}
		
		occupied_zone = undefined;

		if ( enabled )
		{
			debug_hud_tossers_update_count = 0;
			debug_hud_tossers_update_count = _set_debug_entry_pair( level.current_skipto, debug_hud_tossers_update_count );
			debug_hud_tossers_update_count = _set_debug_entry_pair( GetDvarint( "bonuszm_enable_tweaks" ), debug_hud_tossers_update_count );
			debug_hud_tossers_update_count = _set_debug_entry_pair( level.bonuszm_extra_spawns, debug_hud_tossers_update_count);
			debug_hud_tossers_update_count = _set_debug_entry_pair( level.bonuszm_extra_spawn_gap, debug_hud_tossers_update_count );
			debug_hud_tossers_update_count = _set_debug_entry_pair( level.bonuszm_max_threshold, debug_hud_tossers_update_count );
			debug_hud_tossers_update_count = _set_debug_entry_pair( level.bonuszm_max_number_extra_zombies, debug_hud_tossers_update_count );
			
			debug_hud_tossers_update_count = _set_debug_entry_4( level.bonuszm_walk_percent, level.bonuszm_run_percent, level.bonuszm_sprint_percent, debug_hud_tossers_update_count );
			debug_hud_tossers_update_count = _set_debug_entry_5( level.bonuszm_lv1_percent, level.bonuszm_lv2_percent, level.bonuszm_lv3_percent, level.bonuszm_lv4_percent, debug_hud_tossers_update_count );
			debug_hud_tossers_update_count = _set_debug_entry_pair( level.bonuszm_start_unaware, debug_hud_tossers_update_count );
		}

		wait( 0.1 );
	}
}




//--------------------------------------------------------------------------------------------------
//		ZOMBIE VOCALS SCRIPT (from _zm_audio.gsc)
//--------------------------------------------------------------------------------------------------
function zmbAIVox_NotifyConvert()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self thread zmbAI_PlaySprintVox();
	self thread zmbAIVox_PlayDeath();

	while (1)
{
		self waittill("bhtn_action_notify", notify_string);
		
		switch( notify_string )
		{					
			case "death":
			case "behind":
			case "attack_melee":
			case "electrocute":
			case "close":
				level thread zmbAIVox_PlayVox( self, notify_string, true );
				break;
			case "teardown":
			case "taunt":
			case "ambient":
			case "sprint":
			case "crawler":
				level thread zmbAIVox_PlayVox( self, notify_string, false );
				break;
			default:
			{
				if ( IsDefined( level._zmbAIVox_SpecialType ) )
				{
					if( isdefined( level._zmbAIVox_SpecialType[notify_string] ) )
					{
						level thread zmbAIVox_PlayVox( self, notify_string, false );
					}
				}
				break;
			}
		}
	}
}
function zmbAIVox_PlayVox( zombie, type, override )
{
    zombie endon( "death" ); 
    
    if( !isdefined( zombie ) )
    	return;
    
    if( !isdefined( zombie.voicePrefix ) )
    	return; 
    
    alias = "zmb_vocals_" + zombie.voicePrefix + "_" + type;
    
    if( sndIsNetworkSafe() )
    {
	    if( ( isdefined( override ) && override ) )
	    {
	   		zombie PlaySound( alias );
	    }
	    else if( !( isdefined( zombie.talking ) && zombie.talking ) )
	    {
	        zombie.talking = true;
	        
	        zombie PlaySoundWithNotify( alias, "sounddone" );
	        zombie waittill( "sounddone" );
	        zombie.talking = false;
	    }
    }
}
function zmbAIVox_PlayDeath()
{
	self endon ( "disconnect" );
	
	self waittill ( "death", attacker, meansOfDeath );
	
	if ( isdefined( self ) )
	{	
		level thread zmbAIVox_PlayVox( self, "death", true );
	}
}
function zmbAI_PlaySprintVox()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	wait(randomfloatrange(1,3));
	
	while(1)
	{
		self notify( "bhtn_action_notify", "sprint" );
		wait(randomfloatrange(1.5,3));
	}
}
function networkSafeReset()
{
	while(1)
	{
		level._numZmbAIVox = 0;
		util::wait_network_frame();
	}
}
function sndIsNetworkSafe()
{
	if ( !IsDefined( level._numZmbAIVox ) )
	{
	 	level thread networkSafeReset();
	}

	if ( level._numZmbAIVox > 4 )
	{
	  	return false;
	}

	level._numZmbAIVox++;
	return true;
}


function Bonuszm_FollowPlayerMode() // self = AI
{
	self endon("death");
	self endon("Bonuszm_FollowPlayerMode_StopFollowing");
	
	self.goalradius = 600; // default follow radius
	
	self.nextMoveToPlayerUpdate = 0;
	
	while(1)
	{
		if( GetTime() > self.nextMoveToPlayerUpdate )
		{		
			if( Bonuszm_FollowPlayerPickPositionNearPlayer() )
			{
				self.nextMoveToPlayerUpdate = GetTime() + RandomIntRange(4000, 5000);
			}
			else
			{
				self.nextMoveToPlayerUpdate = GetTime() + RandomIntRange(2000, 3000);
			}			
		}
		
		wait 1;
	}
}


function private Bonuszm_FollowPlayerPickPositionNearPlayer()
{
	closestPlayer = level.players[0]; //FindClosest( self.origin, level.players );
	
	closestPositionOnNavmeshFromPlayer = GetClosestPointOnNavMesh( closestPlayer.origin, 400 );
	
	if( IsDefined( closestPositionOnNavmeshFromPlayer ) )
	{
		queryResult = PositionQuery_Source_Navigation(
			closestPositionOnNavmeshFromPlayer,
			0,
			self.goalradius,
			80,
			20,
			self );
		
		if( queryResult.data.size )
		{
			findPointNearPlayerTries = 0;
			
			while( findPointNearPlayerTries < 4 )
			{
				point = queryResult.data[ randomint( queryResult.data.size ) ];
				
				if( IsDefined(point) )
				{					
					self SetGoal( point.origin );
					return true;
				}		
				else
				{
					findPointNearPlayerTries++;
				}
				
				wait 0.5;
			}
		}
	}

	return false;	
}