#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_net;


init()
{
	level._CONTEXTUAL_GRAB_LERP_TIME = .3; // This is the time it takes to move into position for each bar.

	level.zombie_spawners = GetEntArray( "zombie_spawner", "script_noteworthy" ); 
	//level.screecher_spawners = GetEntArray("screecher_zombie_spawner","script_noteworthy");

	PrecacheModel( "p6_anim_zm_barricade_board_01_upgrade" );
	PrecacheModel( "p6_anim_zm_barricade_board_02_upgrade" );
	PrecacheModel( "p6_anim_zm_barricade_board_03_upgrade" );
	PrecacheModel( "p6_anim_zm_barricade_board_04_upgrade" );
	PrecacheModel( "p6_anim_zm_barricade_board_05_upgrade" );
	PrecacheModel( "p6_anim_zm_barricade_board_06_upgrade" );
	
	if ( IsDefined( level.ignore_spawner_func ) )
	{
		for ( i = 0; i < level.zombie_spawners.size; i++ )
		{
			ignore = [[ level.ignore_spawner_func ]]( level.zombie_spawners[i] );
			if ( ignore )
			{
				ArrayRemoveValue(level.zombie_spawners, level.zombie_spawners[i]);
			}
		}	
	}	
 	
 	gametype = GetDvar( "ui_gametype" );
 	if(!is_Encounter() || gametype == "zgrief" || gametype == "zturned" || gametype == "zpitted" )
 	{
		array_thread(level.zombie_spawners, ::add_spawn_function, ::zombie_spawn_init);
		array_thread(level.zombie_spawners, ::add_spawn_function, maps\mp\zombies\_zm::round_spawn_failsafe);
	}
 	
 	RegisterClientField("actor", "zombie_has_eyes", 1, "int");		
}

add_cusom_zombie_spawn_logic(func)
{
	if(!IsDefined(level._zombie_custom_spawn_logic))
	{
		level._zombie_custom_spawn_logic = [];
	}
	
	level._zombie_custom_spawn_logic[level._zombie_custom_spawn_logic.size] = func;
}



player_attacks_enemy( player, amount, type, point )
{
	team = undefined;
	if(isDefined(self._race_team))
	{
		team = self._race_team;
	}
	
	if ( !isADS(player) )
	{
		// defaults to empty_kill_func, for arcademode
		[[ level.global_damage_func ]]( type, self.damagelocation, point, player, amount, team );
		return false;
	}
		
	if ( !bullet_attack( type ) )
	{
		// defaults to empty_kill_func, for arcademode
		[[ level.global_damage_func ]]( type, self.damagelocation, point, player, amount, team );
		return false;
	}

	// defaults to empty_kill_func, for arcademode
	[[ level.global_damage_func_ads ]]( type, self.damagelocation, point, player, amount, team );
		
	return true;
}


player_attacker( attacker )
{
	if ( IsPlayer(attacker) )
	{
		return true;
	}
	return false;
}

enemy_death_detection()
{
	self endon ("death");
	
	for ( ;; )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type );
		if ( !isDefined(amount) )
		{
			continue;
		}

		if ( !isalive( self ) || self.delayeddeath )
		{
			return;
		}
		
		if ( !player_attacker( attacker ) )
		{
			continue;
		}
		
		self player_attacks_enemy( attacker, amount, type, point );
		
//t6todo		if( !isDefined( self ) || !isalive( self ) )
//t6todo		{
//t6todo			attacker.kills++;
//t6todo			return;
//t6todo		}
	}
}


is_spawner_targeted_by_blocker( ent )
{
	if( IsDefined( ent.targetname ) )
	{
		targeters = GetEntArray( ent.targetname, "target" );

		for( i = 0; i < targeters.size; i++ )
		{
			if( targeters[i].targetname == "zombie_door" || targeters[i].targetname == "zombie_debris" )
			{
				return true;
			}

			result = is_spawner_targeted_by_blocker( targeters[i] );
			if( result )
			{
				return true;
			}
		}
	}

	return false;
}

add_custom_zombie_spawn_logic(func)
{
	if(!IsDefined(level._zombie_custom_spawn_logic))
	{
		level._zombie_custom_spawn_logic = [];
	}
	
	level._zombie_custom_spawn_logic[level._zombie_custom_spawn_logic.size] = func;
}


// set up zombie walk cycles
zombie_spawn_init( animname_set )
{
	if( !isDefined( animname_set ) )
	{
		animname_set = false;
	}
	
	self.targetname = "zombie";
	self.script_noteworthy = undefined;

	if( !animname_set )
	{
		self.animname = "zombie"; 		
	}
	
	//pre-spawn gamemodule init
	self maps\mp\zombies\_zm_game_module::game_module_pre_zombie_spawn_init();
	
	self thread play_ambient_zombie_vocals();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	
	self.ignoreall = true; 
	self.ignoreme = true; // don't let attack dogs give chase until the zombie is in the playable area
	self.allowdeath = true; 			// allows death during animscripted calls
	self.force_gib = true; 		// needed to make sure this guy does gibs
	self.is_zombie = true; 			// needed for melee.gsc in the animscripts
	self.has_legs = true; 			// Sumeet - This tells the zombie that he is allowed to stand anymore or not, gibbing can take 
									// out both legs and then the only allowed stance should be prone.
	self allowedStances( "stand" ); 
	
	self.zombie_damaged_by_bar_knockdown = false; // This tracks when I can knock down a zombie with a bar

	self.gibbed = false; 
	self.head_gibbed = false;
	
	// might need this so co-op zombie players cant block zombie pathing
//	self PushPlayer( true ); 
//	self.meleeRange = 128; 
//	self.meleeRangeSq = anim.meleeRange * anim.meleeRange; 

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
	self disable_react(); // SUMEET - zombies dont use react feature.

	if ( isdefined( level.zombie_health ) )
	{
		self.maxhealth = level.zombie_health; 
		self.health = level.zombie_health; 
	}
	else
	{
		self.maxhealth = level.zombie_vars["zombie_health_start"]; 
		self.health = self.maxhealth; 
	}

	self.freezegun_damage = 0;

	self.dropweapon = false; 
	level thread zombie_death_event( self ); 

	// We need more script/code to get this to work properly
//	self add_to_spectate_list();
//	self random_tan(); 
	self set_zombie_run_cycle(); 
	self thread zombie_think(); 
	self thread zombie_gib_on_damage(); 
	self thread zombie_damage_failsafe();
	
	self thread enemy_death_detection();

	if(IsDefined(level._zombie_custom_spawn_logic))
	{
		if(IsArray(level._zombie_custom_spawn_logic))
		{
			for(i = 0; i < level._zombie_custom_spawn_logic.size; i ++)
			{
			self thread [[level._zombie_custom_spawn_logic[i]]]();
			}
		}
		else
		{
			self thread [[level._zombie_custom_spawn_logic]]();
		}
	}
	
	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		if ( !is_true( self.is_inert ) )
		{
			self thread delayed_zombie_eye_glow();	// delayed eye glow for ground crawlers (the eyes floated above the ground before the anim started)
		}
	}
	self.deathFunction = ::zombie_death_animscript;
	self.flame_damage_time = 0;

	self.meleeDamage = 60;	// 45
	self.no_powerups = true;
	
	self zombie_history( "zombie_spawn_init -> Spawned = " + self.origin );

	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	self.tesla_head_gib_func = ::zombie_tesla_head_gib;

	self.team = "axis";

	if ( isDefined(level.achievement_monitor_func) )
	{
		self [[level.achievement_monitor_func]]();
	}
		
	//gamemodule post init
	self maps\mp\zombies\_zm_game_module::game_module_post_zombie_spawn_init();

	if ( isDefined( level.zombie_init_done ) )
	{
		self [[ level.zombie_init_done ]]();
	}

	self.zombie_init_done = true;
	self notify( "zombie_init_done" );
}

/*
delayed_zombie_eye_glow:
Fixes problem where zombies that climb out of the ground are warped to their start positions
and their eyes glowed above the ground for a split second before their animation started even
though the zombie model is hidden. and applying this delay to all the zombies doesn't really matter.
*/
delayed_zombie_eye_glow()
{
	self endon("zombie_delete");

	if(is_true(self.in_the_ground))
	{
		while(!isdefined(self.create_eyes))
		{
			wait(0.1);
		}
	}
	else
	{
		wait .5;
	}
	self zombie_eye_glow();
}


zombie_damage_failsafe()
{
	self endon ("death");

	continue_failsafe_damage = false;	
	while (1)
	{
		//should only be for zombie exploits
		wait 0.5;
		
		if ( !isdefined( self.enemy ) || !IsPlayer( self.enemy ) )
		{
			continue;
		}
		
		if (self istouching(self.enemy))
		{
			old_org = self.origin;
			if (!continue_failsafe_damage)
			{
				wait 5;
			}
			
			//make sure player doesn't die instantly after getting touched by a zombie.
			if (!isdefined(self.enemy) || !IsPlayer( self.enemy ) || self.enemy hasperk("specialty_armorvest") /*|| self.enemy hasperk("specialty_armorvest_upgrade")*/)
			{
				continue;
			}
		
		
		if (self istouching(self.enemy) 
				&& !self.enemy maps\mp\zombies\_zm_laststand::player_is_in_laststand()
				&& isalive(self.enemy))
			{
				//TODO	THIS SHOULD NOT BE A PERMANENT FIX, ONLY TEMP TEST
				//MM -10/13/09  This distance used to be 35
				if (distancesquared(old_org, self.origin) < (60 * 60) ) 
				{
					self.enemy DoDamage( self.enemy.health + 1000, self.enemy.origin, self, self, "none", "MOD_RIFLE_BULLET" );
				
					continue_failsafe_damage = true;
				}
			}
		}
		else
		{
			continue_failsafe_damage = false;
		}
	}
}


should_skip_teardown( find_flesh_struct_string )
{
	// Riser who spawns in the playable area
	if( IsDefined(find_flesh_struct_string) && find_flesh_struct_string == "find_flesh" ) 
	{
		return true;
	}
	// Used on dogs...could be used on a zombie who spawns in and immediately chases player
	if( isDefined( self.script_string ) && self.script_string == "zombie_chaser" ) 
	{
		return true;
	}
	
	return false;
}

// JL 12/08/09 this is the main zombie think thread that starts when they spawn in
zombie_think()
{
	self endon( "death" ); 
	assert( !self.isdog );
	
	self.ai_state = "zombie_think";
	
	//node = level.exterior_goals[randomint( level.exterior_goals.size )]; 
	
	// MM - 5/8/9 Add ability for risers to find_flesh immediately after spawning if the
	//	rise struct has the script_noteworthy "find_flesh"
	find_flesh_struct_string = undefined;

	if ( IsDefined(level.zombie_custom_think_logic) )
	{
		shouldWait = self [[ level.zombie_custom_think_logic ]]();
		if ( shouldWait )
		{
			self waittill("zombie_custom_think_done", find_flesh_struct_string);
		}
	}
	else if ( is_true( self.start_inert ) )
	{
		find_flesh_struct_string = "find_flesh";
	}
	else
	{
		if ( isdefined( self.custom_location ) )
		{
			self thread [[ self.custom_location ]]();
		}
		else
		{
			// DCS 032612: find available structs to spawn at:
			self thread do_zombie_spawn();
		}
		self waittill("risen", find_flesh_struct_string );
	}
	
	node = undefined;

	desired_nodes = [];
	self.entrance_nodes = [];

	if ( IsDefined( level.max_barrier_search_dist_override ) )
	{
		max_dist = level.max_barrier_search_dist_override;
	}
	else
	{
		max_dist = 500;
	}

	if( !IsDefined(find_flesh_struct_string) && IsDefined( self.target ) && self.target != "" )
	{
		desired_origin = get_desired_origin();

		assert( IsDefined( desired_origin ), "Spawner @ " + self.origin + " has a .target but did not find a target" );
	
		origin = desired_origin;
			
		node = getclosest( origin, level.exterior_goals ); 	
		self.entrance_nodes[0] = node;

		self zombie_history( "zombie_think -> #1 entrance (script_forcegoal) origin = " + self.entrance_nodes[0].origin );
	}
	// JMA - this is used in swamp to spawn outdoor zombies and immediately rush the player
	// JMA - if riser becomes a non-riser, make sure they go to a barrier first instead of chasing a player
	else if ( self should_skip_teardown( find_flesh_struct_string ) )
	{
		self zombie_setup_attack_properties();
		//if the zombie has a target, make them go there first
		if (isDefined(self.target))
		{
			end_at_node = GetNode(self.target, "targetname");
			if (isDefined(end_at_node))
			{
				self setgoalnode (end_at_node);
				self waittill("goal");
			}
		}

		if ( is_true( self.start_inert ) )
		{
			self thread maps\mp\zombies\_zm_ai_basic::start_inert( true );
		}
		else
		{
			self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
		}
		self zombie_complete_emerging_into_playable_area();
		return;	
	}
	else
	{
		origin = self.origin;

		desired_origin = get_desired_origin();
		if( IsDefined( desired_origin ) )
		{
			origin = desired_origin;
		}

		// Get the 3 closest nodes
		// 
		nodes = get_array_of_closest( origin, level.exterior_goals, undefined, 3 );

		// Figure out the distances between them, if any of them are greater than 256 units compared to the previous, drop it
		desired_nodes[0] = nodes[0];
		prev_dist = Distance( self.origin, nodes[0].origin );
		for( i = 1; i < nodes.size; i++ )
		{
			dist = Distance( self.origin, nodes[i].origin );
			if( ( dist - prev_dist ) > max_dist )
			{
				break;
			}

			prev_dist = dist;
			desired_nodes[i] = nodes[i];
		}

		node = desired_nodes[0];
		if( desired_nodes.size > 1 )
		{
			node = desired_nodes[RandomInt(desired_nodes.size)];
		}

		self.entrance_nodes = desired_nodes;

		self zombie_history( "zombie_think -> #1 entrance origin = " + node.origin );

		// Incase the guy does not move from spawn, then go to the closest one instead
		self thread zombie_assure_node();
	}

	assert( IsDefined( node ), "Did not find a node!!! [Should not see this!]" );

	level thread draw_line_ent_to_pos( self, node.origin, "goal" );
	
	self.first_node = node; // This is the first locatin the zombies go to
	
	// what is the zombies goal radius at this point
	self thread zombie_goto_entrance( node ); // sends the zombie to the node right in front of the window
}

get_desired_origin()
{
	if( IsDefined( self.target ) )
	{
		ent = GetEnt( self.target, "targetname" );
		if( !IsDefined( ent ) )
		{
			ent = getstruct( self.target, "targetname" );
		}
	
		if( !IsDefined( ent ) )
		{
			ent = GetNode( self.target, "targetname" );
		}
	
		assert( IsDefined( ent ), "Cannot find the targeted ent/node/struct, \"" + self.target + "\" at " + self.origin );
	
		return ent.origin;
	}

	return undefined;
}

zombie_goto_entrance( node, endon_bad_path )
{
	assert( !self.isdog );
	
	self endon( "death" );
	self endon( "stop_zombie_goto_entrance" );
	level endon( "intermission" );

	self.ai_state = "zombie_goto_entrance";

	if( IsDefined( endon_bad_path ) && endon_bad_path )
	{
		// If we cannot go to the goal, then end...
		// Used from find_flesh
		self endon( "bad_path" );
	}



	self zombie_history( "zombie_goto_entrance -> start goto entrance " + node.origin );

	self.got_to_entrance = false;
	
	
	
	// This is the goal radius while the zombies search for a window to attack
	self.goalradius = 128; 
	self SetGoalPos( node.origin );
	self waittill( "goal" ); 
	self.got_to_entrance = true;

	self zombie_history( "zombie_goto_entrance -> reached goto entrance " + node.origin );

	// Guy should get to goal and tear into building until all barrier chunks are gone
	// They go into this function and do everything they and then comeback once all the barriers are removed
	self tear_into_building();
		
	//REMOVED THIS, WAS CAUSING ISSUES
	if(isDefined(self.first_node.clip))
	{
		if(!isDefined(self.first_node.clip.disabled) || !self.first_node.clip.disabled)// This was commented out
		{ // This was commented out
			self.first_node.clip disable_trigger();// This was commented out
			self.first_node.clip connectpaths();
			//IPrintLnBold( "Connecting Paths" );
		}// This was commented out
	}
	else
	{
		blocker_connect_paths(self.first_node.neg_start, self.first_node.neg_end);
	}
	
	// Here is where the zombie would play the traversal into the building( if it's a window )
	// and begin the player seek logic
	//IPrintLnBold("zombie going to attack mode");
	self zombie_setup_attack_properties();
	
	if( isDefined( level.pre_aggro_pathfinding_func ) )
	{
		self [[ level.pre_aggro_pathfinding_func ]]();
	}
	
	self thread maps\mp\zombies\_zm_ai_basic::find_flesh();
	self.pathEnemyFightDist = 4;	// make sure zombie gets out of the window

	// wait for them to traverse out of the spawn closet
	self waittill( "zombie_start_traverse" );
	self waittill( "zombie_end_traverse" );
	self zombie_complete_emerging_into_playable_area();
	self.pathEnemyFightDist = 64;	// restore
}

// Here the zombies constantly search 
zombie_assure_node()
{
	self endon( "death" );
	self endon( "goal" );
	level endon( "intermission" );

	start_pos = self.origin;
	if(IsDefined(self.entrance_nodes))
	{
		for( i = 0; i < self.entrance_nodes.size; i++ )
		{
			if( self zombie_bad_path() )
			{
				self zombie_history( "zombie_assure_node -> assigned assured node = " + self.entrance_nodes[i].origin );
	
			/#	println( "^1Zombie @ " + self.origin + " did not move for 1 second. Going to next closest node @ " + self.entrance_nodes[i].origin );	#/
				level thread draw_line_ent_to_pos( self, self.entrance_nodes[i].origin, "goal" );
				self.first_node = self.entrance_nodes[i];
				self SetGoalPos( self.entrance_nodes[i].origin );
			}
			else
			{
				return;
			}
		}
	}		
	// CHRISP - must add an additional check, since the 'self.entrance_nodes' array is not dynamically updated to accomodate for entrance points that can be turned on and off
	// only do this if it's the asylum map
	wait(2);
	// Get more nodes and try again
	nodes = get_array_of_closest( self.origin, level.exterior_goals, undefined, 20 );
	if(IsDefined(nodes))
	{
		self.entrance_nodes = nodes;
		for( i = 0; i < self.entrance_nodes.size; i++ )
		{
			if( self zombie_bad_path() )
			{
				self zombie_history( "zombie_assure_node -> assigned assured node = " + self.entrance_nodes[i].origin );
	
			/#	println( "^1Zombie @ " + self.origin + " did not move for 1 second. Going to next closest node @ " + self.entrance_nodes[i].origin );	#/
				level thread draw_line_ent_to_pos( self, self.entrance_nodes[i].origin, "goal" );
				self.first_node = self.entrance_nodes[i];
				self SetGoalPos( self.entrance_nodes[i].origin );
			}
			else
			{
				return;
			}
		}
	}	

	self zombie_history( "zombie_assure_node -> failed to find a good entrance point" );
	
	//assertmsg( "^1Zombie @ " + self.origin + " did not find a good entrance point... Please fix pathing or Entity setup" );
	wait(20);
	//iprintln( "^1Zombie @ " + self.origin + " did not find a good entrance point... Please fix pathing or Entity setup" );
	self DoDamage( self.health + 10, self.origin );
	
//	//add this zombie back into the spawner queue to be re-spawned
//	if(is_true(level.put_timed_out_zombies_back_in_queue ))
//	{
//		level.zombie_total++;	
//	}
	
	//add this to the stats even tho he really didn't 'die' 
	level.zombies_timeout_spawn++;
	
}

zombie_bad_path()
{
	self endon( "death" );
	self endon( "goal" );

	self thread zombie_bad_path_notify();
	self thread zombie_bad_path_timeout();

	self.zombie_bad_path = undefined;
	while( !IsDefined( self.zombie_bad_path ) )
	{
		wait( 0.05 );
	}

	self notify( "stop_zombie_bad_path" );

	return self.zombie_bad_path;
}

zombie_bad_path_notify()
{
	self endon( "death" );
	self endon( "stop_zombie_bad_path" );

	self waittill( "bad_path" );
	self.zombie_bad_path = true;
}

zombie_bad_path_timeout()
{
	self endon( "death" );
	self endon( "stop_zombie_bad_path" );

	wait( 2 );
	self.zombie_bad_path = false;
}


// This controls the zombies breaking into the building.
// Self is a specific zombie
// Node is the player's origin
tear_into_building()
{
	self endon( "death" ); // this is a zombie
	self endon("teleporting");

	self zombie_history( "tear_into_building -> start" ); // update history that they have started to tear in 

	while( 1 )
	{
		//also check
	//if( IsDefined( self.first_node)
	//{
		
		if( IsDefined( self.first_node.script_noteworthy ) )
		{
			if( self.first_node.script_noteworthy == "no_blocker" )
			{
				return; // if no blocker checks out ok... then allow the zombie to connect paths
			}
		}

		if( !IsDefined( self.first_node.target ) )
		{
			return;
		}

		// barrier_chunks is the exterior_goal that has all the bars and boards connected to it.
		// remember all_chunks_destroyed is in utility script _zombie_utility
		if( all_chunks_destroyed( self.first_node, self.first_node.barrier_chunks ) ) // If barrier_chunks status says all chunks are destroyed then continue
		{
			// latest
			// Send this notify but only accept the first time it comes through.
			self zombie_history( "tear_into_building -> all chunks destroyed" ); // Enter the building if all chunks are gone. This is threaded for each zombie
		}

		// If an attacking_spot is availiable then they well grab one, if not they taunt.
		// Jluyties (02/04/10)Added the ability for zombies to taunt while they wait to attack a window 
		if( !get_attack_spot( self.first_node ) )
		{
			self zombie_history( "tear_into_building -> Could not find an attack spot" );
			//Print3d(self.origin+(0,0,70), "Hey I am waiting to attack, play random " );
			//Print3d(self.origin+(0,0,70), "Hey I am waiting to attack", ( 1, 0.8, 0.5), 1, 1, 5);
			//IPrintLnBold( "Hey I am waiting to attack " );
			self thread  do_a_taunt();
			wait( 0.5 );
			continue;
		}
		
		// This is where the zombie moves into position to tear down a board/bar
		self.goalradius = 2;
		//self maps\_zombiemode_utility:: lerp( chunk );

		angles = self.first_node.zbarrier.angles;
		
		self SetGoalPos( self.attacking_spot, angles );
		attacking_spot1a = self.attacking_spot; //I grab the origIn of the attacking_spot that is an one of 3 of an index
		self waittill( "goal" );
		//	MM- 05/09
		//	If you wait for "orientdone", you NEED to also have a timeout.
		//	Otherwise, zombies could get stuck waiting to do their facing.
		self waittill_notify_or_timeout( "orientdone", 1 );

		self zombie_history( "tear_into_building -> Reach position and orientated" );		

		// chrisp - do one final check to make sure that the boards are still torn down
		// this *mostly* prevents the zombies from coming through the windows as you are boarding them up. 
		if( all_chunks_destroyed( self.first_node, self.first_node.barrier_chunks ) )
		{
			self zombie_history( "tear_into_building -> all chunks destroyed" );
			for( i = 0; i < self.first_node.attack_spots_taken.size; i++ )
			{
				self.first_node.attack_spots_taken[i] = false;
			}
			return;
		}
	//}
	
		// Now tear down boards
		while( 1 )
		{
			if ( isDefined( self.zombie_board_tear_down_callback ) )
			{
				self [[self.zombie_board_tear_down_callback]]();
			}

			// get_closest_non_destroyed_chunk calls into _zombiemode_utility and returns if any chunks are still there
			chunk = get_closest_non_destroyed_chunk( self.origin, self.first_node, self.first_node.barrier_chunks );

			if ( !IsDefined( chunk ) )
			{
				if( !all_chunks_destroyed( self.first_node, self.first_node.barrier_chunks ) )
				{
					attack = self should_attack_player_thru_boards();
					if(isDefined(attack) && !attack && self.has_legs)
					{
						self do_a_taunt();
					}
					else
					{
						wait_network_frame();
					}
					continue;
				}


				for( i = 0; i < self.first_node.attack_spots_taken.size; i++ )
				{
					self.first_node.attack_spots_taken[i] = false;
				}
				return; 
			}

			self zombie_history( "tear_into_building -> animating" );
			
			self.first_node.zbarrier SetZBarrierPieceState(chunk, "targetted_by_zombie");
			self.first_node thread check_zbarrier_piece_for_zombie_inert(chunk, self.first_node.zbarrier, self);
			self.first_node thread check_zbarrier_piece_for_zombie_death(chunk, self.first_node.zbarrier, self);
			
			self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "teardown", self.animname );

			animStateBase = self.first_node.zbarrier GetZBarrierPieceAnimState(chunk);
			animSubState = "spot_" + self.attacking_spot_index + "_piece_" + self.first_node.zbarrier GetZBarrierPieceAnimSubState(chunk);
			
			anim_sub_index	= self GetAnimSubStateFromASD( animStateBase + "_in", animSubState );
			
            self AnimScripted( self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, maps\mp\animscripts\zm_utility::append_missing_legs_suffix( animStateBase + "_in" ), anim_sub_index );
            self zombie_tear_notetracks( "tear_anim", chunk, self.first_node );
			
			while(0 < self.first_node.zbarrier.chunk_health[chunk])
			{
				self AnimScripted( self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, maps\mp\animscripts\zm_utility::append_missing_legs_suffix( animStateBase + "_loop" ), anim_sub_index );
				self zombie_tear_notetracks( "tear_anim", chunk, self.first_node );

        		self.first_node.zbarrier.chunk_health[chunk]--;
			}
			
            self AnimScripted( self.first_node.zbarrier.origin, self.first_node.zbarrier.angles, maps\mp\animscripts\zm_utility::append_missing_legs_suffix( animStateBase + "_out" ), anim_sub_index );
            self zombie_tear_notetracks( "tear_anim", chunk, self.first_node );				
			
            attack = self should_attack_player_thru_boards();
            if ( isDefined( attack ) && !attack && self.has_legs )
            {
                self do_a_taunt();
            }                

			//chrisp - fix the extra tear anim bug
			if ( all_chunks_destroyed( self.first_node, self.first_node.barrier_chunks ) )
			{
				for( i = 0; i < self.first_node.attack_spots_taken.size; i++ )
				{
					self.first_node.attack_spots_taken[i] = false;
				}
				return;
			}	
		}
		
		self reset_attack_spot();
	}		
}


/*------------------------------------
checks to see if the zombie should 
do a taunt when tearing thru the boards
------------------------------------*/
do_a_taunt()
{
	self endon ("death"); // Jluyties 02/16/10 added death check, cause of crash 
	if( !self.has_legs)
	{
		return false;
	}

	if(!self.first_node.zbarrier ZBarrierSupportsZombieTaunts())
	{
		return;
	}
	
	self.old_origin = self.origin;
	if(GetDvar( "zombie_taunt_freq") == "")
	{
		SetDvar("zombie_taunt_freq","5");
	}
	freq = GetDvarInt( "zombie_taunt_freq");
	
	if( freq >= randomint(100) )
	{
		self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "taunt", self.animname );
		
		tauntState = "zm_taunt";
		
		if(isdefined(self.first_node.zbarrier) && self.first_node.zbarrier GetZBarrierTauntAnimState() != "")
		{
			tauntState = self.first_node.zbarrier GetZBarrierTauntAnimState();
		}
		
		self animscripted( self.origin, self.angles, tauntState );
		self taunt_notetracks( "taunt_anim" );
	}
}

taunt_notetracks(msg)
{
	self endon("death");

	while(1)
	{
		self waittill( msg, notetrack );

		if( notetrack == "end" )
		{
			self ForceTeleport(self.old_origin);

			return;
		}
	}
}
/*------------------------------------
checks to see if the players are near
the entrance and tries to attack them 
thru the boards. 50% chance
Self is a zombie
------------------------------------*/
should_attack_player_thru_boards()
{

	//no board attacks if they are crawlers
	if( !self.has_legs)
	{
		return false;
	}
	
	if(isdefined(self.first_node.zbarrier))
	{
		if(!self.first_node.zbarrier ZBarrierSupportsZombieReachThroughAttacks())
		{
			return false;
		}
	}
	
	if(GetDvar( "zombie_reachin_freq") == "")
	{
		SetDvar("zombie_reachin_freq","50");
	}
	freq = GetDvarInt( "zombie_reachin_freq");
	
	players = GET_PLAYERS();
	attack = false;

    self.player_targets = [];
    for(i=0;i<players.size;i++)
    {
        if ( isAlive( players[i] ) && !isDefined( players[i].revivetrigger ) && distance2d( self.origin, players[i].origin ) <= 90 )
        {
            self.player_targets[self.player_targets.size] = players[i];
            attack = true;
        }
    }

    if ( !attack || freq < randomint(100) )
	{
		return false;	
	}

	self.old_origin = self.origin;

	attackAnimState = "zm_window_melee";
	
	if(isdefined(self.first_node.zbarrier) && self.first_node.zbarrier GetZBarrierReachThroughAttackAnimState() != "")
	{
		attackAnimState = self.first_node.zbarrier GetZBarrierReachThroughAttackAnimState();
	}
	
	// index 0 is center, index 2 is left and index 1 is the right, so (0 - 1) results in randomizing between both options
	self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "attack", self.animname );
	self AnimScripted( self.origin, self.angles, attackAnimState, self.attacking_spot_index - 1 ); 
	self window_notetracks( "window_melee_anim" );

	return true;
}

window_notetracks(msg)
{
	self endon("death");

	while(1)
	{
		self waittill( msg, notetrack );

		if( notetrack == "end" )
		{
			//self waittill("end");
			self teleport(self.old_origin);

			return;
		}
		if( notetrack == "fire" )
		{
			if(self.ignoreall)
			{
				self.ignoreall = false;
			}

			// just hit a player
			if ( isDefined( self.first_node ) )
			{
				_MELEE_DIST_SQ = 90*90;
				_TRIGGER_DIST_SQ = 51*51;

				for ( i = 0; i < self.player_targets.size; i++ )
				{
					playerDistSq = Distance2DSquared( self.player_targets[i].origin, self.origin );
					heightDiff = abs( self.player_targets[i].origin[2] - self.origin[2] ); // be sure we're on the same floor
					if ( playerDistSq < _MELEE_DIST_SQ && (heightDiff * heightDiff) < _MELEE_DIST_SQ )
					{
						triggerDistSq = Distance2DSquared( self.player_targets[i].origin, self.first_node.trigger_location.origin );
						heightDiff = abs( self.player_targets[i].origin[2] - self.first_node.trigger_location.origin[2] ); // be sure we're on the same floor
						if ( triggerDistSq < _TRIGGER_DIST_SQ && (heightDiff * heightDiff) < _TRIGGER_DIST_SQ )
						{
							self.player_targets[i] DoDamage( self.meleeDamage, self.origin, self, self, "none", "MOD_MELEE" );
							break;
						}
					}
				}
			}
			else
			{
				self melee();
			}
		}
	}
}

reset_attack_spot()
{
	if( IsDefined( self.attacking_node ) )
	{
		node = self.attacking_node;
		index = self.attacking_spot_index;
		node.attack_spots_taken[index] = false;

		self.attacking_node = undefined;
		self.attacking_spot_index = undefined;
	}
}

get_attack_spot( node )
{
	index = get_attack_spot_index( node );
	if( !IsDefined( index ) )
	{
		return false;
	}

	self.attacking_node = node;
	self.attacking_spot_index = index;
	node.attack_spots_taken[index] = true;
	self.attacking_spot = node.attack_spots[index];

	return true;
}

get_attack_spot_index( node )
{
	indexes = [];
	for( i = 0; i < node.attack_spots.size; i++ )
	{
		if( !node.attack_spots_taken[i] )
		{
			indexes[indexes.size] = i;
		}
	}

	if( indexes.size == 0 )
	{
		return undefined;
	}

	return indexes[RandomInt( indexes.size )];
}

// Self is zombie
zombie_tear_notetracks( msg, chunk, node )
{
	self endon("death");
	
	while( 1 )
	{
		self waittill( msg, notetrack );

		if ( notetrack == "end" )
		{
			return;
		}
		
		if ( notetrack == "board" || notetrack == "destroy_piece" || notetrack == "bar")
		{
			node.zbarrier SetZBarrierPieceState(chunk, "opening");
		}
	}
}

// jl I am doing this so I can have an offset of timing for when the chunks come off to give it more life
// 0.8 is too long
// need to offset sound
// need to add this to the boards
zombie_boardtear_offset_fx_horizontle( chunk, node )
{
	// DCS 090110: fx for breaking out glass or wall.
	if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "repair_board"  || chunk.script_parameters == "board") )
	{
		if(IsDefined(chunk.unbroken) && chunk.unbroken == true)
		{ 
			if(IsDefined(chunk.material) && chunk.material == "glass")
			{
				PlayFX( level._effect["glass_break"], chunk.origin, node.angles );
				chunk.unbroken = false;
			}
			else if(IsDefined(chunk.material) && chunk.material == "metal")
			{
				PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin );
				chunk.unbroken = false;
			}
			else if(IsDefined(chunk.material) && chunk.material == "rock")
			{
				if(	is_true(level.use_clientside_rock_tearin_fx))
				{
					chunk setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX);
				}
				else
				{
					PlayFX( level._effect["wall_break"], chunk.origin );
				}
				chunk.unbroken = false;
			}
		}
	}
	if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "barricade_vents" ) )
	{
		if(	is_true(level.use_clientside_board_fx))
		{
			chunk setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_HORIZONTAL_FX);
		}
		else
		{
			PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin );
		}
	}	
	else if(IsDefined(chunk.material) && chunk.material == "rock")
	{
		if(	is_true(level.use_clientside_rock_tearin_fx))
		{
			chunk setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX);
		}
	}
			
	else
	{	
		if(isDefined(level.use_clientside_board_fx))
		{
			chunk setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_HORIZONTAL_FX);
		}
		else
		{
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, 30));
			wait( randomfloatrange( 0.2, 0.4 ));
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (0, 0, -30));
		}	
	}
}

zombie_boardtear_offset_fx_verticle( chunk, node )
{
	// DCS 090110: fx for breaking out glass or wall.
	if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "repair_board"  || chunk.script_parameters == "board") )
	{
		if(IsDefined(chunk.unbroken) && chunk.unbroken == true)
		{ 
			if(IsDefined(chunk.material) && chunk.material == "glass")
			{
				PlayFX( level._effect["glass_break"], chunk.origin, node.angles );
				chunk.unbroken = false;
			}
			else if(IsDefined(chunk.material) && chunk.material == "metal")
			{
				PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin );
				chunk.unbroken = false;
			}
			else if(IsDefined(chunk.material) && chunk.material == "rock")
			{
				if(	is_true(level.use_clientside_rock_tearin_fx))
				{
					chunk setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX);
				}
				else
				{
					PlayFX( level._effect["wall_break"], chunk.origin );
				}
				chunk.unbroken = false;
			}
		}
	}
	if ( IsDefined( chunk.script_parameters ) && ( chunk.script_parameters == "barricade_vents" ) )
	{
		if(isDefined(level.use_clientside_board_fx))
		{
			chunk setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_VERTICAL_FX);
		}
		else
		{
			PlayFX( level._effect["fx_zombie_bar_break"], chunk.origin );
		}
	}	
	else if(IsDefined(chunk.material) && chunk.material == "rock")
	{
		if(	is_true(level.use_clientside_rock_tearin_fx))
		{
			chunk setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_ROCK_FX);
		}
	}			
	else	
	{		
		if(isDefined(level.use_clientside_board_fx))
		{
			chunk setclientflag(level._ZOMBIE_SCRIPTMOVER_FLAG_BOARD_VERTICAL_FX);
		}
		else
		{
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (30, 0, 0));
			wait( randomfloatrange( 0.2, 0.4 ));
			PlayFx( level._effect["wood_chunk_destory"], chunk.origin + (-30, 0, 0));
		}
	}
}


zombie_bartear_offset_fx_verticle( chunk )
{
	if ( IsDefined ( chunk.script_parameters ) && ( chunk.script_parameters == "bar" ) || ( chunk.script_noteworthy == "board" ))
	{
		// array random grab for fx		
		//point = points[i];
		possible_tag_array_1 = [];
		possible_tag_array_1[0] = "Tag_fx_top";
		possible_tag_array_1[1] = "";
		possible_tag_array_1[2] = "Tag_fx_top";
		possible_tag_array_1[3] = "";

		possible_tag_array_2 = [];
		possible_tag_array_2[0] = "";
		possible_tag_array_2[1] = "Tag_fx_bottom";
		possible_tag_array_2[2] = "";
		possible_tag_array_2[3] = "Tag_fx_bottom";
		// now I need a random int between 0 and 3
		possible_tag_array_2 = array_randomize( possible_tag_array_2 );

		random_fx = [];
		random_fx[0] = level._effect["fx_zombie_bar_break"];
		random_fx[1] = level._effect["fx_zombie_bar_break_lite"];
		random_fx[2] = level._effect["fx_zombie_bar_break"];
		random_fx[3] = level._effect["fx_zombie_bar_break_lite"];
		// now I need a random int between 0 and 3
		random_fx = array_randomize( random_fx );   

		switch( randomInt( 9 ) ) // This sets up random versions of the bars being pulled apart for variety
		{
			case 0:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;

			case 1:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;

			case 2:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;

			case 3:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;

			case 4:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;

			case 5:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_top" );
				break;
			case 6:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_bottom" );
				break;
			case 7:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_top" );
				break;
			case 8:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_bottom" );
				break;
		} 
	}
}

//jl I am doing this so I can have an offset of timing for when the chunks come off to give it more life
zombie_bartear_offset_fx_horizontle( chunk )
{
	if ( IsDefined ( chunk.script_parameters ) && ( chunk.script_parameters == "bar" ) || ( chunk.script_noteworthy == "board" ))
	{
		switch( randomInt( 10 ) ) // This sets up random versions of the bars being pulled apart for variety
		{
			case 0:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
			break;
				
			case 1:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
			break;
				
			case 2:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
			break;
				
			case 3:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
			break;
				
			case 4:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
							wait( randomfloatrange( 0.0, 0.3 ));
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
			break;
				
			case 5:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_left" );
			break;
			case 6:
							PlayFXOnTag( level._effect["fx_zombie_bar_break_lite"], chunk, "Tag_fx_right" );
			break;
			case 7:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
			break;
			case 8:
							PlayFXOnTag( level._effect["fx_zombie_bar_break"], chunk, "Tag_fx_right" );
			break;
		} 
	}
}  

check_zbarrier_piece_for_zombie_inert(chunk_index, zbarrier, zombie)
{
	zombie endon( "completed_emerging_into_playable_area" );

	zombie waittill( "stop_zombie_goto_entrance" );

	if ( zbarrier GetZBarrierPieceState(chunk_index) == "targetted_by_zombie" )
	{
		zbarrier SetZBarrierPieceState(chunk_index, "closed");
	}
}

check_zbarrier_piece_for_zombie_death(chunk_index, zbarrier, zombie)
{
	while(1)
	{
		if(zbarrier GetZBarrierPieceState(chunk_index) != "targetted_by_zombie")
		{
			return;
		}
		
		if(!isdefined(zombie) || !IsAlive(zombie))
		{
			zbarrier SetZBarrierPieceState(chunk_index, "closed");
			return;
		}
		
		wait(0.05);
	}
}

check_for_zombie_death(zombie)
{
	self endon("destroyed");
	
	wait(2.5);
	self maps\mp\zombies\_zm_blockers::update_states("repaired");
}


zombie_head_gib( attacker, means_of_death )
{
	self endon( "death" );

	if ( !is_mature() )
	{
		return false;
	}

	if ( is_german_build() )
	{
		return;
	}

	if( IsDefined( self.head_gibbed ) && self.head_gibbed )
	{
		return;
	}
	
	self.head_gibbed = true;
	
	self zombie_eye_glow_stop();

	size = self GetAttachSize(); 
	for( i = 0; i < size; i++ )
	{
		model = self GetAttachModelName( i ); 
		if( IsSubStr( model, "head" ) )
		{
			// SRS 9/2/2008: wet em up
//			self thread headshot_blood_fx();
			if(isdefined(self.hatmodel))
			{
				self detach( self.hatModel, "" ); 
			}

			self play_sound_on_ent( "zombie_head_gib" );
			
			self Detach( model, "" ); 
			if ( isDefined(self.torsoDmg5) )
			{
				self Attach( self.torsoDmg5, "", true ); 
			}
			break; 
		}
	}

	temp_array = [];
	temp_array[0] = level._ZOMBIE_GIB_PIECE_INDEX_HEAD;
	self gib( "normal", temp_array );

	self thread damage_over_time( self.health * 0.2, 1, attacker, means_of_death );
}

damage_over_time( dmg, delay, attacker, means_of_death )
{
	self endon( "death" );

	if( !IsAlive( self ) )
	{
		return;
	}

	if( !IsPlayer( attacker ) )
	{
		attacker = undefined;
	}

	while( 1 )
	{
		if( IsDefined( delay ) )
		{
			wait( delay );
		}

		self DoDamage( dmg, self.origin, attacker, self, self.damagelocation, means_of_death, 0, self.damageweapon );
	}
}

// SRS 9/2/2008: reordered checks, added ability to gib heads with airburst grenades
head_should_gib( attacker, type, point )
{
	if ( !is_mature() )
	{
		return false;
	}
	
	if ( is_german_build() )
	{
		return false;
	}

	if( self.head_gibbed )
	{
		return false;
	}

	// check if the attacker was a player
	if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
	{
		return false; 
	}

	// check the enemy's health
	low_health_percent = ( self.health / self.maxhealth ) * 100; 
	if( low_health_percent > 10 )
	{
		return false; 
	}

	weapon = attacker GetCurrentWeapon(); 


	// SRS 9/2/2008: check for damage type
	//  - most SMGs use pistol bullets
	//  - projectiles = rockets, raygun
	if( type != "MOD_RIFLE_BULLET" && type != "MOD_PISTOL_BULLET" )
	{
		// maybe it's ok, let's see if it's a grenade
		if( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" )
		{
			if( Distance( point, self GetTagOrigin( "j_head" ) ) > 55 )
			{
				return false;
			}
			else
			{
				// the grenade airburst close to the head so return true
				return true;
			}
		}
		else if( type == "MOD_PROJECTILE" )
		{
			if( Distance( point, self GetTagOrigin( "j_head" ) ) > 10 )
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		// shottys don't give a testable damage type but should still gib heads
		else if( WeaponClass( weapon ) != "spread" )
		{
			return false; 
		}
	}

	// check location now that we've checked for grenade damage (which reports "none" as a location)
	if ( !self maps\mp\animscripts\zm_utility::damageLocationIsAny( "head", "helmet", "neck" ) )
	{
		return false; 
	}

	// check weapon - don't want "none", base pistol, or flamethrower
	if( weapon == "none"  || weapon == level.start_weapon || WeaponIsGasWeapon( self.weapon ) )
	{
		return false; 
	}

	return true; 
}

// does blood fx for fun and to mask head gib swaps
headshot_blood_fx()
{
	if( !IsDefined( self ) )
	{
		return;
	}

	if( !is_mature() )
	{
		return;
	}

	fxTag = "j_neck";
	fxOrigin = self GetTagOrigin( fxTag );
	upVec = AnglesToUp( self GetTagAngles( fxTag ) );
	forwardVec = AnglesToForward( self GetTagAngles( fxTag ) );
	
	// main head pop fx
	PlayFX( level._effect["headshot"], fxOrigin, forwardVec, upVec );
	PlayFX( level._effect["headshot_nochunks"], fxOrigin, forwardVec, upVec );
	
	wait( 0.3 );
	if(IsDefined( self ))
	{
		if( self maps\mp\zombies\_zm_weap_tesla::enemy_killed_by_tesla() )
		{
			PlayFxOnTag( level._effect["tesla_head_light"], self, fxTag );
		}
		else
		{
			PlayFxOnTag( level._effect["bloodspurt"], self, fxTag );
		}
	}
}


// gib limbs if enough firepower occurs
zombie_gib_on_damage()
{
//	self endon( "death" ); 

	while( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type ); 

		if( !IsDefined( self ) )
		{
			return;
		}

		if( !self zombie_should_gib( amount, attacker, type ) )
		{
			continue; 
		}

		if( self head_should_gib( attacker, type, point ) && type != "MOD_BURNED" )
		{
			self zombie_head_gib( attacker, type );
			attacker.headshots++;
			//stats tracking
			attacker maps\mp\zombies\_zm_stats::increment_client_stat( "headshots" );
			attacker maps\mp\zombies\_zm_stats::increment_client_stat( "gibs" );

			continue;
		}

		if( !self.gibbed )
		{
			// The head_should_gib() above checks for this, so we should not randomly gib if shot in the head
			if ( self maps\mp\animscripts\zm_utility::damageLocationIsAny( "head", "helmet", "neck" ) )
			{
				continue;
			}

			refs = []; 
			switch( self.damageLocation )
			{
				case "torso_upper":
				case "torso_lower":
					// HACK the torso that gets swapped for guts also removes the left arm
					//  so we need to sometimes do another ref
					refs[refs.size] = "guts"; 
					refs[refs.size] = "right_arm";
					break; 
	
				case "right_arm_upper":
				case "right_arm_lower":
				case "right_hand":
					//if( IsDefined( self.left_arm_gibbed ) )
					//	refs[refs.size] = "no_arms"; 
					//else
					refs[refs.size] = "right_arm"; 
	
					//self.right_arm_gibbed = true; 
					break; 
	
				case "left_arm_upper":
				case "left_arm_lower":
				case "left_hand":
					//if( IsDefined( self.right_arm_gibbed ) )
					//	refs[refs.size] = "no_arms"; 
					//else
					refs[refs.size] = "left_arm"; 
	
					//self.left_arm_gibbed = true; 
					break; 
	
				case "right_leg_upper":
				case "right_leg_lower":
				case "right_foot":
					if( self.health <= 0 )
					{
						// Addition "right_leg" refs so that the no_legs happens less and is more rare
						refs[refs.size] = "right_leg";
						refs[refs.size] = "right_leg";
						refs[refs.size] = "right_leg";
						refs[refs.size] = "no_legs"; 
					}
					break; 
	
				case "left_leg_upper":
				case "left_leg_lower":
				case "left_foot":
					if( self.health <= 0 )
					{
						// Addition "left_leg" refs so that the no_legs happens less and is more rare
						refs[refs.size] = "left_leg";
						refs[refs.size] = "left_leg";
						refs[refs.size] = "left_leg";
						refs[refs.size] = "no_legs";
					}
					break; 
			default:
				
				if( self.damageLocation == "none" )
				{
					// SRS 9/7/2008: might be a nade or a projectile
					if( type == "MOD_GRENADE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE" || type == "MOD_PROJECTILE_SPLASH" )
					{
						// ... in which case we have to derive the ref ourselves
						refs = self derive_damage_refs( point );
						break;
					}
				}
				else
				{
					refs[refs.size] = "guts";
					refs[refs.size] = "right_arm"; 
					refs[refs.size] = "left_arm"; 
					refs[refs.size] = "right_leg"; 
					refs[refs.size] = "left_leg"; 
					refs[refs.size] = "no_legs"; 
					break; 
				}
			}

			if( refs.size )
			{
				self.a.gib_ref = maps\mp\animscripts\zm_death::get_random( refs ); 

				// Don't stand if a leg is gone
				if( ( self.a.gib_ref == "no_legs" || self.a.gib_ref == "right_leg" || self.a.gib_ref == "left_leg" ) && self.health > 0 )
				{
					self.has_legs = false;
					self AllowedStances( "crouch" ); 
										
					// reduce collbox so player can jump over
					self setPhysParams( 15, 0, 24 );
					
					health = self.health;
					health = health * 0.1;
					
					self.needs_run_update = true;

					if ( isdefined( self.crawl_anim_override ) )
					{
						self [[ self.crawl_anim_override ]]();
					}					
				}
			}

			if( self.health > 0 )
			{
				// force gibbing if the zombie is still alive
				self thread maps\mp\animscripts\zm_death::do_gib();

				//stat tracking
				if ( IsPlayer( self ) )
				{
					attacker maps\mp\zombies\_zm_stats::increment_client_stat( "gibs" );
				}
			}
		}
	}
}


zombie_should_gib( amount, attacker, type )
{
	if ( !is_mature() )
	{
		return false;
	}
	
	if ( is_german_build() )
	{
		return false;
	}

	if( !IsDefined( type ) )
	{
		return false; 
	}

	if ( IsDefined( self.no_gib ) && ( self.no_gib == 1 ) )
	{
		return false;
	}

	if ( self maps\mp\zombies\_zm_weap_freezegun::is_freezegun_damage( type ) )
	{
		return false; 
	}

	switch( type )
	{
		case "MOD_UNKNOWN":
		case "MOD_CRUSH": 
		case "MOD_TELEFRAG":
		case "MOD_FALLING": 
		case "MOD_SUICIDE": 
		case "MOD_TRIGGER_HURT":
		case "MOD_BURNED":	
			return false; 
		case "MOD_MELEE":	
//Z2	HasPerk( "specialty_altmelee" ) is returning undefined
// 			if( isPlayer( attacker ) && randomFloat( 1 ) > 0.25 && attacker HasPerk( "specialty_altmelee" ) )
// 			{
// 				return true;
// 			}
// 			else 
			{
				return false;
			}
	}

	if( type == "MOD_PISTOL_BULLET" || type == "MOD_RIFLE_BULLET" )
	{
		if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
		{
			return false; 
		}

		weapon = attacker GetCurrentWeapon(); 

		if( weapon == "none" || weapon == level.start_weapon )
		{
			return false; 
		}

		if( WeaponIsGasWeapon( self.weapon ) )
		{
			return false; 
		}
	}

//	println( "**DEBUG amount = ", amount );
//	println( "**DEBUG self.head_gibbed = ", self.head_gibbed );
//	println( "**DEBUG self.health = ", self.health );

	prev_health = amount + self.health;
	if( prev_health <= 0 )
	{
		prev_health = 1;
	}

	damage_percent = ( amount / prev_health ) * 100; 

	if( damage_percent < 10 /*|| damage_percent >= 100*/ )
	{
		return false; 
	}

	return true; 
}

// SRS 9/7/2008: need to derive damage location for types that return location of "none"
derive_damage_refs( point )
{
	if( !IsDefined( level.gib_tags ) )
	{
		init_gib_tags();
	}
	
	closestTag = undefined;
	
	for( i = 0; i < level.gib_tags.size; i++ )
	{
		if( !IsDefined( closestTag ) )
		{
			closestTag = level.gib_tags[i];
		}
		else
		{
			if( DistanceSquared( point, self GetTagOrigin( level.gib_tags[i] ) ) < DistanceSquared( point, self GetTagOrigin( closestTag ) ) )
			{
				closestTag = level.gib_tags[i];
			}
		}
	}
	
	refs = [];
	
	// figure out the refs based on the tag returned
	if( closestTag == "J_SpineLower" || closestTag == "J_SpineUpper" || closestTag == "J_Spine4" )
	{
		// HACK the torso that gets swapped for guts also removes the left arm
		//  so we need to sometimes do another ref
		refs[refs.size] = "guts";
		refs[refs.size] = "right_arm";
	}
	else if( closestTag == "J_Shoulder_LE" || closestTag == "J_Elbow_LE" || closestTag == "J_Wrist_LE" )
	{
		refs[refs.size] = "left_arm";
	}
	else if( closestTag == "J_Shoulder_RI" || closestTag == "J_Elbow_RI" || closestTag == "J_Wrist_RI" )
	{
		refs[refs.size] = "right_arm";
	}
	else if( closestTag == "J_Hip_LE" || closestTag == "J_Knee_LE" || closestTag == "J_Ankle_LE" )
	{
		refs[refs.size] = "left_leg";
		refs[refs.size] = "no_legs";
	}
	else if( closestTag == "J_Hip_RI" || closestTag == "J_Knee_RI" || closestTag == "J_Ankle_RI" )
	{
		refs[refs.size] = "right_leg";
		refs[refs.size] = "no_legs";
	}
	
	assert( array_validate( refs ), "get_closest_damage_refs(): couldn't derive refs from closestTag " + closestTag );
	
	return refs;
}


//
init_gib_tags()
{
	tags = [];
					
	// "guts", "right_arm", "left_arm", "right_leg", "left_leg", "no_legs"
	
	// "guts"
	tags[tags.size] = "J_SpineLower";
	tags[tags.size] = "J_SpineUpper";
	tags[tags.size] = "J_Spine4";
	
	// "left_arm"
	tags[tags.size] = "J_Shoulder_LE";
	tags[tags.size] = "J_Elbow_LE";
	tags[tags.size] = "J_Wrist_LE";
	
	// "right_arm"
	tags[tags.size] = "J_Shoulder_RI";
	tags[tags.size] = "J_Elbow_RI";
	tags[tags.size] = "J_Wrist_RI";
	
	// "left_leg"/"no_legs"
	tags[tags.size] = "J_Hip_LE";
	tags[tags.size] = "J_Knee_LE";
	tags[tags.size] = "J_Ankle_LE";
	
	// "right_leg"/"no_legs"
	tags[tags.size] = "J_Hip_RI";
	tags[tags.size] = "J_Knee_RI";
	tags[tags.size] = "J_Ankle_RI";
	
	level.gib_tags = tags;
}


//
//
zombie_can_drop_powerups( zombie )
{
	if( level.mutators["mutator_noPowerups"] )
	{
		return false;
	}

	if( is_tactical_grenade( zombie.damageweapon ) || !flag( "zombie_drop_powerups" ) )
	{
		return false;
	}

	if ( isdefined(zombie.no_powerups) && zombie.no_powerups )
	{
		return false;
	}
	
	return true;
}


//
//	award points on death
zombie_death_points( origin, mod, hit_location, attacker, zombie,team )
{
	if( !IsDefined( attacker ) || !IsPlayer( attacker ) )
	{
		return; 
	}


	if( zombie_can_drop_powerups( zombie ) )
	{
		// DCS 031611: hack to prevent risers from dropping powerups under the ground.
		if(IsDefined(zombie.in_the_ground) && zombie.in_the_ground == true)
		{
			trace = BulletTrace(zombie.origin + (0, 0, 100), zombie.origin + (0, 0, -100), false, undefined);
			origin = trace["position"];
			level thread maps\mp\zombies\_zm_powerups::powerup_drop( origin );
		}
		else
		{	
			trace = GroundTrace(zombie.origin + (0, 0, 5), zombie.origin + (0, 0, -300), false, undefined);
			origin = trace["position"];
			level thread maps\mp\zombies\_zm_powerups::powerup_drop( origin );
		}	
	}

	//AUDIO: Ayers - Decides what vox to play after killing a zombie
	level thread maps\mp\zombies\_zm_audio::player_zombie_kill_vox( hit_location, attacker, mod, zombie );

	event = "death";
	if ( (issubstr( zombie.damageweapon, "knife_ballistic_" )) && (mod == "MOD_MELEE" || mod == "MOD_IMPACT") )
	{
		event = "ballistic_knife_death";
	}

	attacker maps\mp\zombies\_zm_score::player_add_points( event, mod, hit_location,undefined,team ); 
}

get_number_variants(aliasPrefix)
{
		for(i=0; i<100; i++)
		{
			if( !SoundExists( aliasPrefix + "_" + i) )
			{
				//iprintlnbold(aliasPrefix +"_" + i);
				return i;
			}
		}
}	


dragons_breath_flame_death_fx()
{
	if ( self.isdog )
	{
		return;
	}

	if( !IsDefined( level._effect ) || !IsDefined( level._effect["character_fire_death_sm"] ) )
	{
/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_death_sm\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_player_sm\"" );
#/
		return;
	}

	PlayFxOnTag( level._effect["character_fire_death_sm"], self, "J_SpineLower" );

	tagArray = []; 
	if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "left_arm" )
	{
		tagArray[tagArray.size] = "J_Elbow_LE";
		tagArray[tagArray.size] = "J_Wrist_LE";
	}
	if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "right_arm" )
	{
		tagArray[tagArray.size] = "J_Elbow_RI";
		tagArray[tagArray.size] = "J_Wrist_RI";
	}
	if( !IsDefined( self.a.gib_ref ) || (self.a.gib_ref != "no_legs" && self.a.gib_ref != "left_leg") )
	{
		tagArray[tagArray.size] = "J_Knee_LE";
		tagArray[tagArray.size] = "J_Ankle_LE";
	}
	if( !IsDefined( self.a.gib_ref ) || (self.a.gib_ref != "no_legs" && self.a.gib_ref != "right_leg") )
	{
		tagArray[tagArray.size] = "J_Knee_RI";
		tagArray[tagArray.size] = "J_Ankle_RI";
	}

	tagArray = array_randomize( tagArray ); 
	PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] );
}


// Called from animscripts\zm_death.gsc
zombie_death_animscript()
{
	team = undefined;
	
	if(isDefined(self._race_team))
	{
		team = self._race_team;
	}
	
	self reset_attack_spot();

	if ( self check_zombie_death_animscript_callbacks() )
	{
		return false;
	}

	if( self maps\mp\zombies\_zm_weap_tesla::enemy_killed_by_tesla() || self maps\mp\zombies\_zm_weap_thundergun::enemy_killed_by_thundergun() )
	{
		return false;
	}
	
	if ( self maps\mp\zombies\_zm_weap_freezegun::should_do_freezegun_death( self.damagemod ) )
	{
		self thread maps\mp\zombies\_zm_weap_freezegun::freezegun_death( self.damagelocation, self.origin, self.attacker );

		if ( "MOD_EXPLOSIVE" == self.damagemod )
		{
			// no points awarded for damage or deaths dealt by the shatter result
			return false;
		}
	}
	
	// animscript override
	if( IsDefined( level.zombie_death_animscript_override ) )
	{
		self [ [ level.zombie_death_animscript_override ] ] ();
	}

	// If no_legs, then use the AI no-legs death
	if( self.has_legs && IsDefined( self.a.gib_ref ) && self.a.gib_ref == "no_legs" )
	{
		self.deathanim = "zm_death";
	}

	self.grenadeAmmo = 0;

	// rsh090710 - nuked zombies don't give points but should still possibly drop powerups
	if ( IsDefined( self.nuked ) )
	{
		if( zombie_can_drop_powerups( self ) )
		{
			// DCS 031611: hack to prevent risers from dropping powerups under the ground.
			if(IsDefined(self.in_the_ground) && self.in_the_ground == true)
			{
				trace = BulletTrace(self.origin + (0, 0, 100), self.origin + (0, 0, -100), false, undefined);
				origin = trace["position"];
				level thread maps\mp\zombies\_zm_powerups::powerup_drop( origin );
			}
			else
			{	
				trace = GroundTrace(self.origin + (0, 0, 5), self.origin + (0, 0, -300), false, undefined);
				origin = trace["position"];
				level thread maps\mp\zombies\_zm_powerups::powerup_drop( self.origin );
			}	
		}
	}
	else
	{
		// Give attacker points
		//ChrisP - 12/8/08 - added additional 'self' argument		
		level zombie_death_points( self.origin, self.damagemod, self.damagelocation, self.attacker, self ,team);
	}

	// switch to inflictor when SP DoDamage supports it
	if( isdefined( self.attacker ) && isai( self.attacker ) )
	{
		self.attacker notify( "killed", self );
	}
	

	if( "rottweil72_upgraded_zm" == self.damageweapon && "MOD_RIFLE_BULLET" == self.damagemod )
	{
		self thread dragons_breath_flame_death_fx();
	}
	if( self.damagemod == "MOD_BURNED" )
	{
		self thread maps\mp\animscripts\zm_death::flame_death_fx();
	}
	if( self.damagemod == "MOD_GRENADE" || self.damagemod == "MOD_GRENADE_SPLASH" ) 
	{
		level notify( "zombie_grenade_death", self.origin );
	}

	return false;
}


check_zombie_death_animscript_callbacks()
{
	if ( !isdefined( level.zombie_death_animscript_callbacks ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_death_animscript_callbacks.size; i++ )
	{
		if ( self [[ level.zombie_death_animscript_callbacks[i] ]]() )
		{
			return true;
		}
	}

	return false;
}


register_zombie_death_animscript_callback( func )
{
	if ( !isdefined( level.zombie_death_animscript_callbacks ) )
	{
		level.zombie_death_animscript_callbacks = [];
	}

	level.zombie_death_animscript_callbacks[level.zombie_death_animscript_callbacks.size] = func;
}


damage_on_fire( player )
{
	self endon ("death");
	self endon ("stop_flame_damage");
	wait( 2 );
	
	while( isdefined( self.is_on_fire) && self.is_on_fire )
	{
		if( level.round_number < 6 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.2, 0.3 ); // 20% - 30%
		}
		else if( level.round_number < 9 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.15, 0.25 );
		}
		else if( level.round_number < 11 )
		{
			dmg = level.zombie_health * RandomFloatRange( 0.1, 0.2 );
		}
		else
		{
			dmg = level.zombie_health * RandomFloatRange( 0.1, 0.15 );
		}

		if ( Isdefined( player ) && Isalive( player ) )
		{
			self DoDamage( dmg, self.origin, player );
		}
		else
		{
			self DoDamage( dmg, self.origin, level );
		}
		
		wait( randomfloatrange( 1.0, 3.0 ) );
	}
}

player_using_hi_score_weapon( player )
{
	weapon = player GetCurrentWeapon(); 
	if( weapon == "none" || WeaponIsSemiAuto( weapon ) )
	{
		return( 1 );
	}
	return( 0 );
}

zombie_damage( mod, hit_location, hit_origin, player, amount,team )
{
				
	
/#	println( "ZM >> zombie_damage mod="+mod );	#/
	if( is_magic_bullet_shield_enabled( self ) )
	{
		return;
	}

	//ChrisP - 12/8 - no points for killing gassed zombies!
	player.use_weapon_type = mod;
	if(isDefined(self.marked_for_death))
	{
		return;
	}	

	if( !IsDefined( player ) )
	{
		return; 
	}

	if ( self check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount ) )
	{
		return;
	}
	else if( self zombie_flame_damage( mod, player ) )
	{
		if( self zombie_give_flame_damage_points() )
		{
			player maps\mp\zombies\_zm_score::player_add_points( "damage", mod, hit_location, self.isdog,team );
		}
	}
	else if( self maps\mp\zombies\_zm_weap_tesla::is_tesla_damage( mod ) )
	{
		self maps\mp\zombies\_zm_weap_tesla::tesla_damage_init( hit_location, hit_origin, player );
		return;
	}
	else
	{
		if ( self maps\mp\zombies\_zm_weap_freezegun::is_freezegun_damage( self.damagemod ) )
		{
			self thread maps\mp\zombies\_zm_weap_freezegun::freezegun_damage_response( player, amount );
		}

		// no points awarded for damage or deaths dealt by the shatter result

	if ( !maps\mp\zombies\_zm_weap_freezegun::is_freezegun_shatter_damage( self.damagemod ) )
		{
			if( player_using_hi_score_weapon( player ) )
			{
				damage_type = "damage";
			}
			else
			{
				damage_type = "damage_light";
			}

		/#	println( "ZM >> zombie_damage damage_type="+damage_type );	#/
			
			if ( !is_true( self.no_damage_points ) )
			{
				player maps\mp\zombies\_zm_score::player_add_points( damage_type, mod, hit_location, self.isdog,team );
			}
		}
	}

	if ( IsDefined( self.zombie_damage_fx_func ) )
	{
		self [[ self.zombie_damage_fx_func ]]( mod, hit_location, hit_origin, player );
	}

/#	println( "ZM >> remove_mod_from_methodofdeath PRE mod="+mod );	#/
	modName = remove_mod_from_methodofdeath( mod );
/#	println( "ZM >> remove_mod_from_methodofdeath POST modName="+modName );	#/

	if ( self maps\mp\zombies\_zm_weap_freezegun::is_freezegun_damage( self.damagemod ) )
	{
		; // no scaling damage for the freezegun
	}
	else if( is_placeable_mine( self.damageweapon ) )
	{
		if ( IsDefined( self.zombie_damage_claymore_func ) )
		{
			self [[ self.zombie_damage_claymore_func ]]( mod, hit_location, hit_origin, player );
		}
		else if ( isdefined( player ) && isalive( player ) )
		{
			self DoDamage( level.round_number * randomintrange( 100, 200 ), self.origin, player);
		}
		else
		{
			self DoDamage( level.round_number * randomintrange( 100, 200 ), self.origin, undefined );
		}
	}
	else if ( mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH" )
	{
		if ( isdefined( player ) && isalive( player ) )
		{
			self DoDamage( level.round_number + randomintrange( 100, 200 ), self.origin, player, self, hit_location, modName );
		}
		else
		{
			self DoDamage( level.round_number + randomintrange( 100, 200 ), self.origin, undefined, self, hit_location, modName );
		}
	}
	else if( mod == "MOD_PROJECTILE" || mod == "MOD_EXPLOSIVE" || mod == "MOD_PROJECTILE_SPLASH" )
	{
		if ( isdefined( player ) && isalive( player ) )
		{
			self DoDamage( level.round_number * randomintrange( 0, 100 ), self.origin, player, self, hit_location, modName );
		}
		else
		{
			self DoDamage( level.round_number * randomintrange( 0, 100 ), self.origin, undefined, self, hit_location, modName );
		}
	}
	
	//AUDIO Plays a sound when Crawlers are created
	if( IsDefined( self.a.gib_ref ) && (self.a.gib_ref == "no_legs") && isalive( self ) )
	{
		if ( isdefined( player ) )
		{
			rand = randomintrange(0, 100);
			if(rand < 10)
			{
				player create_and_play_dialog( "general", "crawl_spawn" );
			}
		}
	}
	else if( IsDefined( self.a.gib_ref ) && ( (self.a.gib_ref == "right_arm") || (self.a.gib_ref == "left_arm") ) )
	{
		if( self.has_legs && isalive( self ) )
		{
			if ( isdefined( player ) )
			{
				rand = randomintrange(0, 100);
				if(rand < 7)
				{
					player create_and_play_dialog( "general", "shoot_arm" );
				}
			}
		}
	}	
	
/#	println( "ZM >> zombie_damage check_for_instakill" );	#/
	self thread maps\mp\zombies\_zm_powerups::check_for_instakill( player, mod, hit_location );
}

zombie_damage_ads( mod, hit_location, hit_origin, player, amount,team )
{
	
	if( is_magic_bullet_shield_enabled( self ) )
	{
		return;
	}

	player.use_weapon_type = mod;
	if( !IsDefined( player ) )
	{
		return; 
	}

	if ( self check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount ) )
	{
		return;
	}
	else if( self zombie_flame_damage( mod, player ) )
	{
		if( self zombie_give_flame_damage_points() )
		{			
			player maps\mp\zombies\_zm_score::player_add_points( "damage_ads", mod, hit_location,undefined,team );
		}
	}
	else if( self maps\mp\zombies\_zm_weap_tesla::is_tesla_damage( mod ) )
	{
		self maps\mp\zombies\_zm_weap_tesla::tesla_damage_init( hit_location, hit_origin, player );
		return;
	}
	else
	{
		if ( self maps\mp\zombies\_zm_weap_freezegun::is_freezegun_damage( self.damagemod ) )
		{
			self thread maps\mp\zombies\_zm_weap_freezegun::freezegun_damage_response( player, amount );
		}

		// no points awarded for damage or deaths dealt by the shatter result
		if ( !self maps\mp\zombies\_zm_weap_freezegun::is_freezegun_shatter_damage( self.damagemod ) )
		{
			if( player_using_hi_score_weapon( player ) )
			{
				damage_type = "damage";
			}
			else
			{
				damage_type = "damage_light";
			}

			if ( !is_true( self.no_damage_points ) )
			{				
				player maps\mp\zombies\_zm_score::player_add_points( damage_type, mod, hit_location ,undefined,team);
			}
		}
	}

	self thread maps\mp\zombies\_zm_powerups::check_for_instakill( player, mod, hit_location );
}


check_zombie_damage_callbacks( mod, hit_location, hit_origin, player, amount )
{
	if ( !isdefined( level.zombie_damage_callbacks ) )
	{
		return false;
	}

	for ( i = 0; i < level.zombie_damage_callbacks.size; i++ )
	{
		if ( self [[ level.zombie_damage_callbacks[i] ]]( mod, hit_location, hit_origin, player, amount ) )
		{
			return true;
		}
	}

	return false;
}


register_zombie_damage_callback( func )
{
	if ( !isdefined( level.zombie_damage_callbacks ) )
	{
		level.zombie_damage_callbacks = [];
	}

	level.zombie_damage_callbacks[level.zombie_damage_callbacks.size] = func;
}


zombie_give_flame_damage_points()
{
	if( GetTime() > self.flame_damage_time )
	{
		self.flame_damage_time = GetTime() + level.zombie_vars["zombie_flame_dmg_point_delay"];
		return true;
	}

	return false;
}

zombie_flame_damage( mod, player )
{
	if( mod == "MOD_BURNED" )
	{
		if( !IsDefined( self.is_on_fire ) || ( Isdefined( self.is_on_fire ) && !self.is_on_fire ) )
		{
			self thread damage_on_fire( player );
		}

		do_flame_death = true;
		dist = 100 * 100;
		ai = GetAiArray( "axis" );
		for( i = 0; i < ai.size; i++ )
		{
			if( IsDefined( ai[i].is_on_fire ) && ai[i].is_on_fire )
			{
				if( DistanceSquared( ai[i].origin, self.origin ) < dist )
				{
					do_flame_death = false;
					break;
				}
			}
		}

		if( do_flame_death )
		{
			self thread maps\mp\animscripts\zm_death::flame_death_fx();
		}

		return true;
	}

	return false;
}


zombie_death_event( zombie )
{
	zombie waittill( "death" );

	// Need to check in case he got deleted earlier
	if ( !IsDefined( zombie ) )
	{
		return;
	}
	
	//Track all zombies killed
	level.global_zombies_killed++;

	//track stats on zombies killed by traps 
	if(isDefined(zombie.marked_for_death) && !isDefined(zombie.nuked))
	{
		level.zombie_trap_killed_count++;
	}
	
	zombie check_zombie_death_event_callbacks();

	// this gets called before the freezegun gets a chance to set freezegun_death, so we check whether it will do it
	if ( !zombie maps\mp\zombies\_zm_weap_freezegun::should_do_freezegun_death( zombie.damagemod ) )
	{
		zombie thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( "death", zombie.animname );
		zombie thread zombie_eye_glow_stop();
	}

	if ( maps\mp\zombies\_zm_weapons::is_weapon_included( "freezegun_zm" ) )
	{
		zombie thread maps\mp\zombies\_zm_weap_freezegun::freezegun_clear_extremity_damage_fx();
		zombie thread maps\mp\zombies\_zm_weap_freezegun::freezegun_clear_torso_damage_fx();
	}

	// this is controlling killstreak voice over in the asylum.gsc
	if(isdefined (zombie.attacker) && isplayer(zombie.attacker) )
	{
		
		//this tracks the zombies killed by a player for stat tracking
		level.zombie_player_killed_count++;
		
		if(!isdefined ( zombie.attacker.killcounter))
		{
			zombie.attacker.killcounter = 1;
		}
		else
		{
			zombie.attacker.killcounter ++;
		}
		
		if ( IsDefined( zombie.sound_damage_player ) && zombie.sound_damage_player == zombie.attacker )
		{	
			zombie.attacker maps\mp\zombies\_zm_audio::create_and_play_dialog( "kill", "damage" );	
		}

		zombie.attacker notify( "zom_kill", zombie );

		damageloc = zombie.damagelocation;
		damagemod = zombie.damagemod;
		attacker = zombie.attacker;
		weapon = zombie.damageWeapon;

		bbPrint( "zombie_kills: round %d zombietype zombie damagetype %s damagelocation %s playername %s playerweapon %s playerx %f playery %f playerz %f zombiex %f zombiey %f zombiez %f",
				level.round_number, damagemod, damageloc, attacker.name, weapon, attacker.origin, zombie.origin );
	}
	else
	{
		if(zombie.ignoreall && !is_true(zombie.marked_for_death)  )
		{
			level.zombies_timeout_spawn++;
		}
	}
		
	level notify( "zom_kill" );
	level.total_zombies_killed++;
}


check_zombie_death_event_callbacks()
{
	if ( !isdefined( level.zombie_death_event_callbacks ) )
	{
		return;
	}

	for ( i = 0; i < level.zombie_death_event_callbacks.size; i++ )
	{
		self [[ level.zombie_death_event_callbacks[i] ]]();
	}
}


register_zombie_death_event_callback( func )
{
	if ( !isdefined( level.zombie_death_event_callbacks ) )
	{
		level.zombie_death_event_callbacks = [];
	}

	level.zombie_death_event_callbacks[level.zombie_death_event_callbacks.size] = func;
}

deregister_zombie_death_event_callback( func )
{
	if (isdefined( level.zombie_death_event_callbacks ) )
	{
		ArrayRemoveValue(level.zombie_death_event_callbacks,func);
	}	
}


// this is where zombies go into attack mode, and need different attributes set up
zombie_setup_attack_properties()
{
	self zombie_history( "zombie_setup_attack_properties()" );

	// allows zombie to attack again
	self.ignoreall = false; 

	// push the player out of the way so they use traversals in the house.
	//self PushPlayer( true ); 

	self.pathEnemyFightDist = 64;
	self.meleeAttackDist = 64;
	
	//try to prevent always turning towards the enemy
	self.maxsightdistsqrd = 128 * 128;

	// turn off transition anims
	self.disableArrivals = true; 
	self.disableExits = true; 
}


//this lets them wake up and go after things like the monkey bomb immediately
attractors_generated_listener()
{
	self endon( "death" );
	level endon( "intermission" );
	self endon( "stop_find_flesh" );
	self endon( "path_timer_done" );

	level waittill( "attractor_positions_generated" );
	self.zombie_path_timer = 0;
}


zombie_pathing()
{
	self endon( "death" );
	self endon( "zombie_acquire_enemy" );
	level endon( "intermission" );

	assert( IsDefined( self.favoriteenemy ) || IsDefined( self.enemyoverride ) );

	self thread zombie_follow_enemy();
	self waittill( "bad_path" );
	
	level.zombie_pathing_failed ++;
	
	//If we get here then we have a bad path and the zombie can't use the regular pathing system to find the player
	//.....  crap!
	
	if( isDefined( self.enemyoverride ) ) 
	{
		debug_print( "Zombie couldn't path to point of interest at origin: " + self.enemyoverride[0] + " Falling back to breadcrumb system" );
		if( isDefined( self.enemyoverride[1] ) )
		{
			self.enemyoverride = self.enemyoverride[1] invalidate_attractor_pos( self.enemyoverride, self );
			self.zombie_path_timer = 0;
			return;
		}
	}
	else
	{
		if(isDefined(self.favoriteenemy))
		{
			debug_print( "Zombie couldn't path to player at origin: " + self.favoriteenemy.origin + " Falling back to breadcrumb system" );
		}
		else
		{
			debug_print( "Zombie couldn't path to a player ( the other 'prefered' player might be ignored for encounters mode ). Falling back to breadcrumb system" );
		}
	}
	
	if( !isDefined( self.favoriteenemy ) )
	{
		self.zombie_path_timer = 0;
		return;
	}
	else
	{
		self.favoriteenemy endon( "disconnect" );
	}
	
	//this is for selecting the valid player from the player to use for tracking purposes.
	players = GET_PLAYERS();
	valid_player_num = 0;
	for( i = 0; i < players.size; i++ )
	{
		if( is_player_valid( players[i], true ) ) 
		{
			valid_player_num += 1;
		}
	}
	//PI_CHANGE_BEGIN - 7/2/2009 JV Reenabling change 274916 (from DLC3)
	if( players.size > 1 )
	{
		if(isDefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]() )
		{
			self.zombie_path_timer = 0;
			return;	
		}
		if( array_check_for_dupes( self.ignore_player, self.favoriteenemy) )
		{
			self.ignore_player[self.ignore_player.size] = self.favoriteenemy;
		}

		if( self.ignore_player.size < valid_player_num )
		{
			self.zombie_path_timer = 0;
			return;
		}
	}
	//PI_CHANGE_END

	crumb_list = self.favoriteenemy.zombie_breadcrumbs;
	bad_crumbs = [];
	
	while( 1 )
	{
		if( !is_player_valid( self.favoriteenemy, true ) )
		{
			self.zombie_path_timer = 0;
			return;
		}

		goal = zombie_pathing_get_breadcrumb( self.favoriteenemy.origin, crumb_list, bad_crumbs, ( RandomInt( 100 ) < 20 ) );
		
		if ( !IsDefined( goal ) )
		{
			debug_print( "Zombie exhausted breadcrumb search" );
			
			//zombies failed to get breadcrumbs
			level.zombie_breadcrumb_failed ++;
			
			goal = self.favoriteenemy.spectator_respawn.origin;
		}

		debug_print( "Setting current breadcrumb to " + goal );

		self.zombie_path_timer += 100;
		self SetGoalPos( goal );
		self waittill( "bad_path" );

		debug_print( "Zombie couldn't path to breadcrumb at " + goal + " Finding next breadcrumb" );
		for( i = 0; i < crumb_list.size; i++ )
		{
			if( goal == crumb_list[i] )
			{
				bad_crumbs[bad_crumbs.size] = i;
				break;
			}
		}
	}
}

zombie_pathing_get_breadcrumb( origin, breadcrumbs, bad_crumbs, pick_random )
{
	assert( IsDefined( origin ) );
	assert( IsDefined( breadcrumbs ) );
	assert( IsArray( breadcrumbs ) );

	/#
		if ( pick_random )
		{
			debug_print( "Finding random breadcrumb" );
		}
	#/
			
	for( i = 0; i < breadcrumbs.size; i++ )
	{
		if ( pick_random )
		{
			crumb_index = RandomInt( breadcrumbs.size );
		}
		else
		{
			crumb_index = i;
		}
				
		if( crumb_is_bad( crumb_index, bad_crumbs ) )
		{
			continue;
		}

		return breadcrumbs[crumb_index];
	}

	return undefined;
}

crumb_is_bad( crumb, bad_crumbs )
{
	for ( i = 0; i < bad_crumbs.size; i++ )
	{
		if ( bad_crumbs[i] == crumb )
		{
			return true;
		}
	}

	return false;
}

jitter_enemies_bad_breadcrumbs( start_crumb )
{
	trace_distance = 35;
	jitter_distance = 2;
	
	index = start_crumb;
	
	while (isdefined(self.favoriteenemy.zombie_breadcrumbs[ index + 1 ]))
	{
		current_crumb = self.favoriteenemy.zombie_breadcrumbs[ index ];
		next_crumb = self.favoriteenemy.zombie_breadcrumbs[ index + 1 ];
		
		angles = vectortoangles(current_crumb - next_crumb);
		
		right = anglestoright(angles);
		left = anglestoright(angles + (0,180,0));
		
		dist_pos = current_crumb + VectorScale( right, trace_distance );
		
		trace = bulletTrace( current_crumb, dist_pos, true, undefined );
		vector = trace["position"];
		
		if (distance(vector, current_crumb) < 17 )
		{
			self.favoriteenemy.zombie_breadcrumbs[ index ] = current_crumb + VectorScale( left, jitter_distance );
			continue;
		}
		
		
		// try the other side
		dist_pos = current_crumb + VectorScale( left, trace_distance );
		
		trace = bulletTrace( current_crumb, dist_pos, true, undefined );
		vector = trace["position"];
		
		if (distance(vector, current_crumb) < 17 )
		{
			self.favoriteenemy.zombie_breadcrumbs[ index ] = current_crumb + VectorScale( right, jitter_distance );
			continue;
		}
		
		index++;
	}
	
}

zombie_follow_enemy()
{
	self endon( "death" );
	self endon( "zombie_acquire_enemy" );
	self endon( "bad_path" );
	
	level endon( "intermission" );

	while( 1 )
	{
		if( isDefined( self.enemyoverride ) && isDefined( self.enemyoverride[1] ) )
		{
			if( distanceSquared( self.origin, self.enemyoverride[0] ) > 1*1 )
			{
				self OrientMode( "face motion" );
			}
			else
			{
				self OrientMode( "face point", self.enemyoverride[1].origin );
			}
			self.ignoreall = true;
			self SetGoalPos( self.enemyoverride[0] );
		}
		else if( IsDefined( self.favoriteenemy ) )
		{
			self.ignoreall = false;
			self OrientMode( "face default" );

			// RAVEN bhackbarth: provide a callback to alter the goal pos depending on zombie/enemy state
			// 
			goalPos = self.favoriteenemy.origin;
			if ( IsDefined( level.enemy_location_override_func ) )
			{
				goalPos = [[ level.enemy_location_override_func ]]( self, self.favoriteenemy );
			}

			self SetGoalPos( goalPos );

			distSq = distanceSquared( self.origin, self.favoriteenemy.origin );
			
			extra_wait_time = 0;
			if( distSq > 3200 * 3200 )
			{
				extra_wait_time = 2.0 + randomFloat( 1.0 );
			}
			else if( distSq > 2200 * 2200 )
			{
				extra_wait_time = 1.0 + randomFloat( 0.5 );
			}
			else if( distSq > 1200 * 1200 )
			{
				extra_wait_time = 0.5 + randomFloat( 0.5 );
			}
			if( extra_wait_time > 0 )
			{
				wait extra_wait_time;
			}
		}

		// LDS - changed this from a level specific catch function to a general one that can be overloaded based
		//       on the conditions in a level that can render a player inaccessible to zombies.
		if( isDefined( level.inaccesible_player_func ) )
		{
			self [[ level.inaccessible_player_func ]]();
		}
		
		wait( 0.1 );
	}
}


// When a Zombie spawns, set his eyes to glowing.
zombie_eye_glow()
{
	if(!IsDefined(self))
	{
		return;
	}	
	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		//self haseyes(1);
		self SetClientField("zombie_has_eyes", 1);
	}
}

// Called when either the Zombie dies or if his head gets blown off
zombie_eye_glow_stop()
{
	if(!IsDefined(self))
	{
		return;
	}		
	if ( !isdefined( self.no_eye_glow ) || !self.no_eye_glow )
	{
		//self haseyes(0);
		self SetClientField("zombie_has_eyes", 0);
	}
}


//
// DEBUG
//

zombie_history( msg )
{
/#
	if( !IsDefined( self.zombie_history ) || 32 <= self.zombie_history.size ) // don't blow out the script var max
	{
		self.zombie_history = [];
	}

	self.zombie_history[self.zombie_history.size] = msg;
#/
}

do_zombie_spawn()
{
	self endon("death");

	spots = [];

	// special case, seems to appear in gamemodules. 
	if(isDefined(self._rise_spot))
	{
		spot = self._rise_spot;
		self thread do_zombie_rise(spot);
		return;
	}

	// add spawner locations
	if(IsDefined(level.zombie_spawn_locations))
	{
		for( i=0; i < level.zombie_spawn_locations.size; i++ )
		{
			spots[spots.size] = level.zombie_spawn_locations[i];
		}	
	}

	assert( spots.size > 0, "No spawn locations found" );

	spot = random(spots);
	
	// give target from spawn location to spawner to path
	if(IsDefined(spot.target))
	{
		self.target = spot.target;
	}	


	tokens = StrTok( spot.script_noteworthy, " " );
	foreach ( token in tokens )
	{
		if(token == "riser_location")
		{
			self thread do_zombie_rise(spot);
		}
		else if (token == "faller_location")
		{
			self thread maps\mp\zombies\_zm_ai_faller::do_zombie_fall(spot);	
		}
		else // just spawn where at and go.
		{
			self.anchor = spawn("script_origin", self.origin);
			self.anchor.angles = self.angles;
			self linkto(self.anchor);
	
			if( !isDefined( spot.angles ) )
			{
				spot.angles = (0, 0, 0);
			}
			
			self Ghost();
			self.anchor moveto(spot.origin, .05);
			self.anchor waittill("movedone");
			
			// face goal
			target_org = get_desired_origin();
			if (IsDefined(target_org))
			{
				anim_ang = VectorToAngles(target_org - self.origin);
				self.anchor RotateTo((0, anim_ang[1], 0), .05);
				self.anchor waittill("rotatedone");
			}
			if(isDefined(level.zombie_spawn_fx))
			{
				playfx(level.zombie_spawn_fx,spot.origin);
			}
			self unlink();
			if(isDefined(self.anchor))
			{
				self.anchor delete();
			}
			self Show();
	
			self notify("risen", spot.script_string );
		}
	}			
}

do_zombie_rise(spot)
{	
	self endon("death");

	self.in_the_ground = true;

	self.anchor = spawn("script_origin", self.origin);
	self.anchor.angles = self.angles;
	self linkto(self.anchor);

	if( !isDefined( spot.angles ) )
	{
		spot.angles = (0, 0, 0);
	}

	anim_org = spot.origin;
	anim_ang = spot.angles;

	anim_org = anim_org + (0, 0, -45);	// start the animation 45 units below the ground

	//self Teleport(anim_org, anim_ang);

	self Ghost();
	self.anchor moveto(anim_org, .05);
	self.anchor waittill("movedone");

	// face goal
	target_org = get_desired_origin();
	if (IsDefined(target_org))
	{
		anim_ang = VectorToAngles(target_org - self.origin);
		self.anchor RotateTo((0, anim_ang[1], 0), .05);
		self.anchor waittill("rotatedone");
	}

	self unlink();
	
	if(isDefined(self.anchor))
	{
		self.anchor delete();
	}

	self thread hide_pop();	// hack to hide the pop when the zombie gets to the start position before the anim starts

	level thread zombie_rise_death(self, spot);
	spot thread zombie_rise_fx(self);

	self AnimScripted( self.origin, spot.angles, "zm_rise" );
	self maps\mp\animscripts\zm_shared::DoNoteTracks( "rise_anim", ::handle_rise_notetracks, spot );

	self notify("rise_anim_finished");
	spot notify("stop_zombie_rise_fx");
	self.in_the_ground = false;
	self notify("risen", spot.script_string );
}


hide_pop()
{
	self endon( "death" );
	wait( 0.5 );
	if ( IsDefined( self ) )
	{
		self Show();
		wait_network_frame();
		if(IsDefined(self))
		{
			self.create_eyes = true;
		}
	}
}

handle_rise_notetracks(note, spot)
{
	// the anim notetracks control which death anim to play
	// default to "deathin" (still in the ground)

	if (note == "deathout" || note == "deathhigh")
	{
		self.zombie_rise_death_out = true;
		self notify("zombie_rise_death_out");

		wait 2;
		spot notify("stop_zombie_rise_fx");
	}
}

/*
zombie_rise_death:
Track when the zombie should die, set the death anim, and stop the animscripted so he can die
*/
zombie_rise_death(zombie, spot)
{
	//self.nodeathragdoll = true;
	zombie.zombie_rise_death_out = false;

	zombie endon("rise_anim_finished");

	while ( IsDefined( zombie ) && IsDefined( zombie.health ) && zombie.health > 1)	// health will only go down to 1 when playing animation with AnimScripted()
	{
		zombie waittill("damage", amount);
	}

	spot notify("stop_zombie_rise_fx");

	if ( IsDefined( zombie ) )
	{
		zombie.deathanim = zombie get_rise_death_anim();
		zombie StopAnimScripted();	// stop the anim so the zombie can die.  death anim is handled by the anim scripts.
	}
}

/*
zombie_rise_fx:	 self is the script struct at the rise location
Play the fx as the zombie crawls out of the ground and thread another function to handle the dust falling
off when the zombie is out of the ground.
*/
zombie_rise_fx(zombie)
{
	
	if(!is_true(level.riser_fx_on_client))
	{
		self thread zombie_rise_dust_fx(zombie);
		self thread zombie_rise_burst_fx(zombie);
	}
	else
	{
		self thread zombie_rise_burst_fx(zombie);
	}
	zombie endon("death");
	self endon("stop_zombie_rise_fx");
	wait 1;
	if (zombie.zombie_move_speed != "sprint")
	{
		// wait longer before starting billowing fx if it's not a really fast animation
		wait 1;
	}
}

zombie_rise_burst_fx(zombie)
{
	self endon("stop_zombie_rise_fx");
	self endon("rise_anim_finished");
	
	if(IsDefined(self.script_string) && self.script_string == "in_water" && (!is_true(level._no_water_risers)) )
	{
		if(is_true(level.riser_fx_on_client) )
		{
			zombie setclientflag(level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX_WATER);
  	}
  	else
  	{
    	playsoundatposition ("zmb_zombie_spawn_water", self.origin);
			playfx(level._effect["rise_burst_water"],self.origin + ( 0,0,randomintrange(5,10) ) );
			wait(.25);
			playfx(level._effect["rise_billow_water"],self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
		}
	}
	else if(IsDefined(self.script_string) && self.script_string == "in_snow")
	{
	
		if(is_true(level.riser_fx_on_client))
		{
			// this needs to have "level.riser_type = "snow" set in the level script to work properly in snow levels!
			zombie setclientflag(level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX);
  	}
  	else
  	{
			
    	playsoundatposition ("zmb_zombie_spawn_snow", self.origin);
			playfx(level._effect["rise_burst_snow"],self.origin + ( 0,0,randomintrange(5,10) ) );
			wait(.25);
			playfx(level._effect["rise_billow_snow"],self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
		}
	}
	else 
	{
		if(isDefined(zombie.zone_name ) && isDefined(level.zones[zombie.zone_name]) )
		{
			low_g_zones = getentarray(zombie.zone_name,"targetname");
			
			if(isDefined(low_g_zones[0].script_string) && low_g_zones[0].script_string == "lowgravity")
			{
				zombie setclientflag(level._ZOMBIE_ACTOR_ZOMBIE_RISER_LOWG_FX);
			}
			else
			{
				if(is_true(level.riser_fx_on_client))
				{
					zombie setclientflag(level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX);
				}
				else
				{
					playsoundatposition ("zmb_zombie_spawn", self.origin);
					playfx(level._effect["rise_burst"],self.origin + ( 0,0,randomintrange(5,10) ) );
					wait(.25);
					playfx(level._effect["rise_billow"],self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
				}
			}
		}
		else
		{
			if(is_true(level.riser_fx_on_client))
			{
				zombie setclientflag(level._ZOMBIE_ACTOR_ZOMBIE_RISER_FX);
			}
			else
			{
				playsoundatposition ("zmb_zombie_spawn", self.origin);
				playfx(level._effect["rise_burst"],self.origin + ( 0,0,randomintrange(5,10) ) );
				wait(.25);
				playfx(level._effect["rise_billow"],self.origin + ( randomintrange(-10,10),randomintrange(-10,10),randomintrange(5,10) ) );
			}
		}
	}	
}

zombie_rise_dust_fx(zombie)
{
	dust_tag = "J_SpineUpper";
	
	self endon("stop_zombie_rise_dust_fx");
	self thread stop_zombie_rise_dust_fx(zombie);

	dust_time = 7.5; // play dust fx for a max time
	dust_interval = .1; //randomfloatrange(.1,.25); // wait this time in between playing the effect
	
	//TODO - add rising dust stuff ere
	if(IsDefined(self.script_string) && self.script_string == "in_water")
	{

		for (t = 0; t < dust_time; t += dust_interval)
		{
			PlayfxOnTag(level._effect["rise_dust_water"], zombie, dust_tag);
			wait dust_interval;
		}

	}
	else if(IsDefined(self.script_string) && self.script_string == "in_snow")
	{

		for (t = 0; t < dust_time; t += dust_interval)
		{
			PlayfxOnTag(level._effect["rise_dust_snow"], zombie, dust_tag);
			wait dust_interval;
		}

	}
	else
	{
		for (t = 0; t < dust_time; t += dust_interval)
		{
		PlayfxOnTag(level._effect["rise_dust"], zombie, dust_tag);
		wait dust_interval;
		}
	}
}

stop_zombie_rise_dust_fx(zombie)
{
	zombie waittill("death");
	self notify("stop_zombie_rise_dust_fx");
}

get_rise_death_anim()
{
	if ( self.zombie_rise_death_out )
	{
		return "zm_rise_death_out";
	}

	return "zm_rise_death_in";
}


// for now only regular zombies can head gib from the tesla
zombie_tesla_head_gib()
{
	self endon("death");
	
	if(self.animname == "quad_zombie")
	{
		return;
	}	
	
	if( RandomInt( 100 ) < level.zombie_vars["tesla_head_gib_chance"] )
	{
		wait( randomfloatrange( 0.53, 1.0 ) );
		self zombie_head_gib();
	}
	else
	{
		network_safe_play_fx_on_tag( "tesla_death_fx", 2, level._effect["tesla_shock_eyes"], self, "J_Eyeball_LE" );
	}
}

play_ambient_zombie_vocals()
{
    self endon( "death" );
    
    if( self.animname == "monkey_zombie" )
	{
        return;
	}
    
    while(1)
    {
        type = "ambient";
        float = 2;
        
        if( !IsDefined( self.zombie_move_speed ) )
        {
            wait(.5);
            continue;
        }
        
        switch(self.zombie_move_speed)
	    {
			case "walk":    type="ambient"; float=4;    break;
			case "run":     type="sprint";  float=4;    break;
			case "sprint":  type="sprint";  float=4;    break;
		}
		
		if( self.animname == "zombie" && !self.has_legs )
		{
		    type = "crawler";
		}
		else if( self.animname == "thief_zombie" )
		{
		    float = 1.2;
		}
		
		self thread maps\mp\zombies\_zm_audio::do_zombies_playvocals( type, self.animname );
		
		wait(RandomFloatRange(1,float));
    }
}

zombie_complete_emerging_into_playable_area()
{
	self.completed_emerging_into_playable_area = true;
	self notify( "completed_emerging_into_playable_area" );
	self.no_powerups = false;
}
